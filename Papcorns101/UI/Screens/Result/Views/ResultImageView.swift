//
//  ResultImageView.swift
//  Papcorns101
//
//  Created by Deniz Çakmakçı on 6.11.2024.
//

import Kingfisher
import SwiftUI

struct ResultImageView: View {
    @Environment(\.dismiss) var dismiss
    @State private var currentValue = 0.6

    var body: some View {
        VStack {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.backward")
                        .foregroundColor(Color.white)
                }
                Spacer()
                Text("Part Simpson")
                Spacer()
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundColor(Color.white)
                }
            }

            KFImage(URL(string: "https://firebasestorage.googleapis.com/v0/b/papcornstest.appspot.com/o/00MusicImages%2FandrewTate.png?alt=media&token=83452b18-6af0-4127-bcc9-592ba06b80fe"))
                .resizable()
                .scaledToFill()
                .frame(height: UIScreen.screenHeight * 0.4)
                .padding(.bottom, 35)
                .padding(.top, 16)
            Slider(value: $currentValue, in: 0 ... 1)
                .tint(.white)
                .onAppear {
                    let progressCircleConfig = UIImage.SymbolConfiguration(scale: .medium)
                    UISlider.appearance()
                        .setThumbImage(UIImage(systemName: "circle.fill",
                                               withConfiguration: progressCircleConfig), for: .normal)
                }

            HStack {
                Text("0:10")
                Spacer()
                Text("00:30")
            }
            .appFont(font: AppFonts.caption, lineSpacing: 5)

            ZStack {
                Color.systemDark
                    .cornerRadius(12)
                    .frame(maxWidth: .infinity)
                    .frame(height: 140)
                Text("Write a text and let AI turn it into a speech with the voice of your favorite character")
                    .foregroundColor(Color.white)
                    .appFont(font: AppFonts.bodyRegular, lineSpacing: 5)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .multilineTextAlignment(.leading)
                    .padding(.leading, 16)
                    .padding(.vertical, 16)
                    .frame(height: 140)
            }

            Spacer()
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    ResultImageView()
}
