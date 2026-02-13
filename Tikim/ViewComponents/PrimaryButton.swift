//
//  PrimaryButton.swift
//  Tikim
//
//  Created by Alpay Calalli on 12.02.26.
//

import SwiftUI

struct PrimaryButton<Label: View>: View {
    private let action: () -> Void
    private let label: Label
    
    @Environment(\.backgroundStyle) private var backgroundStyle
    @Environment(\.isEnabled) var isEnabled
   
   @State private var triggerFeedback = false
        
    init(
        action: @escaping () -> Void,
        @ViewBuilder label: () -> Label
    ) {
        self.action = action
        self.label = label()
    }
    
    var body: some View {
        Button {
           triggerFeedback = true
            action()
        } label: {
            label
                .containerRelativeFrame(.horizontal) { length, _ in
                    length - 48
                }
                .frame(height: 44)
                .background(isEnabled ? backgroundStyle ?? AnyShapeStyle(Color.gray) : AnyShapeStyle(Color.gray.secondary))
                .clipShape(.rect(cornerRadius: 8))
                .sensoryFeedback(.impact, trigger: triggerFeedback)
        }
    }
}

extension PrimaryButton where Label == Text {
    init(
        _ titleKey: LocalizedStringKey,
        action: @escaping () -> Void
    ) {
        self.init(
            action: action,
            label: {
                Text(titleKey)
            }
        )
    }
}

extension PrimaryButton where Label == SwiftUI.Label<Text, Image> {
    init(
        _ titleKey: LocalizedStringKey,
        systemImage: String,
        action: @escaping () -> Void
    ) {
        self.init(
            action: action,
            label: {
                Label(titleKey, systemImage: systemImage)
            }
        )
    }
}
