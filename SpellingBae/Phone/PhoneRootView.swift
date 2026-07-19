//
//  PhoneRootView.swift
//  SpellingBae
//
//  Top-level iPhone shell: active screen + bottom tab bar + overlays + toast.
//

import SwiftUI

struct PhoneRootView: View {
    @State private var model = PhoneViewModel()

    var body: some View {
        ZStack(alignment: .bottom) {
            Bae.panel.ignoresSafeArea()

            screen
                .transition(.opacity)

            if model.showTabs {
                BottomNav(model: model)
                    .transition(.move(edge: .bottom))
            }

            overlays

            if let toast = model.toastMessage {
                Text(toast)
                    .font(.nunito(14))
                    .foregroundStyle(Color(hex: 0xFFF3D6))
                    .padding(.vertical, 13)
                    .padding(.horizontal, 16)
                    .background(Bae.ink, in: RoundedRectangle(cornerRadius: 16))
                    .padding(.horizontal, 20)
                    .padding(.bottom, 110)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .animation(.easeInOut(duration: 0.28), value: model.screen)
        .animation(.spring(response: 0.3, dampingFraction: 0.85), value: model.overlay)
        .animation(.easeInOut(duration: 0.25), value: model.toastMessage)
    }

    @ViewBuilder
    private var screen: some View {
        switch model.screen {
        case .splash:   SplashView(model: model)
        case .onboard:  OnboardingView(model: model)
        case .level:    LevelSelectView(model: model)
        case .home:     PhoneHomeView(model: model)
        case .practice: PracticeSelectView(model: model)
        case .session:  SessionView(model: model)
        case .summary:  SummaryView(model: model)
        case .daily:    DailyChallengeView(model: model)
        case .mistakes: MistakeReviewView(model: model)
        case .progress: PhoneProgressView(model: model)
        case .badges:   BadgesView(model: model)
        case .hive:     HiveView(model: model)
        case .settings: SettingsView(model: model)
        }
    }

    @ViewBuilder
    private var overlays: some View {
        switch model.overlay {
        case .permission:
            PermissionOverlay(model: model)
        case .error(let kind):
            ErrorOverlay(model: model, kind: kind)
        case nil:
            EmptyView()
        }
    }
}

// MARK: - Bottom navigation

struct BottomNav: View {
    @Bindable var model: PhoneViewModel

    private struct Tab { let icon: String; let name: String; let screen: PhoneScreen }
    private let tabs: [Tab] = [
        .init(icon: "🏠", name: "Home", screen: .home),
        .init(icon: "✏️", name: "Practice", screen: .practice),
        .init(icon: "📊", name: "Progress", screen: .progress),
        .init(icon: "🍯", name: "Hive", screen: .hive),
        .init(icon: "⚙️", name: "Settings", screen: .settings),
    ]

    var body: some View {
        HStack(spacing: 0) {
            ForEach(tabs, id: \.name) { tab in
                Button {
                    model.go(tab.screen)
                } label: {
                    VStack(spacing: 3) {
                        Text(tab.icon).font(.system(size: 21))
                        Text(tab.name).font(.baloo(11, .bold))
                    }
                    .foregroundStyle(model.screen == tab.screen ? Bae.honeyDeep : Color(hex: 0xB8A587))
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.top, 8)
        .padding(.horizontal, 6)
        .padding(.bottom, 4)
        .background(.ultraThinMaterial)
        .overlay(alignment: .top) { Rectangle().fill(Bae.hairline).frame(height: 1) }
    }
}

// MARK: - Overlays

struct PermissionOverlay: View {
    @Bindable var model: PhoneViewModel

    var body: some View {
        ZStack {
            Color(hex: 0x2B2018).opacity(0.45).ignoresSafeArea()
            VStack(spacing: 0) {
                BaeMascotView(mood: .think, size: 104)
                Text("Can Bae hear you?")
                    .font(.baloo(21)).foregroundStyle(Bae.ink).padding(.top, 6)
                Text("SpellingBae needs the microphone so Bae can hear the word or letters you say. You can still practise by typing anytime.")
                    .font(.nunito(14.5, .semibold))
                    .foregroundStyle(Bae.inkMuted)
                    .multilineTextAlignment(.center)
                    .lineSpacing(3)
                    .padding(.top, 8)
                HoneyButton(title: "Continue", action: model.grantMic)
                    .padding(.top, 18)
                Button(action: model.denyMic) {
                    Text("Not now").font(.baloo(15, .bold)).foregroundStyle(Bae.inkSoft)
                        .padding(.vertical, 8)
                }
                .buttonStyle(.plain)
                .padding(.top, 9)
            }
            .padding(24)
            .background(Color.white, in: RoundedRectangle(cornerRadius: 26))
            .padding(.horizontal, 26)
        }
    }
}

struct ErrorOverlay: View {
    @Bindable var model: PhoneViewModel
    var kind: PhoneOverlay.ErrorKind

    private var content: (mood: BaeMood, title: String, body: String, primary: String) {
        switch kind {
        case .audio:  return (.oops, "Bae couldn’t play the word", "Let’s try again in a moment.", "🔁 Retry")
        case .voice:  return (.think, "Bae didn’t catch that", "Please try again, or play the word once more.", "🎤 Try again")
        case .noise:  return (.oops, "It sounds a little noisy", "Try moving somewhere quieter so Bae can hear you.", "🎤 Try again")
        case .denied: return (.think, "Bae needs microphone access", "You can turn it on in Settings — or keep practising by typing.", "Open Settings")
        }
    }

    private let demoButtons: [(String, PhoneOverlay.ErrorKind)] = [
        ("🔇 Audio", .audio), ("🎤 Voice", .voice), ("🔊 Noisy", .noise), ("🚫 Denied", .denied),
    ]

    var body: some View {
        ZStack(alignment: .bottom) {
            Color(hex: 0x2B2018).opacity(0.45).ignoresSafeArea()
                .onTapGesture { model.closeOverlay() }
            VStack(spacing: 0) {
                BaeMascotView(mood: content.mood, size: 96)
                Text(content.title).font(.baloo(20)).foregroundStyle(Bae.ink).padding(.top, 4)
                Text(content.body)
                    .font(.nunito(14.5, .semibold)).foregroundStyle(Bae.inkMuted)
                    .multilineTextAlignment(.center).lineSpacing(3).padding(.top, 6)
                HStack(spacing: 9) {
                    pill(content.primary, fill: Bae.action, text: Bae.ink, shadow: true)
                        .onTapGesture { model.closeOverlay() }
                    pill("⌨ Type instead", fill: Bae.pill, text: Bae.honey, shadow: false)
                        .overlay(RoundedRectangle(cornerRadius: 14).strokeBorder(Bae.pillBorder, lineWidth: 1.5))
                        .onTapGesture { model.closeOverlay() }
                }
                .padding(.top, 16)
                HStack(spacing: 8) {
                    ForEach(demoButtons, id: \.0) { item in
                        Text(item.0)
                            .font(.nunito(11))
                            .foregroundStyle(Bae.inkSoft)
                            .padding(.vertical, 5).padding(.horizontal, 10)
                            .background(Color(hex: 0xF6ECD5), in: Capsule())
                            .onTapGesture { model.openOverlay(.error(item.1)) }
                    }
                }
                .padding(.top, 14)
            }
            .padding(22)
            .frame(maxWidth: .infinity)
            .background(Color.white, in: UnevenRoundedRectangle(cornerRadii: .init(topLeading: 28, topTrailing: 28)))
        }
        .ignoresSafeArea(edges: .bottom)
    }

    private func pill(_ title: String, fill: Color, text: Color, shadow: Bool) -> some View {
        Text(title)
            .font(.baloo(15, .bold))
            .foregroundStyle(text)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 13)
            .background(fill, in: RoundedRectangle(cornerRadius: 14))
            .shadow(color: shadow ? Bae.honeyDeep : .clear, radius: 0, y: 4)
    }
}
