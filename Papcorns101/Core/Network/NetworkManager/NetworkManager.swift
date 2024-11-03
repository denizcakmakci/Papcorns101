//
//  NetworkManager.swift
//  Papcorns101
//
//  Created by Deniz Çakmakçı on 3.11.2024.
//

import Foundation
import Alamofire

class NetworkManager {
    static let shared = NetworkManager()

    func get<T: Decodable>(
        path: String,
        queryItems: [URLQueryItem]? = nil,
        withToken: Bool? = nil,
        headers: HTTPHeaders? = nil
    ) async throws -> NetworkResponseState<T> {
        try await BaseNetworkManager.shared.sendRequest(
            path: path,
            httpMethod: .get,
            queryItems: queryItems,
            body: NoArgument(),
            withToken: withToken,
            headers: headers
        )
    }

    func put<T: Decodable>(
        path: String,
        queryItems: [URLQueryItem]? = nil,
        body: (some Encodable)? = nil,
        withToken: Bool? = nil,
        headers: HTTPHeaders? = nil
    ) async throws -> NetworkResponseState<T> {
        try await BaseNetworkManager.shared.sendRequest(
            path: path,
            httpMethod: .put,
            queryItems: queryItems,
            body: body,
            withToken: withToken,
            headers: headers
        )
    }

    func post<T: Decodable>(
        path: String,
        queryItems: [URLQueryItem]? = nil,
        body: (some Encodable)? = nil,
        withToken: Bool? = nil,
        headers: HTTPHeaders? = nil
    ) async throws -> NetworkResponseState<T> {
        try await BaseNetworkManager.shared.sendRequest(
            path: path,
            httpMethod: .post,
            queryItems: queryItems,
            body: body,
            withToken: withToken,
            headers: headers
        )
    }

    func delete<T: Decodable>(
        path: String,
        queryItems: [URLQueryItem]? = nil,
        body: (some Encodable)? = nil,
        withToken: Bool? = nil,
        headers: HTTPHeaders? = nil
    ) async throws -> NetworkResponseState<T> {
        try await BaseNetworkManager.shared.sendRequest(
            path: path,
            httpMethod: .delete,
            queryItems: queryItems,
            body: body,
            withToken: withToken,
            headers: headers
        )
    }
}
