//
//  PhoneHomeView.swift
//  SpellingBae
//

import SwiftUI

struct PhoneHomeView: View {
    @Bindable var model: PhoneViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                header.padding(.bottom, 14)
                hero
                rewardCard.padding(.top, 14)

                HoneyButton(title: "▶ Start Practice", action: model.startMixedPractice)
                    .padding(.top, 16)

                Button { model.go(.practice) } label: {
                    Text("↻ Continue where you left off")
                        .font(.baloo(16, .bold))
                        .foregroundStyle(Bae.honey)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 13)
                        .background(Bae.pill, in: RoundedRectangle(cornerRadius: 18))
                        .overlay(RoundedRectangle(cornerRadius: 18).strokeBorder(Bae.pillBorder, lineWidth: 2))
                }
                .buttonStyle(.plain)
                .padding(.top, 10)

                HStack(spacing: 12) {
                    quickCard(emoji: "🎯", title: "Daily Challenge", titleColor: Bae.blueInk,
                              subtitle: "3 / 5 words · +50 🍯", subtitleColor: Bae.blueSoft,
                              fill: Bae.blueTint, stroke: Bae.blueBorder) { model.go(.daily) }
                    quickCard(emoji: "🔁", title: "Mistake Review", titleColor: Bae.streak,
                              subtitle: "4 words to practise", subtitleColor: Bae.coralSoft,
                              fill: Bae.coralTint, stroke: Bae.coralBorder) { model.go(.mistakes) }
                }
                .padding(.top, 16)

                hiveCard.padding(.top, 14)
            }
            .padding(.horizontal, 20)
            .padding(.top, 6)
            .padding(.bottom, 100)
        }
        .scrollIndicators(.hidden)
    }

    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 1) {
                Text("Welcome back!").font(.nunito(13)).foregroundStyle(Bae.inkSoft)
                Text("Hi, Mia 🐝").font(.baloo(22)).foregroundStyle(Bae.ink)
            }
            Spacer()
            HStack(spacing: 8) {
                StatPill.honey(model.honey)
                StatPill.streak(model.streak)
            }
        }
    }

    private var hero: some View {
        HStack(spacing: 10) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Ready to practise?")
                    .font(.baloo(20)).foregroundStyle(Bae.inkStrong)
                Text("Level: Intermediate · 2 new words waiting")
                    .font(.nunito(13.5)).foregroundStyle(Color(hex: 0x7A4B00))
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer(minLength: 0)
            BaeMascotView(mood: .happy, size: 92).bobbing()
        }
        .padding(.leading, 20).padding(.trailing, 18).padding(.vertical, 18)
        .background(
            LinearGradient(colors: [Bae.honeyLight, Bae.amber], startPoint: .topLeading, endPoint: .bottomTrailing),
            in: RoundedRectangle(cornerRadius: 26)
        )
        .shadow(color: Bae.honeyDeep.opacity(0.28), radius: 13, y: 12)
    }

    private var rewardCard: some View {
        SoftCard(padding: 16, cornerRadius: 22) {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text("Next reward").font(.baloo(15)).foregroundStyle(Bae.ink)
                    Spacer()
                    Text("160 / 400 🍯").font(.nunito(13, .heavy)).foregroundStyle(Bae.honey)
                }
                .padding(.bottom, 10)
                HStack(spacing: 5) {
                    ForEach(0..<8, id: \.self) { i in
                        HexagonShape()
                            .fill(i < 3 ? Bae.honeyBright : (i == 3 ? Bae.honeyLight : Bae.combEmpty))
                            .frame(height: 22).frame(maxWidth: .infinity)
                    }
                }
                Text("🎩 Unlock: Explorer Hat for Bae")
                    .font(.nunito(12.5)).foregroundStyle(Bae.inkMuted).padding(.top, 8)
            }
        }
        .shadow(color: Color(hex: 0xA07828).opacity(0.10), radius: 9, y: 8)
    }

    private func quickCard(emoji: String, title: String, titleColor: Color,
                           subtitle: String, subtitleColor: Color,
                           fill: Color, stroke: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 0) {
                Text(emoji).font(.system(size: 24))
                Text(title).font(.baloo(15)).foregroundStyle(titleColor).padding(.top, 4)
                Text(subtitle).font(.nunito(12)).foregroundStyle(subtitleColor)
            }
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(fill, in: RoundedRectangle(cornerRadius: 20))
            .overlay(RoundedRectangle(cornerRadius: 20).strokeBorder(stroke, lineWidth: 1.5))
        }
        .buttonStyle(.plain)
    }

    private var hiveCard: some View {
        Button { model.go(.hive) } label: {
            HStack(spacing: 12) {
                Text("🍯").font(.system(size: 30))
                    .frame(width: 60, height: 60)
                    .background(Color(hex: 0xFFE7AE), in: RoundedRectangle(cornerRadius: 16))
                VStack(alignment: .leading, spacing: 1) {
                    Text("Your Hive").font(.baloo(16)).foregroundStyle(Bae.ink)
                    Text("12 words collected · tap to decorate")
                        .font(.nunito(12.5)).foregroundStyle(Bae.inkMuted)
                }
                Spacer(minLength: 0)
                Text("›").font(.baloo(22)).foregroundStyle(Bae.honey)
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                LinearGradient(colors: [Color(hex: 0xFFF6E0), Color(hex: 0xFDEFC8)],
                               startPoint: .topLeading, endPoint: .bottomTrailing),
                in: RoundedRectangle(cornerRadius: 22)
            )
            .overlay(RoundedRectangle(cornerRadius: 22).strokeBorder(Bae.cardBorder, lineWidth: 1))
        }
        .buttonStyle(.plain)
    }
}
