//
//  GenerateMusicUseCaseProtocol.swift
//  Papcorns101
//
//  Created by Deniz Çakmakçı on 3.11.2024.
//

import Foundation

protocol GenerateMusicUseCaseProtocol: UseCaseProtocol {
    func invoke(arguments: GenerateMusicArguments) async -> UIState<GeneratedMusic>
}
