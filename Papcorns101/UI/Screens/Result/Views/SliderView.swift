//
//  SliderView.swift
//  Papcorns101
//
//  Created by Deniz Çakmakçı on 6.11.2024.
//

import SwiftUI

struct SliderView: View {
    var audioPlayer: AudioPlayerManager
    var sourceUrl: String?
    var progress: Binding<Double>
    var playAction: () -> Void
    var pauseAction: () -> Void

    var body: some View {
        HStack(alignment: .center) {
            VStack {
                Slider(value: progress, in: 0 ... 1, onEditingChanged: { editing in
                    if editing {
                        audioPlayer.isSeeking = true
                    } else {
                        audioPlayer.isSeeking = false
                        audioPlayer.seekToProgress()
                    }
                })
                .tint(.white)
                .onAppear {
                    let progressCircleConfig = UIImage.SymbolConfiguration(scale: .medium)
                    UISlider.appearance()
                        .setThumbImage(
                            UIImage(
                                systemName: "circle.fill",
                                withConfiguration: progressCircleConfig
                            ), for: .normal
                        )
                }
                HStack {
                    Text(audioPlayer.currentTime)
                    Spacer()
                    Text(audioPlayer.totalDuration)
                }
                .appFont(font: AppFonts.caption, lineSpacing: 5)
            }
            .padding(.trailing, 15)

            if audioPlayer.isPlaying {
                Image(AssetNames.play.rawValue)
                    .renderingMode(.template)
                    .foregroundColor(.black)
                    .padding(.all, 15)
                    .background {
                        Button {
                            pauseAction()
                        } label: {
                            Circle()
                                .foregroundColor(.white)
                                .scaledToFill()
                        }
                        .contentShape(Circle())
                    }
                    .frame(width: 56)
            } else {
                Image(AssetNames.pause.rawValue)
                    .renderingMode(.template)
                    .foregroundColor(.black)
                    .padding(.leading, 22)
                    .padding(.trailing, 17)
                    .background {
                        Button {
                            playAction()
                        } label: {
                            Circle()
                                .foregroundColor(.white)
                                .scaledToFill()
                        }
                        .contentShape(Circle())
                    }
                    .frame(width: 56)
            }
        }
        .padding(.bottom, 20)
        .frame(height: 56)
    }
}
