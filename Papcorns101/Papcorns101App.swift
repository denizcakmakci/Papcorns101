//
//  Papcorns101App.swift
//  Papcorns101
//
//  Created by Deniz Çakmakçı on 3.11.2024.
//

import SwiftUI

@main
struct Papcorns101App: App {
    @StateObject private var viewModel = AIVoiceViewModel()
    @ObservedObject private var languageManager = LocalizationManager.shared
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                AIVoiceView()
                    .preferredColorScheme(.dark)
                    .environmentObject(viewModel)
                    .environmentObject(languageManager)
            }
        }
    }
}
