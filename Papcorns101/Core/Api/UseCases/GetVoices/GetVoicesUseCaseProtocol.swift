//
//  GetVoicesUseCaseProtocol.swift
//  Papcorns101
//
//  Created by Deniz Çakmakçı on 3.11.2024.
//

import Foundation

protocol GetVoicesUseCaseProtocol: UseCaseProtocol {
    func invoke() async -> UIState<VoicesModel>
}
