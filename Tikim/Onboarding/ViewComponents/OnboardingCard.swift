//
//  OnboardingCard.swift
//  Tikim
//
//  Created by Alpay Calalli on 12.02.26.
//

import SwiftUI

struct OnboardingCard: View {
   @Bindable var viewModel: OnboardingViewModel
   @State private var visibleTab: Int = 0         // actually shown

   var body: some View {
      ZStack {
         TabView(selection: $viewModel.currentIndex.animation()) {
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
               switch visibleTab {
                  case 0: titleView
                  case 1: titleView
                  case 2: titleView
                  default: EmptyView()
               }
               
               switch visibleTab {
                  case 0: subtitleView
                  case 1: subtitleView
                  case 2: subtitleView
                  default: EmptyView()
               }
            }
//            .animation(.easeInOut, value: viewModel.currentIndex)
            .padding(.init(top: 14, leading: 14, bottom: 0, trailing: 14))
            
            Spacer()
         }
         .frame(maxWidth: .infinity, alignment: .leading)
         .background(viewModel.currentModel.backgroundColor, in: .rect(cornerRadius: 16))
         .padding(.horizontal, 24)
         
         
         
         Spacer()
      }
      .onChange(of: viewModel.currentIndex) { _, newValue in
          // 1️⃣ animate removal
          withAnimation(.easeInOut(duration: 0.2)) {
              visibleTab = -1   // or some empty placeholder
          }

          // 2️⃣ delay insertion
         DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
              withAnimation(.easeInOut(duration: 0.1)) {
                  visibleTab = newValue
              }
          }
      }

   }
   
   private var titleView: some View {
      Text(viewModel.currentModel.title)
         .font(.system(size: 32))
         .fontWeight(.bold)
         .foregroundStyle(.white)
         .id(viewModel.currentIndex) // important
//                  .contentTransition(.numericText())
         .transition(
            .asymmetric(
               insertion:
                     .offset(y: 20)
               ,
               removal:
                     .offset(y: -50)
//                     .animation(.easeOut(duration: 9))
                  .combined(with: .opacity.animation(.easeInOut(duration: 0.3)))
            )
         )

   }
   
   private var subtitleView: some View {
      Text(viewModel.currentModel.subtitle)
         .font(.system(size: 16))
         .foregroundStyle(.white)
//                  .contentTransition(.numericText())
         .id(viewModel.currentIndex) // important
         .transition(
            .asymmetric(
               insertion:
                     .offset(y: 20)
               ,
               removal:
                     .offset(y: -50)
//                     .animation(.easeOut(duration: 9))
                     .combined(with: .opacity.animation(.easeInOut(duration: 0.3)))
            )
         )

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


