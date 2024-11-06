//
//  AIVoiceViewModel.swift
//  Papcorns101
//
//  Created by Deniz Çakmakçı on 3.11.2024.
//

import Foundation
import UIKit

@MainActor
class AIVoiceViewModel: ObservableObject {
    @Published var screenDataState = UIState<VoicesModel>.empty
    @Published var generatedMusicDataState = UIState<GeneratedMusic>.empty
    @Published var selectedCategory: String = LocalizationKeys.AiVoice.all.translate()
    @Published var selectedPromp: String?
    @Published var selectedVoiceItem: VoiceModel?
    @Published var categories: [String]?
    @Published var promps: [String] = []

    private var getVoicesUseCase: GetVoicesUseCase
    private var generateMusicUseCase: GenerateMusicUseCase

    init() {
        getVoicesUseCase = GetVoicesUseCase.shared
        generateMusicUseCase = GenerateMusicUseCase.shared
        loadPhrases()
    }

    private func loadPhrases() {
        if let url = Bundle.main.url(forResource: "promps", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoded = try JSONDecoder().decode(PrompsList.self, from: data)
                promps = decoded.promps
            } catch {
                print("Error loading phrases: \(error)")
            }
        }
    }

    func getVoices() {
        screenDataState = .loading
        Task {
            let response = await getVoicesUseCase.invoke()
            if let objects = response.value?.objects {
                let uniqueCategories = Set(objects.map { $0.category })
                DispatchQueue.main.async {
                    self.categories = [LocalizationKeys.AiVoice.all.translate()] + Array(uniqueCategories)
                    if let value = response.value {
                        self.screenDataState = .success(value)
                    }
                }
            } else {
                if case .failure(let error) = response {
                    self.screenDataState = .failure(error)
                }
            }
        }
    }

    var filteredItems: [VoiceModel] {
        if selectedCategory == LocalizationKeys.AiVoice.all.translate() {
            return screenDataState.value?.objects ?? []
        } else {
            return screenDataState.value?.objects.filter { $0.category == selectedCategory } ?? []
        }
    }

    func changeSelectedVoiceItem(item: VoiceModel) {
        if selectedVoiceItem?.order == item.order {
            selectedVoiceItem = nil
        } else {
            selectedVoiceItem = item
        }
    }

    func selectRandomPromp() {
        selectedPromp = promps.randomElement() ?? ""
    }
    
    func clearSelectedVoiceItem() {
        selectedVoiceItem = nil
        selectedPromp = nil
    }

    func generateMusic() async {
        generatedMusicDataState = .loading
        if let selectedPromp = selectedPromp {
            let response = await generateMusicUseCase.invoke(
                arguments: GenerateMusicArguments(promp: selectedPromp, cover: selectedVoiceItem?.name)
            )
            if let value = response.value {
                generatedMusicDataState = .success(value)
            } else {
                if case .failure(let error) = response {
                    generatedMusicDataState = .failure(error)
                }
            }
        }
    }
}
