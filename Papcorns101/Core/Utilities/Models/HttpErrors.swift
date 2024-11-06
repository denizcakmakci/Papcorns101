//
//  HttpErrors.swift
//  Papcorns101
//
//  Created by Deniz Çakmakçı on 3.11.2024.
//

import Foundation

enum HttpError: Int {
    case unauthorized = 401
    case forbidden = 403
    case badRequest = 400
    case notFound = 404
    case unprocessableEntity = 422
    case conflict = 409
    case requestTimeout = 408
    case tooManyRequests = 429
    case none = 0
}

struct NetworkErrorMessages {
    var unauthorized = "Unauthorized access"
    var forbidden = "Forbidden"
    var badRequest = "Bad request"
    var notFound = "Not found"
    var unprocessableEntity = "Unprocessable entity"
    var conflict = "Conflict"
    var requestTimeout = "Request timeout"
    var defaultError = "An error occurred"
    var tooManyRequests = "Çok fazla istek gönderdiniz, lütfen daha sonra tekrar deneyin."
}

extension Int {
    func convertHttpStatus() -> HttpError {
        switch self {
        case 401:
            return .unauthorized
        case 403:
            return .forbidden
        case 400:
            return .badRequest
        case 404:
            return .notFound
        case 422:
            return .unprocessableEntity
        case 409:
            return .conflict
        case 408:
            return .requestTimeout
        case 429:
            return .tooManyRequests
        default:
            return .none
        }
    }
}

