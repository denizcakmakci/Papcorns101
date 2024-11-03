//
//  AppFontModifier.swift
//  Papcorns101
//
//  Created by Deniz Çakmakçı on 3.11.2024.
//

import Foundation
import SwiftUICore

struct AppFontModifier: ViewModifier {
    var font: Font
    var lineSpacing: CGFloat
    var tracking: CGFloat

    func body(content: Content) -> some View {
        content
            .font(font)
            .lineSpacing(lineSpacing)
            .tracking(tracking)
    }
}

extension View {
    func appFont(font: Font, lineSpacing: CGFloat = 0, tracking: CGFloat = 0) -> some View {
        modifier(AppFontModifier(font: font, lineSpacing: lineSpacing, tracking: tracking))
    }
}
