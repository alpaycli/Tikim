//
//  OnboardingCard.swift
//  Tikim
//
//  Created by Alpay Calalli on 12.02.26.
//

import SwiftUI

struct OnboardingCard: View {
   @Bindable var viewModel: OnboardingViewModel
   
   // For text transition animation
   @State private var visibleTab: Int = 0
   
   private var customTransition: AnyTransition {
      let moveTop = AnyTransition.move(edge: .top)
         .combined(with: .opacity)
      let moveBottom = AnyTransition.move(edge: .bottom)
         .combined(with: .opacity)

      return .asymmetric(
         insertion: viewModel.isMovingForward ? moveBottom : moveTop,
         removal: viewModel.isMovingForward ? moveTop : moveBottom
      )
   }
   
   var body: some View {
      ZStack {
         TabView(selection: $viewModel.currentIndex.animation(.easeInOut(duration: 0.2))) {
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
         
         content
         
         Spacer()
      }
      .task {
         viewModel.currentTitle = viewModel.onboardingContent[0].title
         viewModel.currentSubtitle = viewModel.onboardingContent[0].subtitle
      }
      // For text transition animation
      .onChange(of: viewModel.currentIndex) { oldValue, newValue in
         viewModel.isMovingForward = oldValue < newValue
         
         withAnimation(.easeInOut(duration: 0.2)) {
            visibleTab = -1   // or some empty placeholder
            viewModel.currentTitle = ""
            viewModel.currentSubtitle = ""
         }
         
         DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.easeInOut(duration: 0.2)) {
               visibleTab = newValue
               viewModel.currentTitle = viewModel.onboardingContent[newValue].title
               viewModel.currentSubtitle = viewModel.onboardingContent[newValue].subtitle
            }
         }
      }
      
   }
   
   private var content: some View {
      VStack {
         VStack(alignment: .leading, spacing: 14) {
            titleView
            subtitleView
         }
         .padding(.init(top: 14, leading: 14, bottom: 0, trailing: 14))
         
         Spacer()
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .background(viewModel.currentModel.backgroundColor, in: .rect(cornerRadius: 16))
      .padding(.horizontal, 24)
   }
}

extension OnboardingCard {
   private var titleView: some View {
      Text(viewModel.currentTitle)
         .font(.system(size: 32))
         .fontWeight(.bold)
         .foregroundStyle(.white)
         .id(visibleTab)
         .transition(customTransition)
      
   }
   
   private var subtitleView: some View {
      Text(viewModel.currentSubtitle)
         .font(.system(size: 16))
         .foregroundStyle(.white)
         .id(visibleTab)
         .transition(customTransition)
   }
}

#Preview {
   OnboardingView()
}

#Preview {
   @Previewable @State var viewModel = OnboardingViewModel()
   OnboardingCard(viewModel: viewModel)
      .frame(height: 700)
}


