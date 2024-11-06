//
//  SelectedPromp.swift
//  Papcorns101
//
//  Created by Deniz Çakmakçı on 6.11.2024.
//

import SwiftUI

struct SelectedPrompView: View {
    var promp: String?
    var body: some View {
        Text(LocalizationKeys.Result.text.translate())
            .appFont(font: AppFonts.largeTitle)
        ZStack(alignment: .top) {
            Color.systemDark
                .cornerRadius(12)
                .frame(maxWidth: .infinity)
                .frame(height: 120)
            Text(promp ?? "")
                .foregroundColor(Color.white)
                .appFont(font: AppFonts.bodySemiBold, lineSpacing: 5)
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
                .padding(.leading, 16)
                .padding(.top, 16)
                .padding(.trailing, 10)
        }
        .padding(.bottom, 20)
    }
}

#Preview {
    SelectedPrompView()
}
