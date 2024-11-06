//
//  AIVoiceView.swift
//  Papcorns101
//
//  Created by Deniz Çakmakçı on 3.11.2024.
//

import Kingfisher
import SwiftUI

struct AIVoiceView: View {
    @EnvironmentObject var viewModel: AIVoiceViewModel
    @State private var navigateToNextPage = false

    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                Text("AI Voice")
                    .padding(.bottom, 20)
                InspirationView(text: viewModel.selectedPromp, action: {
                    viewModel.selectRandomPromp()
                })
                HStack {
                    Text("Pick a Voice")
                        .appFont(font: AppFonts.title, lineSpacing: 6)
                        .padding(.top, 16)
                        .padding(.bottom, 12)
                    Spacer()
                }
                VoicePickerView(viewModel: viewModel)
                    .padding(.bottom, 60)
            }
            // .padding(.all, 16)
            // LinearGradient(
            //    gradient: Gradient(colors: [Color.systemBlack, Color.clear]),
            //    startPoint: .bottom, endPoint: .top
            // )
            // .frame(height: 220) // Gradient yüksekliği
            // .padding(.top, 0) // Gradientin üstten sabitlenmesini sağla
            // .padding(.bottom, 50)
            // .allowsHitTesting(false)
            GradientStrechButton(
                text: "Continue",
                isEnabled: viewModel.selectedPromp != nil && viewModel.selectedVoiceItem != nil,
                action: {
                    navigateToNextPage = true
                    Task {
                        await viewModel.generateMusic()
                    }
                }
            )
            .navigationDestination(isPresented: $navigateToNextPage) {
                GeneratingMusicLoadingView()
                    .environmentObject(viewModel)
            }
        }
        .padding(.horizontal, 16)
        .onAppear {
            viewModel.getVoices()
        }
    }
}

#Preview {
    AIVoiceView()
}
