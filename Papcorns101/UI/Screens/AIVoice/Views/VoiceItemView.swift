//
//  VoiceItemView.swift
//  Papcorns101
//
//  Created by Deniz Çakmakçı on 5.11.2024.
//

import Kingfisher
import SwiftUI

struct VoiceItemView: View {
    var imageUrl: String
    var isSelected: Bool = false
    var action: () -> Void = {}

    var body: some View {
        Button(action: action) {
            ZStack {
                KFImage(URL(string: imageUrl))
                    .resizable()
                    .scaledToFit()
                    .overlay(isSelected ? Color.primaryColor.opacity(0.3) : nil)
                isSelected ? Image(AssetNames.voice.rawValue) : nil
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(
            isSelected ?
                RoundedRectangle(cornerRadius: 10)
                .stroke(Color.primaryColor, lineWidth: 2)
                : nil
        )
    }
}

#Preview {
    VoiceItemView(
        imageUrl: "https://firebasestorage.googleapis.com/v0/b/papcornstest.appspot.com/o/00MusicImages%2F21Savage.png?alt=media&token=03ca86a1-d9f0-4374-8891-546dfd3bdc02")
}
