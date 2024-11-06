//
//  InspirationView.swift
//  Papcorns101
//
//  Created by Deniz Çakmakçı on 5.11.2024.
//

import SwiftUI

struct InspirationView: View {
    var text: String?
    var action: () -> Void = {}

    var body: some View {
        ZStack {
            Color.systemDark
                .cornerRadius(12)
                .frame(maxWidth: .infinity)
                .frame(height: 140)
            VStack(alignment: .leading) {
                Text(text ?? LocalizationKeys.AiVoice.defaultInspiration.translate())
                    .foregroundColor(text != nil ? Color.white : Color.systemWhiteWithOpacity50)
                    .appFont(font: AppFonts.bodyRegular, lineSpacing: 5)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .multilineTextAlignment(.leading)
                Spacer()
                Button(action: action) {
                    HStack {
                        Text(LocalizationKeys.AiVoice.getInspiration.translate())
                            .foregroundColor(Color.primaryColor)
                            .underline()
                        Image(AssetNames.tips.rawValue)
                    }
                }
            }
            .padding(.leading, 16)
            .padding(.vertical, 16)
            .frame(height: 140)
        }
    }
}

#Preview {
    InspirationView()
}
