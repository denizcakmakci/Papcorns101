//
//  GeneratingMusicLoadingView.swift
//  Papcorns101
//
//  Created by Deniz Çakmakçı on 5.11.2024.
//

import AVKit
import SwiftUI

struct GeneratingMusicLoadingView: View {
    @ObservedObject var viewModel: GeneratingMusicLoadingViewModel

    init() {
        _viewModel = ObservedObject(wrappedValue: GeneratingMusicLoadingViewModel())
    }

    var body: some View {
        if !viewModel.isFinished {
            VStack {
                ZStack(alignment: .topLeading) {
                    HStack {
                        Button(action: {
                            // Kapatma butonu için yapılacak işlemler
                            print("Kapatma butonuna tıklandı")
                        }) {
                            Image(AssetNames.close.rawValue)
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.white)
                        }
                        Spacer()
                    }
                    .padding(.top, 20)

                    HStack {
                        Spacer()
                        VideoPlayer(player: viewModel.player)
                            .frame(height: UIScreen.screenHeight * 0.5)
                            .frame(width: 236)
                            .clipShape(Circle())
                            .shadow(color: Color.primaryColorWithOpacity, radius: 110, x: 0, y: 0)
                            .background(
                                Circle()
                                    .fill(
                                        LinearGradient(gradient: Gradient(colors: [Color.primaryColorWithOpacity, Color.secondaryColorWithOpacity]), startPoint: .top, endPoint: .bottom)
                                    )
                                    .blur(radius: 110)
                            )
                        Spacer()
                    }
                }
                Spacer()
                Text("Generating")
                    .appFont(font: AppFonts.largeTitle, lineSpacing: 8)
                    .padding(.bottom, 8)
                Text("It may take up to few minutes for you to receive an AI-generated speech. You can find your voice record in Library.")
                    .multilineTextAlignment(.center)
                    .appFont(font: AppFonts.bodyRegular, lineSpacing: 3)
                    .padding(.horizontal, 20)
                Spacer()
            }
            .padding()
            .navigationBarBackButtonHidden(true)
            .onDisappear {
                viewModel.player.pause()
            }
            .onReceive(viewModel.player.publisher(for: \.status)) { status in
                if status == .readyToPlay {
                    viewModel.controlIsFinishedVideo()
                }
            }
        } else {
            ResultView()
        }
    }
}

#Preview {
    GeneratingMusicLoadingView()
}
