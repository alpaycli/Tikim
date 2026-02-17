//
//  OTPView.swift
//  Tikim
//
//  Created by Alpay Calalli on 16.02.26.
//

import SwiftUI

struct OTPView: View {
   @Environment(\.dismiss) private var dismiss
   @FocusState private var focusState: Bool
   
   /// User Input
   @State private var numberCode = ""
   /// Correct code coming from an api
   @State private var correctCode = "123456"
   
   @State private var state: ViewState = .codeNotEntered
   
   
   // To adjust the button size relative to it.
   // Because otp field doesn't have constant width, each rectangle/field
   // has constant width, and their look vary on different screen sizes.
   @State var ottpViewWidth: CGFloat = 0
   
   var body: some View {
      VStack {
         Image("otp")
            .frame(width: 64, height: 64)
            .padding(.top, 29)
         
         VStack(spacing: 4) {
            Text("OTP Code")
               .font(.system(size: 24, weight: .medium))
            
            Text("Enter the 6-digit code sent to your number")
               .font(.system(size: 16))
         }
         .padding(.top, 12)

         OTPInput(
             text: $numberCode,
             digitCount: 6,
             numericOnly: true,
             borderColor: state.otpFieldBorderColor
         )
         .padding(.top, 32)
         .onGeometryChange(for: CGFloat.self) { proxy in
            return proxy.frame(in: .global).width
         } action: { newValue in
             ottpViewWidth = newValue
         }
         .onChange(of: numberCode) { _, new in print("new", new)}
         
         PrimaryButton(width: ottpViewWidth, height: 40) {
            guard numberCode == correctCode else {
               withAnimation {
                  state = .wrongCode
               }
               return
            }
            
            state = .correctCode
            
         } label: {
            Text("Login")
               .bold()
               .foregroundStyle(numberCode.count < 6 ? Color(hex: "#A4A7AE") : .white)
         }
         .padding(.top, 34)
         .disabled(numberCode.count < 6)
         
         VStack(spacing: 4) {
            if state == .wrongCode {
               Text("OTP-kod yanlışdır.")
                  .foregroundStyle(Color(hex: "#D92D20"))
                  .font(.system(size: 14))
            }
            Text("Experiencing issue receiving the code?")
               .foregroundStyle(.secondary)
            
            Button("Resend Code") {}
               .underline()
               .foregroundStyle(Color(hex: "#0355E3"))
         }
         .padding(.top, 24)
         .font(.system(size: 14))
         
     
      }
      .navigationBarBackButtonHidden()
      .toolbar {
         ToolbarItem(placement: .topBarLeading) {
            Button { dismiss() } label: {
               Label("Back", systemImage: "chevron.left")
                  .font(.system(size: 14))
                  .foregroundStyle(Color(hex: "#5C5C5C"))
               
            }
            .buttonStyle(.plain)
            .labelStyle(.titleAndIcon)
         }
      }
      .sensoryFeedback(.warning, trigger: state == .wrongCode)
   }
   
   private enum ViewState {
      case codeNotEntered
      case wrongCode
      case correctCode
      
      var otpFieldBorderColor: Color {
         switch self {
            case .codeNotEntered:
               Color(hex: "#EBEBEB")
            case .wrongCode:
               Color(hex: "#FB3748")
            case .correctCode:
               Color.green
         }
      }
   }
}

#Preview {
   OTPView()
}
