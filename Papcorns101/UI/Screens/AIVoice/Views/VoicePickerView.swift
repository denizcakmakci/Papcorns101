//
//  VoicePickerView.swift
//  Papcorns101
//
//  Created by Deniz Çakmakçı on 5.11.2024.
//

import Kingfisher
import SwiftUI

struct VoicePickerView: View {
    @ObservedObject var viewModel: AIVoiceViewModel

    var body: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(viewModel.categories ?? [], id: \.self) { category in
                        FilterTapItemView(
                            text: category,
                            isSelected: viewModel.selectedCategory == category,
                            action: {
                                viewModel.selectedCategory = category
                            }
                        )
                    }
                }
                .padding(.bottom, 12)
            }
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 13) {
                    ForEach(viewModel.filteredItems, id: \.order) { item in
                        VStack {
                            VoiceItemView(
                                imageUrl: item.imageUrl,
                                isSelected: viewModel.selectedVoiceItem?.order == item.order,
                                action: {
                                    viewModel.changeSelectedVoiceItem(item: item)
                                }
                            )
                            Text(item.name)
                                .appFont(font: AppFonts.bodySemiBold, lineSpacing: 5)
                                .lineLimit(1)
                        }
                    }
                }
            }
        }
    }
}
