//
//  PhoneNumberField.swift
//  Tikim
//
//  Created by Alpay Calalli on 17.02.26.
//

import SwiftUI

struct PhoneNumberField: View {
   @Binding var phoneNumber: String
   @Binding var wrongFormat: Bool
   
   var body: some View {
      HStack(spacing: 12) {
         countryIndicatorsView
            .padding(.leading, 14)
         
         textField
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

extension PhoneNumberField {
   private var countryIndicatorsView: some View {
      HStack(spacing: 8) {
         Image("Azerbaijan-icon")
            .resizable()
            .scaledToFit()
            .frame(width: 20, height: 20)
         
         Text(verbatim: "AZE")
            .foregroundStyle(Color(hex: "#535862"))
            .font(.system(size: 16))
      }
   }
   
   private var textField: some View {
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
}

extension PhoneNumberField {
   private func formatPhoneNumber(input: String) -> String {
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
}
