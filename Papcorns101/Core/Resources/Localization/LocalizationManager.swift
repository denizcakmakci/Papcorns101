//
//  LocalizationManager.swift
//  Papcorns101
//
//  Created by Deniz Çakmakçı on 3.11.2024.
//

import Foundation

class LocalizationManager: ObservableObject {
    static let shared = LocalizationManager()

    @Published var currentLanguageCode: String = "tr"
    private let languageKey = "SelectedLanguageKey"

    private let supportedLanguages = ["en", "tr"]

    private init() {
        setupInitialLanguage()
    }

    func setupInitialLanguage() {
        currentLanguageCode = Locale.preferredLanguages.first ?? "tr"
    }

    func setLanguage(_ languageCode: String) {
        if supportedLanguages.contains(languageCode) {
            currentLanguageCode = languageCode
            UserDefaults.standard.set(languageCode, forKey: languageKey)
        } else {
            currentLanguageCode = "tr"
            UserDefaults.standard.set("tr", forKey: languageKey)
        }
    }
}
