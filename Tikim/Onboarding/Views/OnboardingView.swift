//
//  OnboardingView.swift
//  Tikim
//
//  Created by Alpay Calalli on 12.02.26.
//

import SwiftUI

struct OnboardingView: View {
   @State private var viewModel = OnboardingViewModel()
   var body: some View {
      NavigationStack {
         VStack {
            VStack(spacing: 8) {
               OnboardingCard(viewModel: viewModel)
                  .padding(.top, 24)
               
               TabIndicatorCapsulesView(totalTabsCount: viewModel.onboardingContent.count, currentTab: viewModel.currentIndex)
                  .backgroundStyle(AnyShapeStyle(Color(hex: "#0355E3")))
            }
            
            VStack(spacing: 26) {
               PrimaryButton {
                  withAnimation { viewModel.goToNextStep() }
               } label: {
                  Text("Next")
                     .bold()
                     .foregroundStyle(.white)
               }
               
               
               SecondaryButton {
                  viewModel.isFinished = true
               } label: {
                  Text("Skip")
                     .bold()
                     .foregroundStyle(Color(hex: "#414651"))
               }
            }
            .padding(.top, 58)
            
            AgreementTextView()
               .padding(.init(top: 24, leading: 24, bottom: 48, trailing: 24))
               .multilineTextAlignment(.center)
               .font(.system(size: 12))
         }
         .navigationDestination(isPresented: $viewModel.isFinished) {
            LoginView()
         }
      }
   }
}

#Preview {
   OnboardingView()
}

struct AgreementTextView: View {
   let attrStr: AttributedString = {
      var result = AttributedString("By creating an account, you agree to our Terms of Service and Privacy Policy")
      result.font = .system(size: 12)
      result.foregroundColor = Color(hex: "#5C5C5C")
      
      if let range = result.range(of: "Terms of Service") {
         result[range].link = URL(string: "https://qarabagh.com")
         result[range].underlineStyle = .single
         result[range].foregroundColor = Color(hex: "#171717")
      }
      
      if let range = result.range(of: "Privacy Policy") {
         result[range].link = URL(string: "https://www.newcastleunited.com/en")
         result[range].underlineStyle = .single
         result[range].foregroundColor = Color(hex: "#171717")
         
      }
      
      return result
   }()
   var body: some View {
      Group {
         Text(attrStr)
      }
   }
}
