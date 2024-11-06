//
//  BaseNetworkManager.swift
//  Papcorns101
//
//  Created by Deniz Çakmakçı on 3.11.2024.
//

import Foundation
import Alamofire

class BaseNetworkManager {
    static let shared = BaseNetworkManager()

    /// Creates the url to send the request
    /// - Parameters:
    ///   - path: Endpoints from ApiEndpoint enum.
    ///   - queryItems: The item identifier to use for the url when querying items.
    /// - Returns: Returns the url to be requested as a URL object.
    private func createUrl(path: String, queryItems: [URLQueryItem]?) throws -> URL? {
        if let baseUrl = AppEnvironmentFields.baseURL {
            var urlComponents = URLComponents(string: baseUrl + path)
            urlComponents?.queryItems = queryItems
            return urlComponents?.url
        }

        return nil
    }

    /// Create a URLRequest with the given parameters.
    /// - Parameters:
    ///   - url: The URL to which the request should be made.
    ///   - httpMethod: The HTTP method for the request (e.g., GET, POST, PUT, DELETE, etc.).
    ///   - headers: The headers to be included in the request, if any. It should be of type `RequestParameters`.
    ///   - body: The optional data to be included as the request body.
    /// - Returns: A `URLRequest` object configured with the provided parameters.
    private func createRequest(
        url: URL,
        httpMethod: HTTPMethod,
        headers: HTTPHeaders?,
        body: Data?
    ) async throws -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        request.httpBody = body
        if let headers {
            request = RequestHeaders.shared.addHeadersToRequest(request: request, headers: headers)
        }

        return request
    }

    /// Handles the response of a network request and returns the state of the network response.
    /// - Parameters:
    ///   - request: The URLRequest to be processed
    ///   - withToken: A flag indicating whether to include a token in the request.
    ///   Pass `true` to include the token, or `false` to exclude it.
    /// - Returns: A `NetworkResponseState<T>` representing the state of the network response,
    ///  where `T` is a generic type conforming to `Decodable`.
    private func handleResponse<T: Decodable>(request: URLRequest, withToken: Bool?) async -> NetworkResponseState<T> {

        let dataRequest = AF.request(request).validate().serializingDecodable(T.self)

        let result = await dataRequest.response

        if let statusCode = result.response?.statusCode {
            if statusCode >= 200, statusCode < 300 {
                if let value = result.value {
                    return .success(value)
                }
            } else {
                return .failure(statusCode.convertHttpStatus())
            }
        } else {
            return .failure(HttpError.notFound)
        }
        return .failure(HttpError.notFound)
    }

    func sendRequest<T: Decodable>(
        path: String,
        httpMethod: HTTPMethod,
        queryItems: [URLQueryItem]? = nil,
        body: (some Encodable)? = nil,
        withToken: Bool? = nil,
        headers: HTTPHeaders? = nil
    ) async throws -> NetworkResponseState<T> {
        guard let url = try createUrl(path: path, queryItems: queryItems) else {
            throw URLError(URLError.badURL)
        }

        let request = try await createRequest(
            url: url,
            httpMethod: httpMethod,
            headers: headers,
            body: body is NoArgument ? nil : convertNetworkBodyModelToData(model: body)
        )

        let response: NetworkResponseState<T>
        response = await handleResponse(request: request, withToken: withToken)
        return response
    }
}
