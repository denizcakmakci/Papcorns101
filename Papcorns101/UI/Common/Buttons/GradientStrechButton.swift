//
//  GradientStrechButton.swift
//  Papcorns101
//
//  Created by Deniz Çakmakçı on 5.11.2024.
//

import SwiftUI

struct GradientStrechButton: View {
    var text: String
    var isEnabled: Bool = true
    var action: () -> Void = {}

    var body: some View {
        Button(action: {
            if isEnabled {
                action()
            }
        }) {
            Text(text)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    isEnabled ?
                        AnyView(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.primaryColor, Color.secondaryColor]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        ) :
                        AnyView(Color.primaryColor.opacity(0.4))
                )
                .foregroundColor(
                    isEnabled ? Color.white : Color.systemWhiteWithOpacity50
                )
                .cornerRadius(10)
        }
        .disabled(!isEnabled)
    }
}

#Preview {
    GradientStrechButton(text: "Gradient Button")
}
