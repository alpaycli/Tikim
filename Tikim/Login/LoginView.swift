//
//  LoginView.swift
//  Tikim
//
//  Created by Alpay Calalli on 13.02.26.
//

import SwiftUI

struct LoginView: View {
   @State private var phoneNumber: String = ""
   @State private var isEditing: Bool = false
   @State private var navigateToOtpView = false
   
   @Environment(\.dismiss) private var dismiss
   
   @State private var wrongPhoneNumberFormat = false
   
   var body: some View {
      VStack {
         headerView
         
         VStack(alignment: .leading, spacing: 6) {
            Text("Phone Number")
            +
            Text(verbatim: " *").foregroundStyle(Color(hex: "#0750D0"))
               .foregroundStyle(Color(hex: "#414651"))
            
            phoneNumberField
         }
         .padding(.horizontal, 24)
         .padding(.top, 32)
         
         primaryButton
            .padding(.top, 24)
         
         Text("Enter details to login")
            .foregroundStyle(Color(hex: "#5C5C5C"))
            .font(.system(size: 16))
            .padding(.top, 32)
      }
      .navigationDestination(isPresented: $navigateToOtpView) {
         OTPView()
      }
      .navigationBarBackButtonHidden()
      .toolbar { toolbarBackButton }
   }
}

extension LoginView {
   private var headerView: some View {
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
   }
   
   private var phoneNumberField: some View {
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
   
   private var primaryButton: some View {
      PrimaryButton {
         withAnimation { navigateToOtpView = true }
      } label: {
         Text("Continue")
            .bold()
            .foregroundStyle(.white)
      }
      .disabled(wrongPhoneNumberFormat)
   }
   
   private var toolbarBackButton: some ToolbarContent {
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

#Preview {
   NavigationStack{
      LoginView()
   }
}
