//
//  TopBarView.swift
//  Papcorns101
//
//  Created by Deniz Çakmakçı on 6.11.2024.
//

import SwiftUI

struct TopBarView: View {
    var title: String?
    var shareAction: () -> Void = {}
    var copyAction: () -> Void = {}
    var backAction: () -> Void = {}

    var body: some View {
        HStack {
            Button {
                backAction()
            } label: {
                Image(systemName: "chevron.backward")
                    .foregroundColor(Color.white)
            }
            Spacer()
            Text(title ?? "")
            Spacer()
            Menu {
                Button(LocalizationKeys.Result.share.translate()) {
                    shareAction()
                }
                Button(LocalizationKeys.Result.copyText.translate()) {
                    copyAction()
                }
            } label: {
                Image(systemName: "ellipsis")
                    .foregroundColor(Color.white)
            }
            .frame(width: 32)
        }
    }
}

#Preview {
    TopBarView()
}
