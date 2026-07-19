//
//  RootView.swift
//  SpellingBae
//
//  Top-level iPad shell: persistent sidebar + the active screen.
//

import SwiftUI

struct RootView: View {
    @State private var model = AppShellViewModel()

    var body: some View {
        HStack(spacing: 0) {
            SidebarView(model: model)
            content
        }
        .background(Bae.panel)
        .ignoresSafeArea(.keyboard)
    }

    @ViewBuilder
    private var content: some View {
        switch model.screen {
        case .home:
            HomeView(model: model)
        case .practice:
            PracticeSessionView(model: model)
        case .progress, .hive, .settings:
            placeholder
        }
    }

    private var placeholder: some View {
        VStack(spacing: 14) {
            BaeMascotView(mood: .think, size: 120)
            Text("Coming soon!")
                .font(.baloo(26))
                .foregroundStyle(Bae.ink)
            Text("This corner of the hive is still being built.")
                .font(.nunito(15))
                .foregroundStyle(Bae.inkMuted)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Bae.panel)
    }
}

#Preview {
    RootView()
}
