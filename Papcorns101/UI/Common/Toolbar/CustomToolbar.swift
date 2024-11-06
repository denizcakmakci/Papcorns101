//
//  CustomToolbar.swift
//  Papcorns101
//
//  Created by Deniz Çakmakçı on 6.11.2024.
//

import SwiftUI

struct CustomToolbar: ToolbarContent {
    @Environment(\.dismiss) var dismiss
    var title: String
    var backButtonAction: () -> Void = {}

    var body: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                backButtonAction()
                dismiss()
            } label: {
                Image(systemName: "chevron.backward")
                    .foregroundColor(Color.white)
            }
        }
        ToolbarItem(placement: .principal) {
            Text(title)
        }
        
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                backButtonAction()
                dismiss()
            } label: {
                Image(systemName: "chevron.backward")
                    .foregroundColor(Color.white)
            }
        }
    }
}

