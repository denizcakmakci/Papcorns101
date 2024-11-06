//
//  AudioPlayerManager.swift
//  Papcorns101
//
//  Created by Deniz Çakmakçı on 6.11.2024.
//

import AVFoundation
import Foundation

import AVFoundation
import Foundation

class AudioPlayerManager: NSObject, ObservableObject, URLSessionDownloadDelegate {
    private var player: AVPlayer?
    private var playerItem: AVPlayerItem?
    private var timeObserverToken: Any?
    
    private var backgroundSession: URLSession?
    private var downloadTask: URLSessionDownloadTask?
    private var observation: NSKeyValueObservation?
    @Published var downloadProgress: Double = 0.0
    @Published var isDownloading: Bool = false
    @Published var isDownloadCompleted: Bool = false
    private var fileName: String?
    
    @Published var isPlaying = false
    @Published var progress: Double = 0.0
    @Published var currentTime = "0:00"
    @Published var totalDuration = "0:00"
    @Published var isSeeking = false
    @Published var isLooping = false
    
    func loadAudio(url: URL) {
        playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        
        Task {
            let duration = try await playerItem?.asset.load(.duration)
            if let duration = duration {
                totalDuration = formatTime(seconds: CMTimeGetSeconds(duration))
            }
        }
        
        startTimer()
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: playerItem)
    }
    
    func play(url: URL) {
        if player == nil {
            loadAudio(url: url)
        }
        if currentTime == totalDuration {
            player?.seek(to: CMTime.zero)
        }
        player?.play()
        isPlaying = true
        startTimer()
    }
    
    func pause() {
        player?.pause()
        isPlaying = false
        stopTimer()
    }
    
    func stop() {
        player?.pause()
        player?.seek(to: CMTime.zero)
        isPlaying = false
        progress = 0.0
        currentTime = "0:00"
        stopTimer()
    }
    
    func seekToProgress() {
        guard let player = player else { return }
        let newTime = Double(progress) * CMTimeGetSeconds(player.currentItem!.duration)
        player.seek(to: CMTime(seconds: newTime, preferredTimescale: 1))
        currentTime = formatTime(seconds: newTime)
    }
    
    @objc func playerDidFinishPlaying() {
        if isLooping {
            player?.seek(to: CMTime.zero)
            player?.play()
        } else {
            isPlaying = false
        }
    }
    
    private func startTimer() {
        stopTimer()
        
        let interval = CMTime(seconds: 0.5, preferredTimescale: 600)

        if CMTimeCompare(interval, CMTime.zero) <= 0 {
            print("Invalid interval: Interval should not be zero or negative")
            return
        }
        
        timeObserverToken = player?.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main) { [weak self] time in
            guard let self = self else { return }
            
            let currentTimeSeconds = CMTimeGetSeconds(time)
            
            if currentTimeSeconds < 0 {
                print("Invalid time value")
                return
            }
            
            if !self.isSeeking {
                self.progress = currentTimeSeconds / CMTimeGetSeconds(self.player?.currentItem?.duration ?? CMTime.zero)
                self.currentTime = self.formatTime(seconds: currentTimeSeconds)
            }
        }
    }
    
    private func stopTimer() {
        if let token = timeObserverToken {
            player?.removeTimeObserver(token)
            timeObserverToken = nil
        }
    }
    
    func startDownload(url: URL, fileName: String) {
        self.fileName = fileName
        
        let configuration = URLSessionConfiguration.background(withIdentifier: "com.example.app.background")
        backgroundSession = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
         
        downloadTask = backgroundSession?.downloadTask(with: url)
         
        observation = downloadTask!.progress.observe(\.fractionCompleted) { [weak self] observationProgress, _ in
            DispatchQueue.main.async {
                self?.downloadProgress = observationProgress.fractionCompleted
                self?.isDownloading = true
                print("Download Progress: \(self?.downloadProgress ?? 0.0 * 100)%")
            }
        }
         
        downloadTask?.resume()
    }
     
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard let fileName = fileName else {
            print("File name is missing.")
            return
        }
        
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Error: Documents directory not found.")
            return
        }
        
        let destinationURL = documentsDirectory.appendingPathComponent(fileName)
        
        let directory = documentsDirectory.deletingLastPathComponent()
        if !FileManager.default.fileExists(atPath: directory.path) {
            do {
                try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("Error creating directory: \(error.localizedDescription)")
                return
            }
        }
        
        if FileManager.default.fileExists(atPath: destinationURL.path) {
            do {
                try FileManager.default.removeItem(at: destinationURL)
            } catch {
                print("Error removing existing file: \(error.localizedDescription)")
                return
            }
        }

        do {
            try FileManager.default.moveItem(at: location, to: destinationURL)
            DispatchQueue.main.async {
                self.isDownloadCompleted = true
                self.isDownloading = false
                print("Download completed: \(destinationURL.path)")
            }
        } catch {
            print("Error moving downloaded file: \(error.localizedDescription)")
        }
    }

    private func formatTime(seconds: Double) -> String {
        let minutes = Int(seconds) / 60
        let seconds = Int(seconds) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}
    
