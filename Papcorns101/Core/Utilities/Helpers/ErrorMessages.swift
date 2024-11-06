//
//  ErrorMessages.swift
//  Papcorns101
//
//  Created by Deniz Çakmakçı on 3.11.2024.
//

import Foundation

class ErrorWithDescription: NSObject, LocalizedError {
    var desc = ""
    init(str: String) {
        desc = str
    }

    override var description: String {
        desc
    }

    var errorDescription: String? {
        description
    }
}
