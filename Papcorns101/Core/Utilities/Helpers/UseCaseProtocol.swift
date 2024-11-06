//
//  UseCaseProtocol.swift
//  Papcorns101
//
//  Created by Deniz Çakmakçı on 3.11.2024.
//

import Foundation

protocol UseCaseProtocol {
    var errorMessages: NetworkErrorMessages { get set }
}

extension UseCaseProtocol {
    func handleError(_ error: HttpError) -> String {
        switch error {
        case .unauthorized:
            errorMessages.unauthorized
        case .forbidden:
            errorMessages.forbidden
        case .badRequest:
            errorMessages.badRequest
        case .notFound:
            errorMessages.notFound
        case .unprocessableEntity:
            errorMessages.unprocessableEntity
        case .conflict:
            errorMessages.conflict
        case .requestTimeout:
            errorMessages.requestTimeout
        case .tooManyRequests:
            errorMessages.tooManyRequests
        case .none:
            errorMessages.defaultError
        }
    }
}
