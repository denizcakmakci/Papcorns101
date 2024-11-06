//
//  GeneratingMusicLoadingViewModel.swift
//  Papcorns101
//
//  Created by Deniz Çakmakçı on 5.11.2024.
//

import AVFoundation
import Foundation
import SwiftUI

class GeneratingMusicLoadingViewModel: ObservableObject {
    @Published var player: AVPlayer
    @Published var isFinished: Bool = false

    init() {
        let player = AVPlayer(
            url: Bundle.main.url(
                forResource: AssetNames.loadingVideo.rawValue,
                withExtension: "mp4"
            )!
        )
        self.player = player
        player.play()
    }

    func controlIsFinishedVideo() {
        player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 600), queue: .main) { time in
            if let duration = self.player.currentItem?.duration, duration.seconds > 0 {
                if time.seconds >= duration.seconds {
                    self.isFinished = true
                }
            }
        }
    }
}
