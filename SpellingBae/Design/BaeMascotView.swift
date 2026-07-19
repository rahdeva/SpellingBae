//
//  BaeMascotView.swift
//  SpellingBae
//
//  "Bae the Bee" mascot, drawn as a scalable vector illustration.
//  Authored in a 120x120 coordinate space and scaled to `size`.
//

import SwiftUI

enum BaeMood {
    case happy, cheer, think, oops, sleepy, wave, love

    var eyesOpen: Bool { self == .happy || self == .think || self == .oops || self == .wave }
    var eyesHappy: Bool { self == .cheer || self == .love }
    var eyesSleepy: Bool { self == .sleepy }
    var mouthSmile: Bool { self == .happy || self == .wave || self == .love }
    var mouthOpen: Bool { self == .cheer }
    var mouthO: Bool { self == .oops || self == .think || self == .sleepy }
}

struct BaeMascotView: View {
    var mood: BaeMood = .happy
    var size: CGFloat = 120

    private let inkColor = Color(hex: 0x2B2018)

    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.clear.frame(width: 120, height: 120)

            antenna(x: 44, rotation: -18)
            antennaBall(x: 41)
            antenna(x: 73, rotation: 18)
            antennaBall(x: 76)

            wing(x: 6, rotation: -18)
            wing(x: 70, rotation: 18)

            body120

            eyes
            cheeks
            mouth
        }
        .frame(width: 120, height: 120)
        .scaleEffect(size / 120)
        .frame(width: size, height: size)
    }

    // MARK: - Body

    private var body120: some View {
        ZStack(alignment: .topLeading) {
            StripedEllipse()
                .overlay(
                    Ellipse()
                        .fill(Color(hex: 0xFFE7A8).opacity(0.96))
                        .frame(width: 52, height: 40)
                        .offset(x: 14, y: 12)
                )
                .overlay(Ellipse().strokeBorder(inkColor, lineWidth: 3.5))
                .frame(width: 80, height: 74)
                .clipShape(Ellipse())
        }
        .frame(width: 80, height: 74, alignment: .topLeading)
        .offset(x: 20, y: 32)
    }

    // MARK: - Antennae

    private func antenna(x: CGFloat, rotation: Double) -> some View {
        RoundedRectangle(cornerRadius: 2)
            .fill(inkColor)
            .frame(width: 3, height: 20)
            .rotationEffect(.degrees(rotation))
            .frame(width: 3, height: 20, alignment: .topLeading)
            .offset(x: x, y: 8)
    }

    private func antennaBall(x: CGFloat) -> some View {
        Circle()
            .fill(inkColor)
            .frame(width: 9, height: 9)
            .offset(x: x, y: 4)
    }

    // MARK: - Wings

    private func wing(x: CGFloat, rotation: Double) -> some View {
        Ellipse()
            .fill(Color.white.opacity(0.82))
            .overlay(Ellipse().strokeBorder(inkColor.opacity(0.18), lineWidth: 2.5))
            .frame(width: 44, height: 36)
            .rotationEffect(.degrees(rotation))
            .frame(width: 44, height: 36, alignment: .topLeading)
            .offset(x: x, y: 22)
    }

    // MARK: - Eyes

    @ViewBuilder
    private var eyes: some View {
        if mood.eyesOpen {
            openEye(x: 44)
            openEye(x: 63)
        } else if mood.eyesHappy {
            arcEye(x: 43)
            arcEye(x: 62)
        } else if mood.eyesSleepy {
            sleepyEye(x: 43)
            sleepyEye(x: 62)
        }
    }

    private func openEye(x: CGFloat) -> some View {
        Ellipse()
            .fill(Color.white)
            .overlay(Ellipse().strokeBorder(inkColor, lineWidth: 2))
            .overlay(
                Circle()
                    .fill(inkColor)
                    .frame(width: 6, height: 6)
                    .offset(x: 3, y: 5),
                alignment: .topLeading
            )
            .frame(width: 13, height: 15)
            .offset(x: x, y: 50)
    }

    private func arcEye(x: CGFloat) -> some View {
        ArcShape(up: true)
            .stroke(inkColor, style: StrokeStyle(lineWidth: 3, lineCap: .round))
            .frame(width: 14, height: 9)
            .offset(x: x, y: 52)
    }

    private func sleepyEye(x: CGFloat) -> some View {
        ArcShape(up: false)
            .stroke(inkColor, style: StrokeStyle(lineWidth: 3, lineCap: .round))
            .frame(width: 14, height: 7)
            .offset(x: x, y: 56)
    }

    // MARK: - Cheeks

    private var cheeks: some View {
        Group {
            cheek(x: 38)
            cheek(x: 72)
        }
    }

    private func cheek(x: CGFloat) -> some View {
        Ellipse()
            .fill(Color(hex: 0xFF9EB0).opacity(0.75))
            .frame(width: 10, height: 7)
            .offset(x: x, y: 64)
    }

    // MARK: - Mouth

    @ViewBuilder
    private var mouth: some View {
        if mood.mouthSmile {
            ArcShape(up: false)
                .stroke(inkColor, style: StrokeStyle(lineWidth: 2.5, lineCap: .round))
                .frame(width: 16, height: 9)
                .offset(x: 52, y: 68)
        } else if mood.mouthOpen {
            RoundedRectangle(cornerRadius: 6)
                .fill(Color(hex: 0xB4442E))
                .overlay(RoundedRectangle(cornerRadius: 6).strokeBorder(inkColor, lineWidth: 2.5))
                .overlay(
                    Ellipse()
                        .fill(Color(hex: 0xFF7E86))
                        .frame(width: 8, height: 5)
                        .offset(x: 3, y: -1),
                    alignment: .bottomLeading
                )
                .frame(width: 16, height: 14)
                .offset(x: 52, y: 67)
        } else if mood.mouthO {
            Circle()
                .fill(Color(hex: 0xB4442E))
                .overlay(Circle().strokeBorder(inkColor, lineWidth: 2.5))
                .frame(width: 10, height: 11)
                .offset(x: 55, y: 69)
        }
    }
}

// MARK: - Supporting shapes

/// A downward (smile) or upward (frown-free happy-eye) arc.
private struct ArcShape: Shape {
    /// `true` draws the arc curving up (∩), `false` curving down (∪).
    var up: Bool

    func path(in rect: CGRect) -> Path {
        var path = Path()
        if up {
            path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.addQuadCurve(
                to: CGPoint(x: rect.maxX, y: rect.maxY),
                control: CGPoint(x: rect.midX, y: rect.minY - rect.height)
            )
        } else {
            path.move(to: CGPoint(x: rect.minX, y: rect.minY))
            path.addQuadCurve(
                to: CGPoint(x: rect.maxX, y: rect.minY),
                control: CGPoint(x: rect.midX, y: rect.maxY + rect.height)
            )
        }
        return path
    }
}

/// The bee's striped abdomen: a yellow ellipse overlaid with diagonal dark bars.
private struct StripedEllipse: View {
    var body: some View {
        Ellipse()
            .fill(Color(hex: 0xFFC53D))
            .overlay(
                Stripes()
                    .fill(Color(hex: 0x2B2018))
                    .frame(width: 200, height: 200)
                    .rotationEffect(.degrees(28))
            )
            .clipShape(Ellipse())
    }

    private struct Stripes: Shape {
        func path(in rect: CGRect) -> Path {
            var path = Path()
            let period: CGFloat = 26
            let darkWidth: CGFloat = 11
            var x = rect.minX
            while x < rect.maxX {
                path.addRect(CGRect(x: x, y: rect.minY, width: darkWidth, height: rect.height))
                x += period
            }
            return path
        }
    }
}

#Preview {
    HStack(spacing: 12) {
        BaeMascotView(mood: .happy, size: 90)
        BaeMascotView(mood: .cheer, size: 90)
        BaeMascotView(mood: .wave, size: 90)
        BaeMascotView(mood: .sleepy, size: 90)
    }
    .padding(40)
    .background(Bae.canvas)
}
