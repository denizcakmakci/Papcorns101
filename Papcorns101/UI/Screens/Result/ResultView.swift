//
//  ResultView.swift
//  Papcorns101
//
//  Created by Deniz Çakmakçı on 6.11.2024.
//

import SwiftUI

struct ResultView: View {
    @StateObject private var audioPlayer = AudioPlayerManager()
    @EnvironmentObject var viewModel: AIVoiceViewModel
    @State private var isLooping = false

    var body: some View {
        VStack {
            // Progress Bar ve Zaman Etiketleri
            VStack {
                Slider(value: $audioPlayer.progress, in: 0 ... 1, onEditingChanged: { editing in
                    if editing {
                        audioPlayer.isSeeking = true // Kullanıcı kaydırma yapıyor
                    } else {
                        audioPlayer.isSeeking = false // Kaydırmayı bitirdi
                        audioPlayer.seekToProgress()
                    }
                })
                .controlSize(.small)
                .padding(.horizontal)

                HStack {
                    Text(audioPlayer.currentTime) // Geçerli zaman
                    Spacer()
                    Text(audioPlayer.totalDuration) // Toplam süre
                }
                .font(.caption)
                .padding(.horizontal)
            }

            // Play/Pause Butonu
            HStack {
                Button(action: {
                    audioPlayer.isPlaying ? audioPlayer.pause() : audioPlayer.play(url: URL(string: viewModel.generatedMusicDataState.value?.resultUrl ?? "")!)
                }) {
                    Image(systemName: audioPlayer.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                        .font(.largeTitle)
                }
            }
            .padding()

            Button(action: {
                audioPlayer.isLooping.toggle()
            }) {
                Image(systemName: audioPlayer.isLooping ? "repeat.circle.fill" : "repeat.circle")
                    .font(.largeTitle)
            }
            Button(action: {
                audioPlayer.startDownload(url: URL(string: viewModel.generatedMusicDataState.value?.resultUrl ?? "")!, fileName: viewModel.selectedVoiceItem?.name ?? "downloadedFile.mp3")
            }) {
                Text(audioPlayer.isDownloading ? "Downloading... \(Int(audioPlayer.downloadProgress * 100))%" : (audioPlayer.isDownloadCompleted ? "Completed" : "Download"))
                    .font(.headline)
                    .padding()
                    .background(audioPlayer.isDownloading ? Color.gray : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .onAppear {
            audioPlayer.loadAudio(url: URL(string: viewModel.generatedMusicDataState.value?.resultUrl ?? "")!) // Ses dosyasını yükle
        }
        .onDisappear {
            audioPlayer.stop() // Sayfa kaybolduğunda ses dosyasını durdur
        }
    }
}

#Preview {
    ResultView()
}
