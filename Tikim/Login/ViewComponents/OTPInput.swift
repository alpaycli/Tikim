//
//  OTPInput.swift
//  Tikim
//
//  Created by Alpay Calalli on 13.02.26.
//

import SwiftUI

struct OTPInput: View {
    @Binding var text: String
    var digitCount: Int

    var numericOnly: Bool = false
    var isSecure: Bool = false
    
    var entrySize: CGSize = .init(width: 45, height: 64)
   var borderColor: Color = .init(hex: "#EBEBEB")
    var lineWidth: CGFloat = 1
    var spacing: CGFloat = 10

   var selectedFieldBorderColor: Color = .init(hex: "#171717")

    @FocusState private var focusedInput: Int?

    var body: some View {
        HStack(spacing: self.spacing) {
            ForEach(0..<digitCount, id: \.self, content: { index in
                _UITextFieldRepresentable(
                    fullText: $text,
                    numericOnly: self.numericOnly,
                    isSecure: self.isSecure,
                    index: index,
                    digitCount: self.digitCount,
                    setText: { string in
                        self.setTextAtIndex(string, at: index)
                    },
                    enterKeyPressed: {
                        self.enterKeyPressed()
                    },
                    emptyBackspaceKeyPressed: {
                        self.emptyBackspaceKeyPressed()
                    }
                )
                .frame(width: self.entrySize.width, height: self.entrySize.height, alignment: .center)
                .background {
                   RoundedRectangle(cornerRadius: 8, style: .continuous)
                      .stroke(focusedInput == index ? selectedFieldBorderColor : borderColor, lineWidth: 1)
                   
                   if focusedInput == index {
                      RoundedRectangle(cornerRadius: 8, style: .continuous)
                         .inset(by: -4)
                         .stroke(borderColor, lineWidth: 2)
//                         .padding()
                         
                   }
                }
                .tag(index)
                .focused($focusedInput, equals: index)
               
               if index == 2 {
                  RoundedRectangle(cornerRadius: 4)
                     .fill(Color(hex: "#EBEBEB"))
                     .frame(width: 12, height: 2)
               }
            })
        }
        .onChange(of: focusedInput, {
            // disallow focusing inputs after the first empty input
            if focusedInput ?? 0 > text.count {
                focusedInput = text.count
            }
        })
        .onAppear {
           focusedInput = 0
        }
    }
   
    
    private func setTextAtIndex(_ string: String, at index: Int) {
      
        let old = self.text
 
        let strBefore = old._prefix(index)
        let suffixLength = old.count - index - (string.isEmpty ? 1 : string.count)
        
        let strAfter = suffixLength <= 0 ? "" : old._suffix(suffixLength)
        
        var entry = string.removeNewlineWhitespaces
        if numericOnly {
            entry = entry.numericOnly
        }
        let new = (strBefore + entry + strAfter)._prefix(self.digitCount)

        self.text = new

        guard let focusedInput = self.focusedInput else {
            return
        }

        // change of an entered text
        if focusedInput <= old.count - 1 {
            // if delete, move to the previous one
            // else move to the one after inputting the string
            let newFocus = focusedInput + (string.isEmpty ? -1 : string.count)

            // if last entry is entered, remove all the focus
            self.focusedInput = newFocus >= digitCount ? nil : newFocus
            return
        }
        
        
        // entry on empty textfield
        let newFocus = new.count
        if newFocus >= digitCount {
            self.focusedInput = nil
            return
        }
        
        self.focusedInput = newFocus

    }
    
    private func enterKeyPressed() {
        self.focusedInput = nil
    }
    
    private func emptyBackspaceKeyPressed() {
        guard let focusedInput = self.focusedInput, focusedInput > 0 else {
            return
        }
        self.focusedInput = focusedInput - 1
    }

}

private struct _UITextFieldRepresentable: UIViewRepresentable {
    
    @Binding var fullText: String
    var numericOnly: Bool
    var isSecure: Bool

    var index: Int
    var digitCount: Int
    var setText: ((String) -> Void)
    var enterKeyPressed: (() -> Void)
    var emptyBackspaceKeyPressed: (() -> Void)

    func makeUIView(context: Context) -> UITextField {
        let textField = _UITextField()
        textField.emptyBackspaceKeyPressed = emptyBackspaceKeyPressed
        textField.text = self.getText()
       textField.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        textField.delegate = context.coordinator
        textField.textAlignment = .center
        textField.clearButtonMode = .never
        textField.autocorrectionType = .no

        textField.keyboardType = self.numericOnly ? .numberPad : .default
        textField.isSecureTextEntry = self.isSecure
        
        setSelection(textField)
        return textField
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = self.getText()
        self.setSelection(uiView)
        
        uiView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        uiView.setContentHuggingPriority(.defaultLow, for: .horizontal)
    }
    
    
    func setSelection(_ textField: UITextField) {
        guard let text = textField.text, !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        textField.selectedTextRange = textField.textRange(from: textField.beginningOfDocument, to: textField.endOfDocument)
    }
    
    func getText() -> String {
        if self.fullText.count <= self.index {
            return ""
        }
        return self.fullText.strAtIndex(self.index)
    }
}

extension _UITextFieldRepresentable {
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: _UITextFieldRepresentable
        
        private var shouldChangeTriggered = false

        init(_ control: _UITextFieldRepresentable) {
            self.parent = control
            super.init()
        }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            // to disable new line or text clear when there is a selection on return key pressed
            self.parent.enterKeyPressed()
            return false
        }
        
        func textFieldDidBeginEditing(_ textField: UITextField) {
            self.parent.setSelection(textField)
        }

        // to disable deselecting from using keyboard <- and -> 
        func textFieldDidChangeSelection(_ textField: UITextField) {
            self.parent.setSelection(textField)
        }
        
        
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            self.parent.setText(string)
            return false
        }
    }
}


private class _UITextField: UITextField {
    var emptyBackspaceKeyPressed: (() -> Void)?

    override func deleteBackward() {
        if text?.isEmpty == true {
            emptyBackspaceKeyPressed?()
        }
        super.deleteBackward()
    }
}



private extension String {

    func _prefix(_ length: Int) -> String {
        return String(self.prefix(length))
    }
    func _suffix(_ length: Int) -> String {
        return String(self.suffix(length))
    }
    
    var removeNewlineWhitespaces: String {
        return self.filter({!$0.isWhitespace && !$0.isNewline})
    }
    
    var numericOnly: String {
        return self.filter({ $0.isNumber })
    }
    
    func strAtIndex(_ int: Int) -> String {
        if int >= self.count { return "" }
        let stringIndex = self.toStringIndex(int)
        return String(self[stringIndex])
    }

    func toStringIndex(_ int: Int) -> String.Index {
        if int <= 0 {
            return self.startIndex
        }
        if int >= self.count {
            return self.endIndex
        }
        return self.index(self.startIndex, offsetBy: int)
    }
}
