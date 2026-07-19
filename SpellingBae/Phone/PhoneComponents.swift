//
//  PhoneComponents.swift
//  SpellingBae
//
//  Small reusable pieces shared across the iPhone screens.
//

import SwiftUI

/// The primary amber call-to-action button with the design's "pressed" bottom shadow.
struct HoneyButton: View {
    var title: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.baloo(19))
                .foregroundStyle(Bae.ink)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Bae.action, in: RoundedRectangle(cornerRadius: 20))
                .overlay(alignment: .bottom) {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Bae.honeyDeep)
                        .frame(height: 6)
                        .offset(y: 3)
                        .mask(RoundedRectangle(cornerRadius: 20))
                }
                .shadow(color: Bae.honeyDeep.opacity(0.3), radius: 12, y: 8)
        }
        .buttonStyle(.plain)
    }
}

/// Honey / streak pill used in headers.
struct StatPill: View {
    var text: String
    var tint: Color
    var fill: Color
    var stroke: Color
    var showHex: Bool

    var body: some View {
        HStack(spacing: showHex ? 5 : 4) {
            if showHex { HexBadge(size: 15) }
            Text(text)
        }
        .font(.baloo(15))
        .foregroundStyle(tint)
        .padding(.vertical, 6)
        .padding(.leading, showHex ? 8 : 11)
        .padding(.trailing, showHex ? 12 : 11)
        .background(fill, in: Capsule())
        .overlay(Capsule().strokeBorder(stroke, lineWidth: 1.5))
    }
}

extension StatPill {
    static func honey(_ value: Int) -> StatPill {
        StatPill(text: "\(value)", tint: Bae.honey, fill: Bae.pill, stroke: Bae.pillBorder, showHex: true)
    }
    static func streak(_ value: Int) -> StatPill {
        StatPill(text: "🔥\(value)", tint: Bae.streak, fill: Bae.coralTint, stroke: Bae.coralBorder, showHex: false)
    }
}

/// Gentle vertical bob for the mascot; respects the reduce-motion toggle.
struct Bobbing: ViewModifier {
    var active: Bool = true
    @State private var up = false
    func body(content: Content) -> some View {
        content
            .offset(y: (active && up) ? -9 : 0)
            .animation(active ? .easeInOut(duration: 1.3).repeatForever(autoreverses: true) : .default, value: up)
            .onAppear { if active { up = true } }
    }
}

/// Expanding, fading ring behind a circular button.
struct PulseRing: ViewModifier {
    @State private var animate = false
    func body(content: Content) -> some View {
        content
            .scaleEffect(animate ? 2.1 : 0.9)
            .opacity(animate ? 0 : 0.7)
            .animation(.easeOut(duration: 1).repeatForever(autoreverses: false), value: animate)
            .onAppear { animate = true }
    }
}

extension View {
    func bobbing(_ active: Bool = true) -> some View { modifier(Bobbing(active: active)) }
    func pulseRing() -> some View { modifier(PulseRing()) }
}

/// A back header row: chevron button + title.
struct BackHeader: View {
    var title: String
    var glyph: String = "‹"
    var action: () -> Void

    var body: some View {
        HStack(spacing: 10) {
            Button(action: action) {
                Text(glyph)
                    .font(.system(size: 18, weight: .heavy))
                    .foregroundStyle(Color(hex: 0x7A5A20))
                    .frame(width: 34, height: 34)
                    .background(Color(hex: 0xF2E4C6), in: Circle())
            }
            .buttonStyle(.plain)
            Text(title).font(.baloo(23)).foregroundStyle(Bae.ink)
            Spacer(minLength: 0)
        }
    }
}

/// Rounded card container with the design's soft border and shadow.
struct SoftCard<Content: View>: View {
    var padding: CGFloat = 16
    var cornerRadius: CGFloat = 20
    var fill: Color = .white
    @ViewBuilder var content: Content

    var body: some View {
        content
            .padding(padding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(fill, in: RoundedRectangle(cornerRadius: cornerRadius))
            .overlay(RoundedRectangle(cornerRadius: cornerRadius).strokeBorder(Bae.cardBorder, lineWidth: 1))
    }
}
