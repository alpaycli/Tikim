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
               nextButton
               skipButton
            }
            .padding(.top, 58)
            
            AgreementTextView()
               .multilineTextAlignment(.center)
               .font(.system(size: 12))
               .padding(.init(top: 24, leading: 24, bottom: 48, trailing: 24))
         }
         .navigationDestination(isPresented: $viewModel.isFinished) {
            LoginView()
         }
      }
   }
}

extension OnboardingView {
   private var nextButton: some View {
      PrimaryButton {
         withAnimation { viewModel.goToNextStep() }
      } label: {
         Text("Next")
            .bold()
            .foregroundStyle(.white)
      }
   }
   
   private var skipButton: some View {
      SecondaryButton {
         viewModel.isFinished = true
      } label: {
         Text("Skip")
            .bold()
            .foregroundStyle(Color(hex: "#414651"))
      }
   }
}

#Preview {
   OnboardingView()
}
