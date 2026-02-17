//
//  PrimaryButton.swift
//  Tikim
//
//  Created by Alpay Calalli on 12.02.26.
//

import SwiftUI

struct PrimaryButton<Label: View>: View {
    private let action: () -> Void
    private let label: Label
    
    @Environment(\.backgroundStyle) private var backgroundStyle
    @Environment(\.isEnabled) var isEnabled
   
   var width: CGFloat?
   var height: CGFloat? = 44
   
   @State private var triggerFeedback = false
        
    init(
      width: CGFloat? = nil,
      height: CGFloat? = nil,
        action: @escaping () -> Void,
        @ViewBuilder label: () -> Label
    ) {
        self.action = action
        self.label = label()
       self.width = width
       self.height = 44
    }
    
    var body: some View {
        Button {
           triggerFeedback = true
            action()
        } label: {
            label
                .containerRelativeFrame(.horizontal) { length, _ in
                   width == nil ? length - 48 : length
                }
                .frame(width: width, height: height)
//                .background(isEnabled ? backgroundStyle ?? AnyShapeStyle(Color(hex: "#0750D0")) : AnyShapeStyle(Color(hex: "#F5F5F5")))
//                .clipShape(.rect(cornerRadius: 8))
//                .clipShape{
//                   RoundedRectangle(cornerRadius: 8)
//                      .stroke(Color(hex: "#E9EAEB"), lineWidth: isEnabled ? 0 : 1)
//                }
                .background {
                   RoundedRectangle(cornerRadius: 8)
                      .stroke(Color(hex: "#E9EAEB"), lineWidth: isEnabled ? 0 : 2)
                      .fill(isEnabled ? backgroundStyle ?? AnyShapeStyle(Color(hex: "#0750D0")) : AnyShapeStyle(Color(hex: "#F5F5F5")))
                   
                   RoundedRectangle(cornerRadius: 10)
                      .inset(by: 2)
                      .stroke(.white.opacity(0.12), lineWidth: 2)
                }
                .sensoryFeedback(.impact, trigger: triggerFeedback)
        }
    }
}

extension PrimaryButton where Label == Text {
    init(
        _ titleKey: LocalizedStringKey,
        action: @escaping () -> Void
    ) {
        self.init(
            action: action,
            label: {
                Text(titleKey)
            }
        )
    }
}

extension PrimaryButton where Label == SwiftUI.Label<Text, Image> {
    init(
        _ titleKey: LocalizedStringKey,
        systemImage: String,
        action: @escaping () -> Void
    ) {
        self.init(
            action: action,
            label: {
                Label(titleKey, systemImage: systemImage)
            }
        )
    }
}

#Preview {
   PrimaryButton {
      withAnimation {}
   } label: {
      Text("Continue")
         .bold()
         .foregroundStyle(.white)
   }
   .padding(.top, 24)

}
