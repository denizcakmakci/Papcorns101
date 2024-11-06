//
//  FilterTapItemView.swift
//  Papcorns101
//
//  Created by Deniz Çakmakçı on 5.11.2024.
//

import SwiftUI

struct FilterTapItemView: View {
    var text: String
    var isSelected: Bool = true
    var action: () -> Void = {}

    var body: some View {
        Button(action: {
            action()
        }) {
            Text(text)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .foregroundColor(Color.systemWhiteWithOpacity50)
                .appFont(font: AppFonts.bodyRegular, lineSpacing: 3)
        }
        .background(Color.systemDark)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay(
            isSelected ?
                RoundedRectangle(cornerRadius: 8)
                .stroke(Color.primaryColor, lineWidth: 1.5)
                : nil
        )
    }
}

#Preview {
    FilterTapItemView(text: "All")
}
