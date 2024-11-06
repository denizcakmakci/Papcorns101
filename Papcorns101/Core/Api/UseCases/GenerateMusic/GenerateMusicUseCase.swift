//
//  GenerateMusicUseCase.swift
//  Papcorns101
//
//  Created by Deniz Çakmakçı on 3.11.2024.
//

import Foundation

struct GenerateMusicUseCase: GenerateMusicUseCaseProtocol {
    var errorMessages = NetworkErrorMessages()
    private let repository: VoicesRepository

    private init() {
        repository = VoicesRepository.shared
        errorMessages.forbidden = ""
        errorMessages.unprocessableEntity = ""
        errorMessages.conflict = ""
    }

    static let shared = GenerateMusicUseCase()

    func invoke(arguments: GenerateMusicArguments) async -> UIState<GeneratedMusic> {
        do {
            let result = try await repository.generateMusic(args: arguments)
            switch result {
            case let .success(response):
                return .success(response)
            case let .failure(error):
                return .failure(ErrorWithDescription(str: handleError(error)))
            }
        } catch {
            return .failure(error)
        }
    }
}
