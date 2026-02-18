//
//  OnboardingViewModel.swift
//  Tikim
//
//  Created by Alpay Calalli on 12.02.26.
//


import SwiftUI
import Observation

@Observable
class OnboardingViewModel {
   
   // To trigger navigation
   var isFinished = false
   
   var isMovingForward = false
   var currentTitle = ""
   var currentSubtitle = ""
   var currentIndex = 0
   var previousIndex = 0
   var currentModel: OnboardingDataModel {
      onboardingContent[currentIndex]
   }
   @ObservationIgnored var onboardingContent: [OnboardingDataModel] = [
      .init(
         title: "Lazım olan hər şeyi bir yerdə tap",
         subtitle: "Axtarma, mağaza gəzmə. Alətlər və materiallar burada cəmlənib.",
         imageName: "onboarding-image-1",
         backgroundColor: Color(hex: "#0355E3")
      ),
      .init(
         title: "Sən seç, biz gətirək.",
         subtitle: "Ağırlığı, daşınmanı və kargonu düşünmə — hamısını biz həll edirik",
         imageName: "onboarding-image-2",
         backgroundColor: Color(hex: "#1DBE6F")
      ),
      .init(
         title: "Evinə dəyişiklik qat",
         subtitle: "Daha asan, daha sürətli, daha əlçatan təmir prosesi",
         imageName: "onboarding-image-3",
         backgroundColor: Color(hex: "#FE7E01")
      ),
   ]
   
   func goToNextStep() {
      guard currentIndex + 1 <= onboardingContent.count - 1 else {
         isFinished = true
         return
      }

      currentIndex += 1
   }
   func goToPreviousStep() {
      // Button disable olacaq onsuz, amma her ehtimal
      guard currentIndex > 0 else { return }
      currentIndex -= 1
   }
   
}
