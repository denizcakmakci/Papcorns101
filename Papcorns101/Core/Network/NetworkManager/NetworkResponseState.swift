//
//  NetworkResponseState.swift
//  Papcorns101
//
//  Created by Deniz Çakmakçı on 3.11.2024.
//

import Foundation

enum NetworkResponseState<T> {
    case success(T)
    case failure(HttpError)
}
