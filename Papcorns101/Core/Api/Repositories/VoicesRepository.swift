//
//  VoicesRepository.swift
//  Papcorns101
//
//  Created by Deniz Çakmakçı on 3.11.2024.
//

import Foundation

struct VoicesRepository: VoicesRepositoryProtocol {
    private let networkManager: NetworkManager

    private init() {
        networkManager = NetworkManager.shared
    }

    static let shared = VoicesRepository()

    func getVoices() async throws -> NetworkResponseState<VoicesModel> {
        try await networkManager.post(path: ApiEndpoints.getVoice.rawValue, body: NoArgument())
    }

    func generateMusic(args: GenerateMusicArguments) async throws -> NetworkResponseState<GeneratedMusic> {
        try await networkManager.post(
            path: ApiEndpoints.generateMusic.rawValue,
            body: args
        )
    }
}
