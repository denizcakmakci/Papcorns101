//
//  GetVoicesUseCase.swift
//  Papcorns101
//
//  Created by Deniz Çakmakçı on 3.11.2024.
//

import Foundation

struct GetVoicesUseCase: GetVoicesUseCaseProtocol {
    var errorMessages = NetworkErrorMessages()
    private let repository: VoicesRepository

    private init() {
        repository = VoicesRepository.shared
        errorMessages.forbidden = ""
        errorMessages.unprocessableEntity = ""
        errorMessages.conflict = ""
    }

    static let shared = GetVoicesUseCase()

    func invoke() async -> UIState<VoicesModel> {
        do {
            let result = try await repository.getVoices()
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
