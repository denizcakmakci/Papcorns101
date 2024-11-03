//
//  UIState.swift
//  Papcorns101
//
//  Created by Deniz Çakmakçı on 3.11.2024.
//

import Foundation

enum UIState<T> {
    case loading
    case empty
    case success(T)
    case failure(Error)

    var value: T? {
        if case let .success(value) = self {
            return value
        }

        return nil
    }
}
