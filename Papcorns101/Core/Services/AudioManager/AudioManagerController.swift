//
//  AudioManagerController.swift
//  Papcorns101
//
//  Created by Deniz Çakmakçı on 6.11.2024.
//

import Foundation
import UIKit

extension Notification.Name {
    static let downloadCompleted = Notification.Name("downloadCompleted")
}

class MyViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(handleDownloadCompletion), name: .downloadCompleted, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: .downloadCompleted, object: nil)
    }

    @objc func handleDownloadCompletion() {
        print("Download completed notification received.")
    }
}
