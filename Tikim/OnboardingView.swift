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
                  if viewModel.currentIndex == viewModel.onboardingContent.count - 1 {
                     // Navigate to next view
                     
                     
                  } else {
                     // Next onboarding card
                     withAnimation { viewModel.goToNextStep() }
                  }
               } label: {
                  Text("Next")
                     .bold()
                     .foregroundStyle(.white)
               }
               .backgroundStyle(AnyShapeStyle(Color(hex: "#0750D0")))
               
               
               SecondaryButton {
                  withAnimation {
                     viewModel.goToPreviousStep()
                  }
               } label: {
                  Text("Back")
                     .bold()
                     .foregroundStyle(Color(hex: "#414651"))
                     .opacity(viewModel.currentIndex == 0 ? 0.3 : 1)
               }
               .disabled(viewModel.currentIndex == 0)
            }
            .padding(.top, 58)
            
            AgreementTextView()
               .padding(.init(top: 24, leading: 24, bottom: 48, trailing: 24))
               .multilineTextAlignment(.center)
               .font(.system(size: 12))
         }
      }
   }
}

#Preview {
   OnboardingView()
}

struct AgreementTextView: View {
   var body: some View {
      Group {
         let termsOfServiceBtn =   Text("Terms of Service")
               .underline()
         
         
         let privacyPolicyBtn = Button { } label: {
            Text("Privacy Policy")
               .underline()
         }
         
         Text("By creating an account, you agree to our")
         +
         Text("Terms of Service").underline()
      }
   }
}
