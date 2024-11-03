//
//  RequestHeaders.swift
//  Papcorns101
//
//  Created by Deniz Çakmakçı on 3.11.2024.
//

import Foundation
import Alamofire

class RequestHeaders {
    static let shared = RequestHeaders()

    /// Add custom HTTP headers to a URLRequest.
    /// - Parameters:
    ///   - request: The URLRequest to which the headers will be added.
    ///   - headers: The custom HTTP headers to be added to the URLRequest. It should be of type `HTTPHeaders`.
    /// - Returns: A new `URLRequest` object with the custom headers added.
    func addHeadersToRequest(request: URLRequest, headers: HTTPHeaders) -> URLRequest {
        var updatedRequest = request
        headers.dictionary.forEach { key, value in
            updatedRequest.setValue(value, forHTTPHeaderField: key)
        }
        return updatedRequest
    }
}
