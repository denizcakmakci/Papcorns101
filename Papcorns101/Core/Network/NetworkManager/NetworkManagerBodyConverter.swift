//
//  NetworkManagerBodyConverter.swift
//  Papcorns101
//
//  Created by Deniz Çakmakçı on 3.11.2024.
//

import Foundation

func convertNetworkBodyModelToData(model: some Encodable) -> Data? {
    let jsonEncoder = JSONEncoder()
    guard let data = try? jsonEncoder.encode(model) else { return nil }
    return data
}
