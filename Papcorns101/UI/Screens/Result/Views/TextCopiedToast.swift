//
//  TectCopiedToast.swift
//  Papcorns101
//
//  Created by Deniz Çakmakçı on 6.11.2024.
//

import SwiftUI

struct TextCopiedToast: View {
    var body: some View {
        VStack {
            Spacer()
            Text(LocalizationKeys.Result.copied.translate())
                .padding()
                .background(Color.black.opacity(0.8))
                .foregroundColor(.white)
                .cornerRadius(8)
                .padding(.bottom, 50)
                .transition(.opacity)
        }
    }
}

#Preview {
    TextCopiedToast()
}
