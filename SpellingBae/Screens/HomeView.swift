//
//  HomeView.swift
//  SpellingBae
//
//  The Home dashboard: greeting, hero, rewards, quick actions, practice modes.
//

import SwiftUI

struct HomeView: View {
    @Bindable var model: AppShellViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                header
                heroRow
                quickActions
                practiceModes
            }
            .padding(.horizontal, 30)
            .padding(.top, 26)
            .padding(.bottom, 40)
        }
        .background(Bae.panel)
    }

    // MARK: - Header

    private var header: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 2) {
                Text("Welcome back!")
                    .font(.nunito(15))
                    .foregroundStyle(Bae.inkSoft)
                Text("Hi, Mia 🐝")
                    .font(.baloo(32))
                    .foregroundStyle(Bae.ink)
            }
            Spacer()
            HStack(spacing: 9) {
                statPill(text: "\(model.honey)", tint: Bae.honey,
                         fill: Bae.pill, stroke: Bae.pillBorder, showHex: true)
                statPill(text: "🔥\(model.streak)", tint: Bae.streak,
                         fill: Bae.coralTint, stroke: Bae.coralBorder, showHex: false)
            }
        }
    }

    private func statPill(text: String, tint: Color, fill: Color, stroke: Color, showHex: Bool) -> some View {
        HStack(spacing: showHex ? 6 : 5) {
            if showHex { HexBadge(size: 15) }
            Text(text)
        }
        .font(.baloo(16))
        .foregroundStyle(tint)
        .padding(.vertical, 9)
        .padding(.horizontal, 16)
        .background(fill, in: Capsule())
        .overlay(Capsule().strokeBorder(stroke, lineWidth: 1.5))
    }

    // MARK: - Hero + reward

    private var heroRow: some View {
        HStack(spacing: 18) {
            heroCard.frame(maxWidth: .infinity)
            rewardCard.frame(width: 320)
        }
    }

    private var heroCard: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 0) {
                Text("Ready to practise?")
                    .font(.baloo(26))
                    .foregroundStyle(Bae.inkStrong)
                    .fixedSize(horizontal: false, vertical: true)
                Text("Intermediate · 2 new words waiting")
                    .font(.nunito(15))
                    .foregroundStyle(Color(hex: 0x7A4B00))
                    .padding(.top, 6)
                Button(action: model.startSession) {
                    Text("▶ Start Practice")
                        .font(.baloo(17))
                        .foregroundStyle(Color(hex: 0xFFE9B8))
                        .padding(.vertical, 13)
                        .padding(.horizontal, 24)
                        .background(Bae.inkStrong, in: RoundedRectangle(cornerRadius: 16))
                }
                .buttonStyle(.plain)
                .padding(.top, 16)
            }
            Spacer(minLength: 0)
            BaeMascotView(mood: .happy, size: 120)
                .modifier(BobbingModifier())
        }
        .padding(26)
        .background(
            LinearGradient(colors: [Bae.honeyLight, Bae.amber],
                           startPoint: .topLeading, endPoint: .bottomTrailing),
            in: RoundedRectangle(cornerRadius: 28)
        )
        .shadow(color: Bae.honeyDeep.opacity(0.28), radius: 15, y: 14)
    }

    private var rewardCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("Next reward").font(.baloo(16)).foregroundStyle(Bae.ink)
                Spacer()
                Text("160 / 400 🍯").font(.nunito(14)).foregroundStyle(Bae.honey)
            }
            .padding(.bottom, 12)

            HStack(spacing: 5) {
                ForEach(0..<8, id: \.self) { i in
                    HexagonShape()
                        .fill(combColor(i))
                        .frame(height: 26)
                        .frame(maxWidth: .infinity)
                }
            }

            Text("🎩 Unlock: Explorer Hat for Bae")
                .font(.nunito(13))
                .foregroundStyle(Bae.inkMuted)
                .padding(.top, 10)
        }
        .padding(20)
        .background(Color.white, in: RoundedRectangle(cornerRadius: 24))
        .overlay(RoundedRectangle(cornerRadius: 24).strokeBorder(Bae.cardBorder, lineWidth: 1))
        .shadow(color: Color(hex: 0xA07828).opacity(0.10), radius: 9, y: 8)
    }

    private func combColor(_ i: Int) -> Color {
        if i < 3 { return Bae.honeyBright }
        if i == 3 { return Bae.honeyLight }
        return Bae.combEmpty
    }

    // MARK: - Quick actions

    private var quickActions: some View {
        HStack(spacing: 16) {
            Button(action: model.startSession) {
                actionCard(emoji: "🎯", title: "Daily Challenge", titleColor: Bae.blueInk,
                           subtitle: "3 / 5 words · +50 🍯", subtitleColor: Bae.blueSoft,
                           fill: Bae.blueTint, stroke: Bae.blueBorder)
            }
            .buttonStyle(.plain)

            Button(action: model.startSession) {
                actionCard(emoji: "🔁", title: "Mistake Review", titleColor: Bae.streak,
                           subtitle: "4 words to practise", subtitleColor: Bae.coralSoft,
                           fill: Bae.coralTint, stroke: Bae.coralBorder)
            }
            .buttonStyle(.plain)

            hiveCard
        }
    }

    private func actionCard(emoji: String, title: String, titleColor: Color,
                            subtitle: String, subtitleColor: Color,
                            fill: Color, stroke: Color) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(emoji).font(.system(size: 30))
            Text(title).font(.baloo(17)).foregroundStyle(titleColor).padding(.top, 6)
            Text(subtitle).font(.nunito(13)).foregroundStyle(subtitleColor)
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(fill, in: RoundedRectangle(cornerRadius: 22))
        .overlay(RoundedRectangle(cornerRadius: 22).strokeBorder(stroke, lineWidth: 1.5))
    }

    private var hiveCard: some View {
        HStack(spacing: 12) {
            Text("🍯")
                .font(.system(size: 26))
                .frame(width: 52, height: 52)
                .background(Color(hex: 0xFFE7AE), in: RoundedRectangle(cornerRadius: 15))
            VStack(alignment: .leading, spacing: 0) {
                Text("Your Hive").font(.baloo(16)).foregroundStyle(Bae.ink)
                Text("12 words collected").font(.nunito(12.5)).foregroundStyle(Bae.inkMuted)
            }
            Spacer(minLength: 0)
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            LinearGradient(colors: [Color(hex: 0xFFF6E0), Color(hex: 0xFDEFC8)],
                           startPoint: .topLeading, endPoint: .bottomTrailing),
            in: RoundedRectangle(cornerRadius: 22)
        )
        .overlay(RoundedRectangle(cornerRadius: 22).strokeBorder(Bae.cardBorder, lineWidth: 1))
    }

    // MARK: - Practice modes

    private struct Mode: Identifiable {
        let id = UUID()
        let name, emoji, desc: String
        let tint, border: Color
    }

    private let modes: [Mode] = [
        .init(name: "Listen & Spell", emoji: "🎧", desc: "Hear it, then type the letters.",
              tint: Color(hex: 0xFFF1D6), border: Color(hex: 0xF2D89A)),
        .init(name: "Spell Aloud", emoji: "🗣️", desc: "Say each letter out loud.",
              tint: Color(hex: 0xEAF6FF), border: Color(hex: 0xC6E4F5)),
        .init(name: "Say the Word", emoji: "🎤", desc: "Listen, then say the whole word.",
              tint: Color(hex: 0xFDECE4), border: Color(hex: 0xF5C3B4)),
        .init(name: "Mixed Practice", emoji: "🌟", desc: "A fun mix — 5 words.",
              tint: Color(hex: 0xE9F7E5), border: Color(hex: 0xBBE3AE)),
    ]

    private var practiceModes: some View {
        let columns = [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)]
        return LazyVGrid(columns: columns, spacing: 16) {
            ForEach(modes) { mode in
                Button(action: model.startSession) {
                    modeRow(mode)
                }
                .buttonStyle(.plain)
            }
        }
    }

    private func modeRow(_ mode: Mode) -> some View {
        HStack(spacing: 14) {
            Text(mode.emoji)
                .font(.system(size: 26))
                .frame(width: 54, height: 54)
                .background(mode.tint, in: RoundedRectangle(cornerRadius: 16))
            VStack(alignment: .leading, spacing: 0) {
                Text(mode.name).font(.baloo(17)).foregroundStyle(Bae.ink)
                Text(mode.desc).font(.nunito(13, .semibold)).foregroundStyle(Bae.inkMuted)
            }
            Spacer(minLength: 0)
            Text("›").font(.baloo(22)).foregroundStyle(Bae.honey)
        }
        .padding(16)
        .background(Color.white, in: RoundedRectangle(cornerRadius: 20))
        .overlay(RoundedRectangle(cornerRadius: 20).strokeBorder(mode.border, lineWidth: 2))
        .shadow(color: Color(hex: 0xA07828).opacity(0.08), radius: 8, y: 8)
    }
}

/// Gentle up-and-down float for the mascot.
private struct BobbingModifier: ViewModifier {
    @State private var up = false
    func body(content: Content) -> some View {
        content
            .offset(y: up ? -9 : 0)
            .animation(.easeInOut(duration: 1.3).repeatForever(autoreverses: true), value: up)
            .onAppear { up = true }
    }
}
