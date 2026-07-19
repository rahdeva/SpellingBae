//
//  SidebarView.swift
//  SpellingBae
//

import SwiftUI

struct SidebarView: View {
    @Bindable var model: AppShellViewModel

    private struct NavItem: Identifiable {
        let id = UUID()
        let icon: String
        let name: String
        let screen: AppScreen
    }

    private let items: [NavItem] = [
        .init(icon: "🏠", name: "Home", screen: .home),
        .init(icon: "✏️", name: "Practice", screen: .practice),
        .init(icon: "📊", name: "Progress", screen: .progress),
        .init(icon: "🍯", name: "Hive", screen: .hive),
        .init(icon: "⚙️", name: "Settings", screen: .settings),
    ]

    var body: some View {
        VStack(spacing: 0) {
            // Logo
            HStack(spacing: 9) {
                BaeMascotView(mood: .wave, size: 46)
                Text("SpellingBae")
                    .font(.baloo(21))
                    .foregroundStyle(Bae.inkStrong)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 6)
            .padding(.bottom, 4)

            // Nav
            VStack(spacing: 5) {
                ForEach(items) { item in
                    navRow(item)
                }
            }
            .padding(.top, 22)

            Spacer(minLength: 16)

            levelCard
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 22)
        .frame(width: 230)
        .background(
            LinearGradient(
                colors: [Bae.sidebarTop, Bae.sidebarBottom],
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .overlay(alignment: .trailing) {
            Rectangle().fill(Bae.hairline).frame(width: 1)
        }
    }

    private func navRow(_ item: NavItem) -> some View {
        let active = model.screen == item.screen
        return Button {
            model.go(to: item.screen)
        } label: {
            HStack(spacing: 12) {
                Text(item.icon).font(.system(size: 20))
                Text(item.name).font(.baloo(16))
                Spacer(minLength: 0)
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 14)
            .background(active ? Bae.action : .clear, in: RoundedRectangle(cornerRadius: 15))
            .foregroundStyle(active ? Bae.ink : Color(hex: 0x8A6A3E))
        }
        .buttonStyle(.plain)
    }

    private var levelCard: some View {
        VStack(spacing: 0) {
            Text("Level")
                .font(.nunito(12))
                .foregroundStyle(Bae.inkMuted)
            Text("🌻 Intermediate")
                .font(.baloo(16))
                .foregroundStyle(Bae.honey)
            HStack(spacing: 12) {
                HStack(spacing: 4) {
                    HexBadge(size: 15)
                    Text("\(model.honey)")
                }
                .font(.baloo(14))
                .foregroundStyle(Bae.honey)

                Text("🔥\(model.streak)")
                    .font(.baloo(14))
                    .foregroundStyle(Bae.streak)
            }
            .padding(.top, 10)
        }
        .padding(14)
        .frame(maxWidth: .infinity)
        .background(Color.white, in: RoundedRectangle(cornerRadius: 18))
        .overlay(
            RoundedRectangle(cornerRadius: 18).strokeBorder(Bae.cardBorder, lineWidth: 1)
        )
    }
}

/// A small honeycomb-shaped honey token.
struct HexBadge: View {
    var size: CGFloat = 15
    var color: Color = Bae.honeyBright

    var body: some View {
        HexagonShape()
            .fill(color)
            .frame(width: size, height: size * 1.06)
    }
}

struct HexagonShape: Shape {
    func path(in rect: CGRect) -> Path {
        // Matches the CSS clip-path polygon(25% 0,75% 0,100% 50%,75% 100%,25% 100%,0 50%)
        let w = rect.width
        var path = Path()
        path.move(to: CGPoint(x: rect.minX + w * 0.25, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX + w * 0.75, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX + w, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.minX + w * 0.75, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX + w * 0.25, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
        path.closeSubpath()
        return path
    }
}
