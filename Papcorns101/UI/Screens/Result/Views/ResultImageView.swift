//
//  ResultImageView.swift
//  Papcorns101
//
//  Created by Deniz Çakmakçı on 6.11.2024.
//

import Kingfisher
import SwiftUI

struct ResultImageView: View {
    var imageUrl: String
    var isLooping: Bool = false
    var buttonAction: () -> Void = {}

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            KFImage(URL(string: imageUrl))
                .resizable()
                .scaledToFill()
                .frame(height: UIScreen.screenHeight * 0.4)
                .padding(.bottom, 35)
                .padding(.top, 16)
            Button {
                buttonAction()
            } label: {
                HStack {
                    Image(AssetNames.loop.rawValue)
                        .renderingMode(.template)
                        .foregroundColor(isLooping ? Color.white : Color.systemWhiteWithOpacity70)
                    Text(LocalizationKeys.Result.loop.translate())
                        .appFont(font: AppFonts.bodySemiBold)
                        .foregroundColor(isLooping ? Color.white : Color.systemWhiteWithOpacity70)
                }
            }
            .overlay(
                isLooping ?
                    RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.primaryColor, lineWidth: 1.5)
                    : nil
            )
            .padding(.bottom, 44)
            .padding(.trailing, 20)
            .buttonStyle(.borderedProminent)
            .tint(Color.loopButtonColor)
        }
    }
}

#Preview {
    ResultImageView(imageUrl: "")
}
