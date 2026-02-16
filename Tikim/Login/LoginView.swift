//
//  LoginView.swift
//  Tikim
//
//  Created by Alpay Calalli on 13.02.26.
//

import iPhoneNumberField
import SwiftUI

struct LoginView: View {
   @State var phoneNumber: String = ""
   @State var isEditing: Bool = false
   @State var navigateToOtpView = false
   
   @Environment(\.dismiss) private var dismiss
   
   @State private var wrongPhoneNumberFormat = false

    var body: some View {
       VStack {
          VStack(spacing: 12) {
             Image("person")
                .resizable()
                .scaledToFit()
                .clipShape(.circle)
                .frame(width: 64, height: 64)
             
             Text("Login to your account")
                .foregroundStyle(Color(hex: "#171717"))
                .font(.system(size: 24))
          }
          
          VStack(alignment: .leading, spacing: 6) {
             Text("Phone Number")
             +
             Text(verbatim: " *").foregroundStyle(Color(hex: "#0750D0"))
                .foregroundStyle(Color(hex: "#414651"))
             
             VStack(alignment: .leading, spacing: 4) {
                PhoneNumberField(phoneNumber: $phoneNumber, wrongFormat: $wrongPhoneNumberFormat)
                if wrongPhoneNumberFormat {
                   HStack(spacing: 6) {
                      Image("error")
                         .resizable()
                         .scaledToFit()
                         .frame(width: 12, height: 12)
                      
                      Text("Nömrə düzgün qeyd olunmayıb")
                         .foregroundStyle(Color(hex: "#FB3748"))
                         .font(.system(size: 12))
                   }
                }
             }
          }
          .padding(.horizontal, 24)
          .padding(.top, 32)
          
          PrimaryButton {
             withAnimation { navigateToOtpView = true }
          } label: {
             Text("Continue")
                .bold()
                .foregroundStyle(.white)
          }
          .padding(.top, 24)
          .disabled(wrongPhoneNumberFormat)
          
          Text("Enter details to login")
             .foregroundStyle(Color(hex: "#5C5C5C"))
             .font(.system(size: 16))
             .padding(.top, 32)
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
struct PhoneNumberField: View {
    @Binding var phoneNumber: String
   @Binding var wrongFormat: Bool
   
   func formatPhoneNumber(input: String) -> String {
        let digits = input.filter { $0.isNumber }
        var result = ""
        for (index, digit) in digits.prefix(9).enumerated() {
            if index == 2 { result += " " }
            if index == 5 { result += " " }
            if index == 7 { result += " " }
            result += String(digit)
        }
        return result
    }
    var body: some View {
       HStack(spacing: 12) {
           HStack(spacing: 8) {
              Image("Azerbaijan-icon")
                 .resizable()
                 .scaledToFit()
                 .frame(width: 20, height: 20)
              
              Text(verbatim: "AZE")
                 .foregroundStyle(Color(hex: "#535862"))
                 .font(.system(size: 16))
           }
            .padding(.leading, 14)
           
           HStack {
              Text("+994")
              TextField("00 000 00 00", text: $phoneNumber)
              .keyboardType(.phonePad)
              .onChange(of: phoneNumber) { _, newValue in
                 phoneNumber = formatPhoneNumber(input: newValue)
                 wrongFormat = phoneNumber.count < 12
                 if newValue.count > 12 {
                    phoneNumber = String(phoneNumber.prefix(12))
                 }
              }
           }
        }
       .padding(.vertical, 12)
       .background {
          RoundedRectangle(cornerRadius: 8, style: .continuous)
             .stroke(Color(hex: wrongFormat ? "#FB3748" : "#D5D7DA"), lineWidth: 1)
             .shadow(
               color: Color(hex: wrongFormat ? "#FB3748" : "#0A0D120D").opacity(0.05),
               radius: 1,
               y: 1
             )
       }
    }
}


#Preview {
    NavigationStack{
       LoginView()
    }
}
