//
//  VoicesRepositoryProtocol.swift
//  Papcorns101
//
//  Created by Deniz Çakmakçı on 3.11.2024.
//

import Foundation

protocol VoicesRepositoryProtocol {
    func getVoices() async throws -> NetworkResponseState<VoicesModel>
    func generateMusic(args: GenerateMusicArguments) async throws -> NetworkResponseState<GeneratedMusic>
}
