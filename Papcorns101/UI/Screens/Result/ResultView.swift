//
//  ResultView.swift
//  Papcorns101
//
//  Created by Deniz Çakmakçı on 6.11.2024.
//

import Kingfisher
import SwiftUI

struct ResultView: View {
    @StateObject private var audioPlayer = AudioPlayerManager()
    @EnvironmentObject var viewModel: AIVoiceViewModel
    @Environment(\.dismiss) var dismiss

    @State private var showToast = false

    var body: some View {
        VStack {
            switch viewModel.generatedMusicDataState {
            case .failure(let error):
                VStack {
                    Text(error.localizedDescription.description)
                        .padding(.bottom, 20)
                }

            case .success(let data):
                ZStack {
                    VStack(alignment: .leading) {
                        TopBarView(
                            title: viewModel.selectedVoiceItem?.name,
                            shareAction: {
                                audioPlayer.shareAudioFile(url: URL(string: data.resultUrl)!)
                            },
                            copyAction: {
                                UIPasteboard.general.string = viewModel.selectedPromp
                                showToast = true

                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    showToast = false
                                }
                            }, backAction: {
                                dismiss()
                                viewModel.clearSelectedVoiceItem()
                            }
                        )
                        ResultImageView(
                            imageUrl: viewModel.selectedVoiceItem?.imageUrl ?? "",
                            isLooping: audioPlayer.isLooping,
                            buttonAction: {
                                audioPlayer.isLooping.toggle()
                            }
                        )
                        SliderView(
                            audioPlayer: audioPlayer,
                            sourceUrl: data.resultUrl,
                            progress: $audioPlayer.progress,
                            playAction: {
                                audioPlayer.play(url: URL(string: data.resultUrl)!)
                            },
                            pauseAction: {
                                audioPlayer.pause()
                            }
                        )
                        SelectedPrompView(promp: viewModel.selectedPromp)
                        GradientStrechButton(
                            text: audioPlayer.isDownloading && !audioPlayer.isDownloadCompleted
                                ? "\(LocalizationKeys.Result.downloading.translate()) \(Int(audioPlayer.downloadProgress * 100))%"
                                : (audioPlayer.isDownloadCompleted ? LocalizationKeys.Result.completed.translate() : LocalizationKeys.Result.download.translate()),
                            action: {
                                if !audioPlayer.isDownloadCompleted {
                                    audioPlayer.startDownload(url: URL(string: data.resultUrl)!)
                                }
                            }
                        )
                    }
                    .padding(.horizontal, 16)
                    .navigationBarBackButtonHidden(true)
                    if showToast {
                        TextCopiedToast()
                            .animation(.easeInOut, value: showToast)
                    }
                }

            default:
                EmptyView()
            }
        }
        .onAppear {
            audioPlayer.loadAudio(url: URL(string: viewModel.generatedMusicDataState.value?.resultUrl ?? "")!, fileName: viewModel.selectedVoiceItem?.name)
        }
        .onDisappear {
            audioPlayer.stop()
        }
    }
}

#Preview {
    ResultView()
}
