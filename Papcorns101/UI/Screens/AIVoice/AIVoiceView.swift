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
        VStack {
            switch viewModel.screenDataState {
            case .failure(let error):
                VStack {
                    Text(error.localizedDescription.description)
                        .padding(.bottom, 20)
                }
                
            case .success:
                ZStack(alignment: .bottom) {
                    VStack {
                        Text(LocalizationKeys.AiVoice.aiVoice.translate())
                            .padding(.bottom, 20)
                        InspirationView(text: viewModel.selectedPromp, action: {
                            viewModel.selectRandomPromp()
                        })
                        HStack {
                            Text(LocalizationKeys.AiVoice.pickVoice.translate())
                                .appFont(font: AppFonts.title, lineSpacing: 6)
                                .padding(.top, 16)
                                .padding(.bottom, 12)
                            Spacer()
                        }
                        VoicePickerView(viewModel: viewModel)
                            .padding(.bottom, 35)
                    }
                    .padding(.all, 16)
                    .overlay(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.systemBlack, Color.clear]),
                            startPoint: .bottom, endPoint: .top
                        )
                        .allowsHitTesting(false)
                        .frame(height: 220),
                        alignment: .bottom
                    )
                    
                    GradientStrechButton(
                        text: LocalizationKeys.AiVoice.buttonContinue.translate(),
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
                
            default:
                EmptyView()
            }
        }
        .onAppear {
            viewModel.getVoices()
        }
    }
}

#Preview {
    AIVoiceView()
}
