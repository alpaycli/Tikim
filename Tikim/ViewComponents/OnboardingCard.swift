//
//  OnboardingCard.swift
//  Tikim
//
//  Created by Alpay Calalli on 12.02.26.
//

import SwiftUI

struct OnboardingCard: View {
   @Bindable var viewModel: OnboardingViewModel
   var body: some View {
      ZStack {
         TabView(selection: $viewModel.currentIndex) {
            ForEach(viewModel.onboardingContent.indices, id: \.self) { index in
               Image(viewModel.onboardingContent[index].imageName)
                  .resizable()
                  .scaledToFit()
                  .tag(index)
                  .padding(.horizontal, 24)
                  .offset(y: 80)
            }
         }
         .tabViewStyle(.page(indexDisplayMode: .never))
         .zIndex(2)
         
         VStack {
            VStack(alignment: .leading, spacing: 14) {
               Text(viewModel.currentModel.title)
                  .font(.system(size: 32))
                  .fontWeight(.bold)
                  .foregroundStyle(.white)
                  .contentTransition(.numericText())
               
               Text(viewModel.currentModel.subtitle)
                  .font(.system(size: 16))
                  .foregroundStyle(.white)
                  .contentTransition(.numericText())
            }
            .animation(.easeInOut, value: viewModel.currentIndex)
            .padding(.init(top: 14, leading: 14, bottom: 0, trailing: 14))
            
            Spacer()
         }
         .frame(maxWidth: .infinity, alignment: .leading)
         .background(viewModel.currentModel.backgroundColor, in: .rect(cornerRadius: 16))
         .padding(.horizontal, 24)
         
         
         
         Spacer()
      }
   }
}

#Preview {
   @Previewable @State var viewModel = OnboardingViewModel()
   OnboardingCard(viewModel: viewModel)
         .frame(height: 700)
}
