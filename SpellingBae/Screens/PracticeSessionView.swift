//
//  PracticeSessionView.swift
//  SpellingBae
//
//  Listen & Spell session: audio prompt on the left, spelling + keyboard on the right.
//

import SwiftUI

struct PracticeSessionView: View {
    @Bindable var model: AppShellViewModel

    var body: some View {
        ZStack {
            HStack(spacing: 0) {
                listenPanel
                    .frame(width: 460)
                    .overlay(alignment: .trailing) {
                        Rectangle().fill(Bae.hairline).frame(width: 1)
                    }
                spellPanel
                    .frame(maxWidth: .infinity)
            }
            .background(
                LinearGradient(colors: [Color(hex: 0xFFF7E6), Bae.panel],
                               startPoint: .top, endPoint: .bottom)
            )

            if model.answer == .correct {
                successOverlay
            }
        }
    }

    // MARK: - Listen panel

    private var listenPanel: some View {
        VStack(spacing: 18) {
            HStack(spacing: 12) {
                BaeMascotView(mood: .happy, size: 52)
                Text("Listen, then spell the word!")
                    .font(.nunito(16))
                    .foregroundStyle(Bae.ink)
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 18)
            .background(
                Color.white,
                in: UnevenRoundedRectangle(cornerRadii: .init(
                    topLeading: 20, bottomLeading: 6, bottomTrailing: 20, topTrailing: 20))
            )
            .overlay(
                UnevenRoundedRectangle(cornerRadii: .init(
                    topLeading: 20, bottomLeading: 6, bottomTrailing: 20, topTrailing: 20))
                    .strokeBorder(Bae.cardBorder, lineWidth: 1)
            )
            .shadow(color: Color(hex: 0xA07828).opacity(0.10), radius: 7, y: 6)

            audioButton.padding(.top, 10)

            Text("Tap to hear the word")
                .font(.nunito(14))
                .foregroundStyle(Bae.inkSoft)

            HStack(spacing: 10) {
                secondaryButton("🔁 Repeat") { model.playAudio() }
                secondaryButton("🐌 Slow") { model.playAudio(slow: true) }
            }

            Text("💡 \(model.currentWord.count) letters · a place where plants grow")
                .font(.nunito(14))
                .foregroundStyle(Color(hex: 0x8A6A2E))
                .multilineTextAlignment(.center)
                .padding(.vertical, 14)
                .padding(.horizontal, 18)
                .frame(maxWidth: 320)
                .background(Color(hex: 0xFFF6E0), in: RoundedRectangle(cornerRadius: 18))
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .strokeBorder(Color(hex: 0xF2C86A), style: StrokeStyle(lineWidth: 1.5, dash: [5, 4]))
                )
        }
        .frame(maxHeight: .infinity)
        .padding(30)
    }

    private var audioButton: some View {
        ZStack {
            if model.audioPulse {
                Circle()
                    .fill(Bae.amber)
                    .frame(width: 130, height: 130)
                    .modifier(PulseRingModifier())
            }
            Button {
                model.playAudio()
            } label: {
                Text("🔊")
                    .font(.system(size: 52))
                    .frame(width: 130, height: 130)
                    .background(
                        RadialGradient(colors: [Bae.honeyLight, Bae.honeyBright],
                                       center: UnitPoint(x: 0.4, y: 0.35),
                                       startRadius: 4, endRadius: 90),
                        in: Circle()
                    )
                    .shadow(color: Bae.honeyDeep.opacity(0.4), radius: 14, y: 12)
            }
            .buttonStyle(.plain)
        }
    }

    private func secondaryButton(_ title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.baloo(14, .bold))
                .foregroundStyle(Bae.honey)
                .padding(.vertical, 10)
                .padding(.horizontal, 18)
                .background(Bae.pill, in: RoundedRectangle(cornerRadius: 14))
                .overlay(RoundedRectangle(cornerRadius: 14).strokeBorder(Bae.pillBorder, lineWidth: 1.5))
        }
        .buttonStyle(.plain)
    }

    // MARK: - Spell panel

    private var spellPanel: some View {
        VStack(spacing: 0) {
            topBar
            Spacer(minLength: 0)
            slotRow
            Spacer(minLength: 0)
            keyboard
        }
        .padding(.vertical, 22)
        .padding(.horizontal, 26)
    }

    private var topBar: some View {
        HStack(spacing: 14) {
            Button(action: model.exitToHome) {
                Text("×")
                    .font(.system(size: 20, weight: .heavy))
                    .foregroundStyle(Color(hex: 0x7A5A20))
                    .frame(width: 38, height: 38)
                    .background(Color(hex: 0xF2E4C6), in: Circle())
            }
            .buttonStyle(.plain)

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule().fill(Color(hex: 0xF2E4C6))
                    Capsule()
                        .fill(LinearGradient(colors: [Bae.honeyLight, Bae.honeyBright],
                                             startPoint: .leading, endPoint: .trailing))
                        .frame(width: geo.size.width * model.progressFraction)
                        .animation(.easeOut(duration: 0.4), value: model.progressFraction)
                }
            }
            .frame(height: 14)

            Text("\(model.questionNumber)/\(model.totalWords)")
                .font(.baloo(16))
                .foregroundStyle(Bae.honey)
        }
    }

    private var slotRow: some View {
        HStack(spacing: 10) {
            ForEach(model.slots()) { slot in
                Text(slot.character)
                    .font(.baloo(32))
                    .foregroundStyle(slot.text)
                    .frame(width: 52, height: 64)
                    .background(slot.fill, in: RoundedRectangle(cornerRadius: 14))
                    .overlay(RoundedRectangle(cornerRadius: 14).strokeBorder(slot.border, lineWidth: 2.5))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .strokeBorder(Bae.honeyBright.opacity(slot.isCurrent ? 0.35 : 0), lineWidth: 3)
                    )
            }
        }
        .padding(.vertical, 18)
    }

    private var keyboard: some View {
        VStack(spacing: 8) {
            ForEach(Array(model.keyRows.enumerated()), id: \.offset) { _, row in
                HStack(spacing: 7) {
                    ForEach(Array(row.enumerated()), id: \.offset) { _, letter in
                        Button {
                            model.tap(letter)
                        } label: {
                            Text(String(letter).uppercased())
                                .font(.baloo(21))
                                .foregroundStyle(Bae.ink)
                                .frame(maxWidth: 54)
                                .frame(height: 56)
                                .frame(maxWidth: .infinity)
                                .background(Color.white, in: RoundedRectangle(cornerRadius: 11))
                                .shadow(color: Bae.keyShadow, radius: 0, y: 2)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }

            HStack(spacing: 10) {
                Button(action: model.backspace) {
                    Text("⌫ Delete")
                        .font(.baloo(15))
                        .foregroundStyle(Color(hex: 0x7A5A20))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 13)
                        .background(Color.white, in: RoundedRectangle(cornerRadius: 14))
                        .overlay(RoundedRectangle(cornerRadius: 14).strokeBorder(Color(hex: 0xE7D6B4), lineWidth: 1.5))
                }
                .buttonStyle(.plain)

                Button(action: model.check) {
                    Text("Check Answer")
                        .font(.baloo(19))
                        .foregroundStyle(model.canCheck ? Bae.ink : Color(hex: 0xB8A587))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 13)
                        .background(model.canCheck ? Bae.action : Bae.combEmpty,
                                    in: RoundedRectangle(cornerRadius: 14))
                        .shadow(color: model.canCheck ? Bae.honeyDeep : .clear, radius: 0, y: 5)
                }
                .buttonStyle(.plain)
                .frame(maxWidth: .infinity)
                .layoutPriority(1)
            }
            .padding(.top, 12)
        }
    }

    // MARK: - Success overlay

    private var successOverlay: some View {
        ZStack {
            Color(hex: 0x2B2018).opacity(0.35).ignoresSafeArea()

            VStack(spacing: 0) {
                BaeMascotView(mood: .cheer, size: 130)
                Text("Bee-lievable! 🎉")
                    .font(.baloo(28))
                    .foregroundStyle(Bae.correctInk)
                    .padding(.top, 6)
                Text("✓ \(model.currentWord.uppercased())")
                    .font(.baloo(24))
                    .tracking(2)
                    .foregroundStyle(Bae.ink)
                    .padding(.vertical, 5)
                    .padding(.horizontal, 22)
                    .background(Bae.correctFill, in: RoundedRectangle(cornerRadius: 14))
                    .padding(.top, 10)

                HStack(spacing: 28) {
                    VStack(spacing: 2) {
                        Text("⭐⭐⭐").font(.system(size: 26))
                        Text("stars").font(.nunito(12)).foregroundStyle(Bae.inkMuted)
                    }
                    VStack(spacing: 2) {
                        Text("+15 🍯").font(.baloo(24)).foregroundStyle(Bae.honey)
                        Text("honey").font(.nunito(12)).foregroundStyle(Bae.inkMuted)
                    }
                }
                .padding(.top, 16)

                Button(action: model.nextWord) {
                    Text("Continue →")
                        .font(.baloo(19))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                        .background(Bae.correctButton, in: RoundedRectangle(cornerRadius: 16))
                        .shadow(color: Bae.correctButtonShadow, radius: 0, y: 6)
                }
                .buttonStyle(.plain)
                .padding(.top, 18)
            }
            .padding(28)
            .frame(width: 440)
            .background(
                LinearGradient(colors: [Color(hex: 0xEEFBEA), .white],
                               startPoint: .top, endPoint: .bottom),
                in: RoundedRectangle(cornerRadius: 28)
            )
            .transition(.move(edge: .bottom).combined(with: .opacity))
        }
        .animation(.spring(response: 0.35, dampingFraction: 0.8), value: model.answer)
    }
}

/// Expanding, fading ring behind the audio button.
private struct PulseRingModifier: ViewModifier {
    @State private var animate = false
    func body(content: Content) -> some View {
        content
            .scaleEffect(animate ? 2.1 : 0.9)
            .opacity(animate ? 0 : 0.7)
            .animation(.easeOut(duration: 1).repeatForever(autoreverses: false), value: animate)
            .onAppear { animate = true }
    }
}
