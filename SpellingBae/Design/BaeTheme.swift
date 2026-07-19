//
//  BaeTheme.swift
//  SpellingBae
//
//  Color palette and typography for the SpellingBae design system.
//

import SwiftUI

extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255,
            opacity: alpha
        )
    }
}

/// Named colors sampled from the SpellingBae iPad design.
enum Bae {
    // Surfaces
    static let canvas = Color(hex: 0xF3E7D0)
    static let panel = Color(hex: 0xFFF9EF)
    static let sidebarTop = Color(hex: 0xFFF3D6)
    static let sidebarBottom = Color(hex: 0xFFEBC0)
    static let hairline = Color(hex: 0xF0E0C0)
    static let cardBorder = Color(hex: 0xF3E4C4)

    // Text
    static let ink = Color(hex: 0x3B2B1A)
    static let inkStrong = Color(hex: 0x5C3800)
    static let inkMuted = Color(hex: 0x7A6244)
    static let inkSoft = Color(hex: 0x9A825F)

    // Honey / brand
    static let honey = Color(hex: 0xB5730A)
    static let honeyBright = Color(hex: 0xF5920B)
    static let honeyDeep = Color(hex: 0xE08600)
    static let honeyLight = Color(hex: 0xFFD873)
    static let amber = Color(hex: 0xFFB020)
    static let action = Color(hex: 0xFFA808)
    static let combEmpty = Color(hex: 0xF0DBAE)

    // Accent families
    static let streak = Color(hex: 0xC0492C)
    static let blueInk = Color(hex: 0x2A6E9E)
    static let blueTint = Color(hex: 0xEAF6FF)
    static let blueBorder = Color(hex: 0xC6E4F5)
    static let blueSoft = Color(hex: 0x5B8CAE)
    static let blueDeep = Color(hex: 0x2A8FD6)
    static let blueLight = Color(hex: 0x7FC8F5)
    static let micCoral = Color(hex: 0xE8734A)
    static let micCoralLight = Color(hex: 0xF5A08A)
    static let coralTint = Color(hex: 0xFDECE4)
    static let coralBorder = Color(hex: 0xF5C3B4)
    static let coralSoft = Color(hex: 0xCC7C63)

    // Feedback
    static let correctInk = Color(hex: 0x2C7A3F)
    static let correctFill = Color(hex: 0xE4F6E1)
    static let correctBorder = Color(hex: 0x8FD08A)
    static let correctButton = Color(hex: 0x2FA36B)
    static let correctButtonShadow = Color(hex: 0x237A4F)
    static let wrongFill = Color(hex: 0xFDE3DB)
    static let wrongBorder = Color(hex: 0xF0A48C)

    // Slot / keyboard
    static let slotFill = Color(hex: 0xFFF7E6)
    static let slotBorder = Color(hex: 0xF0DBAE)
    static let keyShadow = Color(hex: 0xC9B588)
    static let pill = Color(hex: 0xFFF1D6)
    static let pillBorder = Color(hex: 0xF2D89A)
}

extension Font {
    /// Display / heading font — approximates the design's "Baloo 2".
    static func baloo(_ size: CGFloat, _ weight: Font.Weight = .heavy) -> Font {
        .system(size: size, weight: weight, design: .rounded)
    }

    /// Body font — approximates the design's "Nunito".
    static func nunito(_ size: CGFloat, _ weight: Font.Weight = .bold) -> Font {
        .system(size: size, weight: weight, design: .rounded)
    }
}
