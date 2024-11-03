//
//  TranslateString.swift
//  Papcorns101
//
//  Created by Deniz Çakmakçı on 3.11.2024.
//

import Foundation

extension String {
    /// Localizes strings in localizable.string files
    /// example usage:  Text(LocalizationKeys.WelcomeMessage.greeting.rawValue.translate())
    /// - Returns: Localized string value
    func translate() -> String {
        guard let path = Bundle.main.path(forResource: LocalizationManager.shared.currentLanguageCode, ofType: "lproj"),
              let bundle = Bundle(path: path)
        else {
            return NSLocalizedString(self, comment: "")
        }

        return NSLocalizedString(self, tableName: "Localizable", bundle: bundle, comment: "")
    }
}
