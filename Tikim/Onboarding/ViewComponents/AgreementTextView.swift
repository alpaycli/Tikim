//
//  AgreementTextView.swift
//  Tikim
//
//  Created by Alpay Calalli on 17.02.26.
//

import SwiftUI

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
