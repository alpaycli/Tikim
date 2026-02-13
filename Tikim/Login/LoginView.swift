//
//  LoginView.swift
//  Tikim
//
//  Created by Alpay Calalli on 13.02.26.
//

import iPhoneNumberField
import SwiftUI

struct LoginView: View {
   @State var text: String = ""
   @State var isEditing: Bool = false
   @State var navigateToOtpView = false
   
   @Environment(\.dismiss) private var dismiss

    var body: some View {
       VStack {
          let placeholder = Text("(+994)").bold()
          iPhoneNumberField("\(placeholder) 000-0000", text: $text, isEditing: $isEditing)
//                   .flagHidden(false)
//                   .flagSelectable(true)
                   .font(UIFont(size: 14, weight: .regular))
                   .maximumDigits(10)
                   .foregroundColor(Color.pink)
                   .clearButtonMode(.whileEditing)
                   .onClear { _ in isEditing.toggle() }
                   .accentColor(Color.orange)
                   .padding()
                   .background(Color.white)
                   .cornerRadius(10)
                   .shadow(color: isEditing ? Color.gray : .white, radius: 10)
                   .padding()
          
          Button("Next") { navigateToOtpView = true }
       }
       .navigationDestination(isPresented: $navigateToOtpView) {
          OTPView()
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
    }
}

#Preview {
    NavigationStack{
       LoginView()
    }
}

struct OTPView: View {
   /// User Input
   @State private var numberCode = ""
   /// Correct code coming from an api
   @State private var correctCode = ""
   
   @State private var hasEnteredWrongCode = false
   
   @Environment(\.dismiss) private var dismiss
   
   
   @State var ottpViewWidth: CGFloat = 0
   
   @FocusState var focusState: Bool
   
   var body: some View {
      VStack {
         Circle().frame(width: 64, height: 64)
            .padding(.top, 29)
            .padding(.bottom, 12)
         
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
             borderColor: Color(hex: hasEnteredWrongCode ? "#FB3748" : "#EBEBEB")
         )
         .padding(.top, 32)
         .onGeometryChange(for: CGFloat.self) { proxy in
            return proxy.frame(in: .global).width
         } action: { newValue in
             ottpViewWidth = newValue
         }
         
         PrimaryButton(width: ottpViewWidth, height: 40) {
            guard numberCode == correctCode else {
               withAnimation {
                  hasEnteredWrongCode = true
               }
               return
            }
            
         } label: {
            Text("Login")
               .bold()
               .foregroundStyle(numberCode.count < 6 ? Color(hex: "#A4A7AE") : .white)
         }
         .padding(.top, 34)
         .disabled(numberCode.count < 6)
         
         VStack(spacing: 4) {
            if hasEnteredWrongCode {
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
      .sensoryFeedback(.warning, trigger: hasEnteredWrongCode)
   }
}

#Preview {
   OTPView()
}
