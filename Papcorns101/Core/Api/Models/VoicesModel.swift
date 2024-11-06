//
//  VoicesModel.swift
//  Papcorns101
//
//  Created by Deniz Çakmakçı on 3.11.2024.
//

import Foundation

struct VoicesModel: Codable {
    var objects: [VoiceModel]
}


struct VoiceModel: Codable {
    var imageUrl: String
    var category: String
    var order: Int
    var name: String
}
