//
//  TabIndicatorCapsulesView.swift
//  Tikim
//
//  Created by Alpay Calalli on 12.02.26.
//

import SwiftUI

struct TabIndicatorCapsulesView: View {
   let totalTabsCount: Int
   let currentTab: Int
   
   @Environment(\.backgroundStyle) private var backgroundStyle
   
   var body: some View {
      HStack {
         ForEach(0..<totalTabsCount, id: \.self) { index in
            Capsule()
               .fill(backgroundStyle ?? AnyShapeStyle(Color.black))
               .frame(
                  width: index == currentTab ? 18 : 6,
                  height: 6
               )
               .opacity(index == currentTab ? 1 : 0.3)            
         }
      }
   }
}
