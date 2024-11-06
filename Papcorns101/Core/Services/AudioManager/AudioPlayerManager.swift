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
import UIKit

class AudioPlayerManager: NSObject, ObservableObject, URLSessionDownloadDelegate {
    private var player: AVPlayer?
    private var playerItem: AVPlayerItem?
    private var timeObserverToken: Any?
    
    // Download properties
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
    
    var audioURL: URL?
    
    override init() {
        super.init()
         
        NotificationCenter.default.addObserver(self, selector: #selector(handleDownloadCompletion), name: .downloadCompleted, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: .downloadCompleted, object: nil)
    }

    @objc func handleDownloadCompletion() {
        DispatchQueue.main.async {
            self.isDownloadCompleted = true
        }
    }
    
    /// Function to configure the AVAudioSession for playback, bypassing the silent mode.
    private func configureAudioSession() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playback, mode: .moviePlayback, options: .mixWithOthers)
            try audioSession.setActive(true)
        } catch {
            print("Failed to configure audio session: \(error.localizedDescription)")
        }
    }
    
    /// Function to load an audio file from a URL and start observing its duration
    func loadAudio(url: URL, fileName: String? = "") {
        self.fileName = fileName
        playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        audioURL = url
        
        configureAudioSession()

        Task {
            do {
                let duration = try await playerItem?.asset.load(.duration)
                if let duration = duration {
                    DispatchQueue.main.async {
                        self.totalDuration = self.formatTime(seconds: CMTimeGetSeconds(duration))
                    }
                }
            } catch {
                print("Failed to load duration: \(error.localizedDescription)")
            }
        }
        
        startTimer()
        
        /// Observe when the player finishes playing
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
    
    /// Function to start a timer that updates the progress and current time during playback
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
    
    /// Function to start downloading the audio file from the provided URL
    func startDownload(url: URL) {
        
        let configuration = URLSessionConfiguration.background(withIdentifier: "com.example.app.background")
        backgroundSession = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)

        let task = backgroundSession?.downloadTask(with: url)
        task?.taskDescription = fileName
        downloadTask = task

        observation = downloadTask!.progress.observe(\.fractionCompleted) { [weak self] observationProgress, _ in
            DispatchQueue.main.async {
                self?.downloadProgress = observationProgress.fractionCompleted
                self?.isDownloading = true
            }
        }

        downloadTask?.resume()
    }
     
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard let fileName = downloadTask.taskDescription else { return }
        
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
                self.isDownloading = false
                self.isDownloadCompleted = true
                print("Download completed: \(destinationURL.path)")
                NotificationCenter.default.post(name: .downloadCompleted, object: nil)
            }
        } catch {
            print("Error moving downloaded file: \(error.localizedDescription)")
        }
    }
    
    /// Function to share the audio file or URL based on availability
    /// If the audio file is downloaded, it shares the local file data.
    /// If the audio file is not downloaded, it shares the URL of the file.
    func shareAudioFile(url: URL) {
        let fileManager = FileManager.default
        
        // Get the documents directory path where the file is expected to be saved
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let destinationURL = documentsDirectory.appendingPathComponent(fileName!)
        
        // Check if the file exists locally
        if fileManager.fileExists(atPath: destinationURL.path) {
            do {
                // If the file is found, read it as data
                let audioData = try Data(contentsOf: destinationURL)
                
                // Create a temporary file and give it the .mp3 extension
                let tempFileURL = documentsDirectory.appendingPathComponent("temp_audio.mp3")
                try audioData.write(to: tempFileURL)
                
                // Create a UIActivityViewController to share the file
                let activityViewController = UIActivityViewController(activityItems: [tempFileURL], applicationActivities: nil)
                
                // Present the activity view controller to share the file
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let currentViewController = windowScene.windows.first?.rootViewController
                {
                    currentViewController.present(activityViewController, animated: true, completion: nil)
                }
            } catch {
                print("Error while reading the audio file: \(error.localizedDescription)")
            }
        } else {
            // If the file is not found locally, share the URL instead
            let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            
            // Present the activity view controller to share the URL
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let currentViewController = windowScene.windows.first?.rootViewController
            {
                currentViewController.present(activityViewController, animated: true, completion: nil)
            }
        }
    }

    private func formatTime(seconds: Double) -> String {
        let minutes = Int(seconds) / 60
        let seconds = Int(seconds) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}
    
