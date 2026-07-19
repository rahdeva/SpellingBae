//
//  PhoneOnboardingFlow.swift
//  SpellingBae
//
//  Splash, onboarding carousel, and level selection.
//

import SwiftUI

// MARK: - Splash

struct SplashView: View {
    @Bindable var model: PhoneViewModel
    @State private var flash = false

    var body: some View {
        ZStack {
            RadialGradient(
                colors: [Bae.honeyLight, Bae.amber, Bae.honeyBright],
                center: UnitPoint(x: 0.5, y: 0.34),
                startRadius: 10, endRadius: 460
            )
            .ignoresSafeArea()

            DottedPattern(dot: Color.white.opacity(0.16), spacing: 26, radius: 2)
                .opacity(0.5)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                BaeMascotView(mood: .wave, size: 180)
                    .bobbing()
                    .shadow(color: Color(hex: 0x784600).opacity(0.28), radius: 12, y: 14)

                Text("SpellingBae")
                    .font(.baloo(46))
                    .foregroundStyle(.white)
                    .shadow(color: Color(hex: 0x965800).opacity(0.35), radius: 0, y: 4)

                Text("English Spelling")
                    .font(.baloo(19, .bold))
                    .foregroundStyle(Color(hex: 0x7A4B00))
                    .padding(.vertical, 6).padding(.horizontal, 18)
                    .background(Color(hex: 0xFFE9B8), in: Capsule())

                HStack(spacing: 9) {
                    ForEach(0..<3, id: \.self) { i in
                        Circle().fill(.white)
                            .frame(width: 11, height: 11)
                            .opacity(flash ? 1 : 0.25)
                            .animation(.easeInOut(duration: 1.2).repeatForever().delay(Double(i) * 0.2), value: flash)
                    }
                }
                .padding(.top, 12)
            }

            VStack {
                Spacer()
                Text("Tap to start · Your Spelling Bestie")
                    .font(.nunito(14))
                    .foregroundStyle(Color(hex: 0x8A5600))
                    .padding(.bottom, 40)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture { model.toOnboard() }
        .onAppear { flash = true }
    }
}

/// Repeating dot texture used on splash / hive backgrounds.
struct DottedPattern: View {
    var dot: Color
    var spacing: CGFloat
    var radius: CGFloat

    var body: some View {
        Canvas { context, size in
            var y: CGFloat = 0
            while y < size.height {
                var x: CGFloat = 0
                while x < size.width {
                    let rect = CGRect(x: x, y: y, width: radius * 2, height: radius * 2)
                    context.fill(Path(ellipseIn: rect), with: .color(dot))
                    x += spacing
                }
                y += spacing
            }
        }
    }
}

// MARK: - Onboarding

struct OnboardingView: View {
    @Bindable var model: PhoneViewModel

    var body: some View {
        let page = PhoneViewModel.onboarding[model.onboardPage]
        VStack(spacing: 0) {
            HStack {
                Spacer()
                Button(action: model.finishOnboard) {
                    Text("Skip").font(.baloo(16, .bold)).foregroundStyle(Bae.honey)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 22)
            .padding(.vertical, 10)

            Spacer()

            VStack(spacing: 22) {
                ZStack {
                    Circle()
                        .fill(Color(hex: 0xFFE7AE))
                        .frame(width: 210, height: 210)
                        .overlay(Circle().strokeBorder(Color.white.opacity(0.5), lineWidth: 10))
                    BaeMascotView(mood: page.mood, size: 140).bobbing()
                }

                VStack(spacing: 10) {
                    Text(page.title).font(.baloo(27)).foregroundStyle(Bae.ink)
                    Text(page.body)
                        .font(.nunito(17, .semibold))
                        .foregroundStyle(Bae.inkMuted)
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                }
                .id(model.onboardPage)
                .transition(.move(edge: .trailing).combined(with: .opacity))
                .padding(.horizontal, 34)
            }
            .animation(.easeOut(duration: 0.35), value: model.onboardPage)

            Spacer()

            VStack(spacing: 22) {
                HStack(spacing: 9) {
                    ForEach(0..<PhoneViewModel.onboarding.count, id: \.self) { i in
                        Capsule()
                            .fill(i == model.onboardPage ? Bae.action : Bae.combEmpty)
                            .frame(width: i == model.onboardPage ? 26 : 9, height: 9)
                            .animation(.easeInOut(duration: 0.3), value: model.onboardPage)
                    }
                }
                HoneyButton(
                    title: model.onboardPage >= PhoneViewModel.onboarding.count - 1 ? "Get Started" : "Next",
                    action: model.nextOnboard
                )
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 40)
        }
        .background(
            LinearGradient(colors: [Bae.sidebarTop, Bae.panel], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
        )
    }
}

// MARK: - Level select

struct LevelSelectView: View {
    @Bindable var model: PhoneViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                VStack(spacing: 6) {
                    BaeMascotView(mood: .think, size: 92)
                    Text("Pick your level").font(.baloo(26)).foregroundStyle(Bae.ink)
                    Text("Don't worry — Bae will adjust as you learn!")
                        .font(.nunito(15, .semibold)).foregroundStyle(Bae.inkMuted)
                        .multilineTextAlignment(.center)
                }
                .padding(.bottom, 20)

                VStack(spacing: 14) {
                    ForEach(PhoneViewModel.levels) { level in
                        Button {
                            model.pickLevel(level.id)
                        } label: {
                            levelCard(level)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(.horizontal, 22)
            .padding(.top, 8)
            .padding(.bottom, 26)
        }
        .scrollIndicators(.hidden)
    }

    private func levelCard(_ level: LevelOption) -> some View {
        HStack(spacing: 14) {
            Text(level.emoji)
                .font(.system(size: 28))
                .frame(width: 54, height: 54)
                .background(level.tint, in: RoundedRectangle(cornerRadius: 16))
            VStack(alignment: .leading, spacing: 3) {
                Text(level.name).font(.baloo(19)).foregroundStyle(Bae.ink)
                Text(level.desc)
                    .font(.nunito(13.5, .semibold)).foregroundStyle(Bae.inkMuted)
                    .fixedSize(horizontal: false, vertical: true)
                Text("e.g. \(level.examples)").font(.nunito(12, .heavy)).foregroundStyle(Bae.honey)
            }
            Spacer(minLength: 0)
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white, in: RoundedRectangle(cornerRadius: 22))
        .overlay(RoundedRectangle(cornerRadius: 22).strokeBorder(level.border, lineWidth: 2.5))
        .shadow(color: Color(hex: 0xA07828).opacity(0.10), radius: 9, y: 8)
    }
}
