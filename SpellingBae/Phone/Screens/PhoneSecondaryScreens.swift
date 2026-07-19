//
//  PhoneSecondaryScreens.swift
//  SpellingBae
//
//  Daily Challenge, Mistake Review, Progress, Badges, Hive, Settings.
//

import SwiftUI

// MARK: - Daily Challenge

struct DailyChallengeView: View {
    @Bindable var model: PhoneViewModel

    private struct WeekItem: Identifiable {
        let id = UUID()
        let icon, name, reward, mark: String
        let tint, markColor: Color
        let opacity: Double
    }
    private let week: [WeekItem] = [
        .init(icon: "🗣️", name: "Complete one Spell Aloud", reward: "+30 🍯", mark: "✓",
              tint: Bae.blueTint, markColor: Bae.correctButton, opacity: 1),
        .init(icon: "🔁", name: "Review three tricky words", reward: "+40 🍯 + badge", mark: "2/3",
              tint: Bae.coralTint, markColor: Bae.honey, opacity: 1),
        .init(icon: "⭐", name: "Earn three stars", reward: "+25 🍯", mark: "○",
              tint: Color(hex: 0xFFF6E0), markColor: Bae.keyShadow, opacity: 0.6),
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                BackHeader(title: "Daily Challenge") { model.go(.home) }
                    .padding(.bottom, 12)

                VStack(spacing: 0) {
                    Text("🎯").font(.system(size: 38))
                    Text("Spell 5 words correctly").font(.baloo(22)).foregroundStyle(.white).padding(.top, 4)
                    Text("Today's task from Bae").font(.nunito(14)).foregroundStyle(.white.opacity(0.9))
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            Capsule().fill(.white.opacity(0.25))
                            Capsule().fill(.white).frame(width: geo.size.width * 0.6)
                        }
                    }
                    .frame(height: 14).padding(.top, 16)
                    Text("3 of 5 done · +50 🍯 + a new flower 🌼")
                        .font(.baloo(14)).foregroundStyle(.white).padding(.top, 8)
                }
                .padding(20)
                .frame(maxWidth: .infinity)
                .background(
                    LinearGradient(colors: [Bae.blueLight, Bae.blueDeep], startPoint: .topLeading, endPoint: .bottomTrailing),
                    in: RoundedRectangle(cornerRadius: 26)
                )
                .overlay(alignment: .topTrailing) {
                    BaeMascotView(mood: .happy, size: 64).padding(10)
                }
                .shadow(color: Bae.blueDeep.opacity(0.3), radius: 13, y: 12)

                HoneyButton(title: "▶ Start Challenge", action: model.startMixedPractice)
                    .padding(.top, 16)

                Text("More this week").font(.baloo(16)).foregroundStyle(Bae.ink)
                    .padding(.top, 20).padding(.bottom, 10)

                VStack(spacing: 10) {
                    ForEach(week) { item in
                        HStack(spacing: 12) {
                            Text(item.icon).font(.system(size: 20))
                                .frame(width: 40, height: 40)
                                .background(item.tint, in: RoundedRectangle(cornerRadius: 12))
                            VStack(alignment: .leading, spacing: 1) {
                                Text(item.name).font(.baloo(14)).foregroundStyle(Bae.ink)
                                Text(item.reward).font(.nunito(12)).foregroundStyle(Bae.inkMuted)
                            }
                            Spacer(minLength: 0)
                            Text(item.mark).font(.baloo(20)).foregroundStyle(item.markColor)
                        }
                        .padding(13)
                        .background(Color.white, in: RoundedRectangle(cornerRadius: 16))
                        .overlay(RoundedRectangle(cornerRadius: 16).strokeBorder(Bae.cardBorder, lineWidth: 1))
                        .opacity(item.opacity)
                    }
                }

                Text("Missed a day? No worries — your progress is always safe. 💛")
                    .font(.nunito(12.5)).foregroundStyle(Bae.inkSoft)
                    .frame(maxWidth: .infinity).multilineTextAlignment(.center)
                    .padding(.top, 16)
            }
            .padding(.horizontal, 22).padding(.top, 8).padding(.bottom, 30)
        }
        .scrollIndicators(.hidden)
    }
}

// MARK: - Mistake Review

struct MistakeReviewView: View {
    @Bindable var model: PhoneViewModel

    private struct Mistake: Identifiable {
        let id = UUID()
        let emoji, word, cat, last, chip: String
        let miss: Int
        let chipColor, chipFill: Color
    }
    private let words: [Mistake] = [
        .init(emoji: "🏫", word: "school", cat: "Places", last: "today", chip: "Needs Review", miss: 3,
              chipColor: Bae.streak, chipFill: Bae.coralTint),
        .init(emoji: "💛", word: "because", cat: "Common", last: "yesterday", chip: "Practising", miss: 2,
              chipColor: Bae.honey, chipFill: Bae.pill),
        .init(emoji: "🌈", word: "colour", cat: "Colors", last: "2 days ago", chip: "Learning", miss: 2,
              chipColor: Bae.blueInk, chipFill: Bae.blueTint),
        .init(emoji: "🐍", word: "friend", cat: "People", last: "3 days ago", chip: "Practising", miss: 1,
              chipColor: Bae.honey, chipFill: Bae.pill),
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                BackHeader(title: "Mistake Review") { model.go(.home) }
                    .padding(.bottom, 8)

                HStack(spacing: 10) {
                    BaeMascotView(mood: .happy, size: 44)
                    Text("Reviewing tricky words is how we get stronger. Let's practise together!")
                        .font(.nunito(13)).foregroundStyle(Color(hex: 0x8A6A2E))
                }
                .padding(12)
                .background(Color(hex: 0xFFF6E0), in: RoundedRectangle(cornerRadius: 16))
                .overlay(RoundedRectangle(cornerRadius: 16).strokeBorder(Color(hex: 0xF2C86A), lineWidth: 1))

                HStack(spacing: 8) {
                    filterChip("All (4)", active: true)
                    filterChip("Nature", active: false)
                    filterChip("Places", active: false)
                }
                .padding(.vertical, 14)

                VStack(spacing: 10) {
                    ForEach(words) { m in
                        HStack(spacing: 12) {
                            Text(m.emoji).font(.system(size: 22))
                                .frame(width: 44, height: 44)
                                .background(Bae.coralTint, in: RoundedRectangle(cornerRadius: 12))
                            VStack(alignment: .leading, spacing: 1) {
                                Text(m.word).font(.baloo(16)).foregroundStyle(Bae.ink)
                                Text("\(m.cat) · last tried \(m.last)")
                                    .font(.nunito(11.5)).foregroundStyle(Bae.inkSoft)
                            }
                            Spacer(minLength: 0)
                            VStack(alignment: .trailing, spacing: 4) {
                                Text(m.chip).font(.baloo(11, .bold)).foregroundStyle(m.chipColor)
                                    .padding(.vertical, 3).padding(.horizontal, 9)
                                    .background(m.chipFill, in: Capsule())
                                Text("missed \(m.miss)×").font(.nunito(11)).foregroundStyle(Bae.streak)
                            }
                        }
                        .padding(13)
                        .background(Color.white, in: RoundedRectangle(cornerRadius: 16))
                        .overlay(RoundedRectangle(cornerRadius: 16).strokeBorder(Bae.cardBorder, lineWidth: 1))
                    }
                }

                HoneyButton(title: "▶ Start Review", action: model.startMixedPractice)
                    .padding(.top, 16)
            }
            .padding(.horizontal, 22).padding(.top, 8).padding(.bottom, 30)
        }
        .scrollIndicators(.hidden)
    }

    private func filterChip(_ text: String, active: Bool) -> some View {
        Text(text).font(.baloo(12.5, .bold))
            .foregroundStyle(active ? .white : Bae.inkSoft)
            .padding(.vertical, 6).padding(.horizontal, 13)
            .background(active ? Bae.honeyBright : Color(hex: 0xF6ECD5), in: Capsule())
    }
}

// MARK: - Progress

struct PhoneProgressView: View {
    @Bindable var model: PhoneViewModel

    private let statTiles: [(String, String, Color)] = [
        ("64", "Words learned", Bae.ink), ("38", "Mastered", Bae.correctInk),
        ("4", "Needs review", Bae.streak), ("86%", "Accuracy", Bae.honey),
        ("24", "Sessions", Bae.blueInk), ("340", "Honey 🍯", Bae.honey),
    ]
    private let masteryColors = [Color(hex: 0xF0DBAE), Color(hex: 0xBBE3AE), Color(hex: 0x8FD08A), Bae.honeyBright, Color(hex: 0xF0A48C)]
    private let legend: [(String, Color)] = [
        ("New", Color(hex: 0xF0DBAE)), ("Learning", Color(hex: 0xBBE3AE)), ("Practising", Color(hex: 0x8FD08A)),
        ("Mastered", Bae.honeyBright), ("Needs Review", Color(hex: 0xF0A48C)),
    ]
    private let catBars: [(String, String, String, Double, Color)] = [
        ("🐶", "Animals", "14/16", 0.88, Bae.honeyBright), ("🏫", "School", "9/14", 0.64, Bae.amber),
        ("🌻", "Nature", "11/12", 0.92, Bae.correctButton), ("🍞", "Food", "6/13", 0.46, Bae.micCoral),
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                Text("Your Progress").font(.baloo(24)).foregroundStyle(Bae.ink).padding(.bottom, 12)

                HStack(spacing: 14) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Spelling accuracy").font(.nunito(13)).foregroundStyle(Color(hex: 0x7A4B00))
                        Text("86%").font(.baloo(34)).foregroundStyle(Bae.inkStrong)
                        Text("across 24 sessions").font(.nunito(12)).foregroundStyle(Color(hex: 0x7A4B00))
                    }
                    Spacer(minLength: 0)
                    BaeMascotView(mood: .cheer, size: 80)
                }
                .padding(16)
                .background(
                    LinearGradient(colors: [Bae.honeyLight, Bae.amber], startPoint: .topLeading, endPoint: .bottomTrailing),
                    in: RoundedRectangle(cornerRadius: 22)
                )
                .shadow(color: Bae.honeyDeep.opacity(0.25), radius: 11, y: 10)

                let cols = Array(repeating: GridItem(.flexible(), spacing: 10), count: 3)
                LazyVGrid(columns: cols, spacing: 10) {
                    ForEach(Array(statTiles.enumerated()), id: \.offset) { _, tile in
                        VStack(spacing: 2) {
                            Text(tile.0).font(.baloo(22)).foregroundStyle(tile.2)
                            Text(tile.1).font(.nunito(11)).foregroundStyle(Bae.inkMuted)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(12)
                        .background(Color.white, in: RoundedRectangle(cornerRadius: 16))
                        .overlay(RoundedRectangle(cornerRadius: 16).strokeBorder(Bae.cardBorder, lineWidth: 1))
                    }
                }
                .padding(.top, 12)

                SoftCard {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Words collected 🍯").font(.baloo(15)).foregroundStyle(Bae.ink).padding(.bottom, 12)
                        let gridCols = Array(repeating: GridItem(.flexible(), spacing: 5), count: 8)
                        LazyVGrid(columns: gridCols, spacing: 5) {
                            ForEach(0..<24, id: \.self) { i in
                                HexagonShape().fill(masteryColors[i % 5]).frame(height: 30)
                            }
                        }
                        FlowLegend(legend: legend).padding(.top, 12)
                    }
                }
                .padding(.top, 14)

                SoftCard {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("By category").font(.baloo(15)).foregroundStyle(Bae.ink)
                        ForEach(Array(catBars.enumerated()), id: \.offset) { _, bar in
                            VStack(alignment: .leading, spacing: 5) {
                                HStack {
                                    Text("\(bar.0) \(bar.1)").font(.nunito(13, .bold)).foregroundStyle(Bae.inkMuted)
                                    Spacer()
                                    Text(bar.2).font(.nunito(13, .bold)).foregroundStyle(Bae.inkMuted)
                                }
                                GeometryReader { geo in
                                    ZStack(alignment: .leading) {
                                        Capsule().fill(Color(hex: 0xF2E4C6))
                                        Capsule().fill(bar.4).frame(width: geo.size.width * bar.3)
                                    }
                                }
                                .frame(height: 11)
                            }
                        }
                    }
                }
                .padding(.top, 14)

                Button { model.go(.badges) } label: {
                    Text("🏅 See all badges & levels").font(.baloo(16, .bold)).foregroundStyle(Bae.honey)
                        .frame(maxWidth: .infinity).padding(.vertical, 14)
                        .background(Bae.pill, in: RoundedRectangle(cornerRadius: 16))
                        .overlay(RoundedRectangle(cornerRadius: 16).strokeBorder(Bae.pillBorder, lineWidth: 2))
                }
                .buttonStyle(.plain)
                .padding(.top, 14)
            }
            .padding(.horizontal, 20).padding(.top, 8).padding(.bottom, 100)
        }
        .scrollIndicators(.hidden)
    }
}

/// Wrapping legend row for the mastery colours.
private struct FlowLegend: View {
    let legend: [(String, Color)]
    var body: some View {
        HStack(spacing: 14) {
            ForEach(Array(legend.enumerated()), id: \.offset) { _, item in
                HStack(spacing: 5) {
                    RoundedRectangle(cornerRadius: 3).fill(item.1).frame(width: 12, height: 12)
                    Text(item.0).font(.nunito(11)).foregroundStyle(Bae.inkMuted)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .fixedSize(horizontal: false, vertical: true)
    }
}

// MARK: - Badges

struct BadgesView: View {
    @Bindable var model: PhoneViewModel

    private let ladder: [(String, String, Double)] = [
        ("🌱", "Tiny Words", 0.5), ("🐝", "Busy Bee", 1), ("🔍", "Word Explorer", 0.4),
        ("⭐", "Spelling Star", 0.4), ("👑", "Hive Champion", 0.4),
    ]
    private struct Badge: Identifiable {
        let id = UUID()
        let icon, name, desc: String
        let unlocked: Bool
    }
    private let badges: [Badge] = [
        .init(icon: "🪶", name: "First Flight", desc: "Finished your first practice", unlocked: true),
        .init(icon: "🏅", name: "Perfect Speller", desc: "10 words right in a row", unlocked: true),
        .init(icon: "🎤", name: "Brave Speaker", desc: "Finished a voice mode", unlocked: true),
        .init(icon: "🍯", name: "Nectar Collector", desc: "Collect 500 honey", unlocked: false),
        .init(icon: "📚", name: "Word Master", desc: "Master a word group", unlocked: false),
        .init(icon: "🌞", name: "Daily Helper", desc: "5 daily challenges", unlocked: false),
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                BackHeader(title: "Badges & Levels") { model.go(.progress) }
                    .padding(.bottom, 12)

                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Text("🐝 Busy Bee").font(.baloo(17)).foregroundStyle(Bae.ink)
                        Spacer()
                        Text("Next: Word Explorer").font(.nunito(12)).foregroundStyle(Bae.honey)
                    }
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            Capsule().fill(Color(hex: 0xF2E4C6))
                            Capsule().fill(LinearGradient(colors: [Bae.honeyLight, Bae.honeyBright], startPoint: .leading, endPoint: .trailing))
                                .frame(width: geo.size.width * 0.45)
                        }
                    }
                    .frame(height: 12).padding(.top, 10)
                    HStack(alignment: .top) {
                        ForEach(Array(ladder.enumerated()), id: \.offset) { _, step in
                            VStack(spacing: 2) {
                                Text(step.0).font(.system(size: 18))
                                Text(step.1).font(.nunito(9, .heavy)).foregroundStyle(Bae.inkMuted)
                                    .multilineTextAlignment(.center)
                            }
                            .frame(maxWidth: .infinity)
                            .opacity(step.2)
                        }
                    }
                    .padding(.top, 10)
                }
                .padding(16)
                .background(
                    LinearGradient(colors: [Color(hex: 0xFFF6E0), Color(hex: 0xFDEFC8)], startPoint: .topLeading, endPoint: .bottomTrailing),
                    in: RoundedRectangle(cornerRadius: 20)
                )
                .overlay(RoundedRectangle(cornerRadius: 20).strokeBorder(Bae.cardBorder, lineWidth: 1))

                Text("Badge collection").font(.baloo(16)).foregroundStyle(Bae.ink)
                    .padding(.top, 18).padding(.bottom, 10)

                let cols = [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)]
                LazyVGrid(columns: cols, spacing: 12) {
                    ForEach(badges) { badge in
                        VStack(spacing: 0) {
                            HexagonShape()
                                .fill(badge.unlocked ? Color(hex: 0xFFD05B) : Color(hex: 0xDCCEAF))
                                .frame(width: 56, height: 60)
                                .overlay(Text(badge.icon).font(.system(size: 26)))
                                .saturation(badge.unlocked ? 1 : 0.3)
                            Text(badge.name).font(.baloo(13.5)).foregroundStyle(Bae.ink).padding(.top, 8)
                            Text(badge.desc).font(.nunito(11)).foregroundStyle(Bae.inkMuted)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(14)
                        .background(badge.unlocked ? Color(hex: 0xFFF6E0) : Color(hex: 0xF6F0E2), in: RoundedRectangle(cornerRadius: 18))
                        .overlay(RoundedRectangle(cornerRadius: 18).strokeBorder(badge.unlocked ? Color(hex: 0xF2C86A) : Color(hex: 0xE6D9BE), lineWidth: 1.5))
                        .opacity(badge.unlocked ? 1 : 0.55)
                    }
                }
            }
            .padding(.horizontal, 22).padding(.top, 8).padding(.bottom, 30)
        }
        .scrollIndicators(.hidden)
    }
}

// MARK: - Hive

struct HiveView: View {
    @Bindable var model: PhoneViewModel

    private let tabs = ["🎩 Hats", "🪽 Wings", "🌸 Flowers", "🍯 Decor", "🖼️ Backgrounds"]
    private struct Item: Identifiable {
        let id = UUID()
        let icon, name, tag: String
        let unlocked, equipped: Bool
    }
    private let items: [Item] = [
        .init(icon: "🎓", name: "Grad Cap", tag: "Equipped", unlocked: true, equipped: true),
        .init(icon: "🎩", name: "Top Hat", tag: "Owned", unlocked: true, equipped: false),
        .init(icon: "👑", name: "Crown", tag: "120 🍯", unlocked: false, equipped: false),
        .init(icon: "🧢", name: "Party Hat", tag: "80 🍯", unlocked: false, equipped: false),
        .init(icon: "🤠", name: "Cowboy", tag: "150 🍯", unlocked: false, equipped: false),
        .init(icon: "🌺", name: "Flower Cap", tag: "200 🍯", unlocked: false, equipped: false),
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text("Your Hive").font(.baloo(24)).foregroundStyle(Bae.ink)
                    Spacer()
                    StatPill.honey(model.honey)
                }
                .padding(.bottom, 12)

                ZStack {
                    DottedPattern(dot: .white.opacity(0.35), spacing: 34, radius: 3).opacity(0.5)
                    VStack(spacing: 6) {
                        BaeMascotView(mood: .love, size: 140).bobbing()
                        Text("Bae looks happy! 💛").font(.baloo(17)).foregroundStyle(Bae.inkStrong)
                    }
                    .padding(.vertical, 22)
                }
                .frame(maxWidth: .infinity)
                .background(
                    RadialGradient(colors: [Color(hex: 0xFFE7AE), Color(hex: 0xFFD05B)],
                                   center: UnitPoint(x: 0.5, y: 0.3), startRadius: 10, endRadius: 240),
                    in: RoundedRectangle(cornerRadius: 26)
                )
                .clipShape(RoundedRectangle(cornerRadius: 26))
                .shadow(color: Bae.honeyDeep.opacity(0.22), radius: 11, y: 10)

                ScrollView(.horizontal) {
                    HStack(spacing: 8) {
                        ForEach(Array(tabs.enumerated()), id: \.offset) { i, tab in
                            Text(tab).font(.baloo(13, .bold))
                                .foregroundStyle(i == 0 ? .white : Bae.inkSoft)
                                .padding(.vertical, 7).padding(.horizontal, 14)
                                .background(i == 0 ? Bae.honeyBright : Color(hex: 0xF6ECD5), in: Capsule())
                        }
                    }
                }
                .scrollIndicators(.hidden)
                .padding(.vertical, 14)

                let cols = Array(repeating: GridItem(.flexible(), spacing: 11), count: 3)
                LazyVGrid(columns: cols, spacing: 11) {
                    ForEach(items) { item in
                        VStack(spacing: 4) {
                            Text(item.icon).font(.system(size: 30))
                            Text(item.name).font(.baloo(12)).foregroundStyle(Bae.ink)
                            Text(item.tag).font(.nunito(11, .heavy))
                                .foregroundStyle(item.equipped ? Bae.correctInk : (item.unlocked ? Bae.honey : Bae.inkSoft))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12).padding(.horizontal, 8)
                        .background(item.equipped ? Bae.correctFill : (item.unlocked ? Color.white : Color(hex: 0xF6F0E2)), in: RoundedRectangle(cornerRadius: 16))
                        .overlay(RoundedRectangle(cornerRadius: 16).strokeBorder(item.equipped ? Bae.correctBorder : (item.unlocked ? Bae.cardBorder : Color(hex: 0xE6D9BE)), lineWidth: 1.5))
                        .opacity(item.unlocked ? 1 : 0.7)
                    }
                }
            }
            .padding(.horizontal, 20).padding(.top, 8).padding(.bottom, 100)
        }
        .scrollIndicators(.hidden)
    }
}

// MARK: - Settings

struct SettingsView: View {
    @Bindable var model: PhoneViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                Text("Settings").font(.baloo(24)).foregroundStyle(Bae.ink).padding(.bottom, 14)

                sectionLabel("Sound")
                settingsGroup {
                    toggleRow(icon: "🔊", title: "Sound effects", isOn: model.soundFx) { model.soundFx.toggle() }
                    Divider().background(Color(hex: 0xF5EAD2))
                    toggleRow(icon: "🎵", title: "Background music", isOn: model.music) { model.music.toggle() }
                }

                settingsGroup {
                    HStack(spacing: 12) {
                        Text("🐌").font(.system(size: 20))
                        Text("Pronunciation speed").font(.nunito(15, .bold)).foregroundStyle(Bae.ink)
                        Spacer(minLength: 0)
                    }
                    HStack(spacing: 8) {
                        speedTab("Normal", active: !model.speedSlow) { model.speedSlow = false }
                        speedTab("Slow", active: model.speedSlow) { model.speedSlow = true }
                    }
                    .padding(.top, 12)
                }
                .padding(.top, 12)

                sectionLabel("Voice & permissions").padding(.top, 16)
                settingsGroup {
                    HStack(spacing: 12) {
                        Text("🎤").font(.system(size: 20))
                        Text("Microphone").font(.nunito(15, .bold)).foregroundStyle(Bae.ink)
                        Spacer()
                        statusChip(model.micGranted ? "Allowed" : "Ask when needed",
                                   color: model.micGranted ? Bae.correctInk : Bae.honey,
                                   fill: model.micGranted ? Bae.correctFill : Bae.pill)
                    }
                    Divider().background(Color(hex: 0xF5EAD2))
                    HStack(spacing: 12) {
                        Text("🗣️").font(.system(size: 20))
                        Text("Speech recognition").font(.nunito(15, .bold)).foregroundStyle(Bae.ink)
                        Spacer()
                        statusChip("Ready", color: Bae.correctInk, fill: Bae.correctFill)
                    }
                }

                sectionLabel("Accessibility").padding(.top, 16)
                settingsGroup {
                    toggleRow(icon: "🎐", title: "Reduce motion", isOn: model.reduceMotion) { model.reduceMotion.toggle() }
                    Divider().background(Color(hex: 0xF5EAD2))
                    HStack(spacing: 12) {
                        Text("🔡").font(.system(size: 20))
                        Text("Larger text (Dynamic Type)").font(.nunito(15, .bold)).foregroundStyle(Bae.ink)
                        Spacer()
                        Text("System").font(.nunito(13, .bold)).foregroundStyle(Bae.inkSoft)
                    }
                }

                sectionLabel("Privacy & data").padding(.top, 16)
                settingsGroup {
                    HStack(spacing: 12) {
                        Text("🔒").font(.system(size: 20))
                        Text("Privacy: progress is saved only on this device. Voice is never recorded or stored.")
                            .font(.nunito(14, .bold)).foregroundStyle(Bae.ink)
                    }
                    Divider().background(Color(hex: 0xF5EAD2))
                    HStack(spacing: 12) {
                        Text("👪").font(.system(size: 20))
                        Text("Parent / Guardian area").font(.nunito(15, .bold)).foregroundStyle(Bae.ink)
                        Spacer()
                        statusChip("Soon", color: Bae.inkSoft, fill: Color(hex: 0xF6ECD5))
                    }
                    Divider().background(Color(hex: 0xF5EAD2))
                    Button(action: model.showErrorDemo) {
                        HStack(spacing: 12) {
                            Text("🧪").font(.system(size: 20))
                            Text("Preview error & permission states").font(.nunito(15, .bold)).foregroundStyle(Bae.ink)
                            Spacer()
                            Text("›").font(.baloo(18)).foregroundStyle(Bae.honey)
                        }
                    }
                    .buttonStyle(.plain)
                    Divider().background(Color(hex: 0xF5EAD2))
                    HStack(spacing: 12) {
                        Text("↺").font(.system(size: 20))
                        Text("Reset progress").font(.nunito(15, .bold)).foregroundStyle(Bae.streak)
                        Spacer(minLength: 0)
                    }
                }
            }
            .padding(.horizontal, 20).padding(.top, 8).padding(.bottom, 100)
        }
        .scrollIndicators(.hidden)
    }

    private func sectionLabel(_ text: String) -> some View {
        Text(text.uppercased())
            .font(.nunito(12, .heavy)).tracking(0.5).foregroundStyle(Bae.inkSoft)
            .padding(.bottom, 8)
    }

    private func settingsGroup<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        VStack(spacing: 12) { content() }
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.white, in: RoundedRectangle(cornerRadius: 18))
            .overlay(RoundedRectangle(cornerRadius: 18).strokeBorder(Bae.cardBorder, lineWidth: 1))
    }

    private func toggleRow(icon: String, title: String, isOn: Bool, action: @escaping () -> Void) -> some View {
        HStack(spacing: 12) {
            Text(icon).font(.system(size: 20))
            Text(title).font(.nunito(15, .bold)).foregroundStyle(Bae.ink)
            Spacer()
            ToggleSwitch(isOn: isOn, action: action)
        }
    }

    private func speedTab(_ title: String, active: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title).font(.baloo(13, .bold))
                .foregroundStyle(active ? Bae.ink : Bae.inkSoft)
                .frame(maxWidth: .infinity).padding(.vertical, 9)
                .background(active ? Bae.action : Color(hex: 0xF6ECD5), in: RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
    }

    private func statusChip(_ text: String, color: Color, fill: Color) -> some View {
        Text(text).font(.baloo(12, .bold)).foregroundStyle(color)
            .padding(.vertical, 4).padding(.horizontal, 11)
            .background(fill, in: Capsule())
    }
}

/// The pill toggle used in Settings.
struct ToggleSwitch: View {
    var isOn: Bool
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack(alignment: isOn ? .trailing : .leading) {
                Capsule().fill(isOn ? Bae.correctButton : Color(hex: 0xE0D2B4))
                    .frame(width: 46, height: 27)
                Circle().fill(.white).frame(width: 21, height: 21).padding(.horizontal, 3)
            }
            .animation(.easeInOut(duration: 0.2), value: isOn)
        }
        .buttonStyle(.plain)
    }
}
