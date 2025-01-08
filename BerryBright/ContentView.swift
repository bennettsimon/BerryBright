//
//  ContentView.swift
//  BerryBright
//
//  Created by Simon on 03/01/2025.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    @EnvironmentObject var colorOverlapConfig: ColorOverlapConfig

    var body: some View {
        ZStack {
            // Tab View(Hide the tab bar)
            TabView(selection: $selectedTab) {
                LightView()
                    .tag(0)

                FavouriteView()
                    .tag(1)
            }
            .frame(maxHeight: .infinity)

            // Customise the tab bar
            VStack {
                Spacer()

                HStack {
                    TabButton(
                        icon: "light.beacon.max.fill",
                        label: "Light",
                        index: 0,
                        selectedTab: $selectedTab
                    )

                    TabButton(
                        icon: "sparkles.rectangle.stack.fill",
                        label: "Favorite",
                        index: 1,
                        selectedTab: $selectedTab
                    )
                }
                .padding(.bottom, 34)
                .padding(.top, 12)
                .background(BlurView(style: .systemThinMaterial))
            }
            .edgesIgnoringSafeArea(.bottom)

            // Overlap
            ZStack {
                Spacer()
            }
            .background(colorOverlapConfig.color)
            .opacity(colorOverlapConfig.isFullScreen ? 1 : 0)
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.1)) {
                    colorOverlapConfig.isFullScreen = false
                }
            }
        }
    }
}

struct TabButton: View {
    let icon: String
    let label: String
    let index: Int
    @Binding var selectedTab: Int

    var body: some View {
        VStack {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .medium))

            Text(label)
                .font(.system(size: 12, weight: .medium))
        }
        .foregroundStyle(index == selectedTab ? .accent : .gray)
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())
        .onTapGesture {
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()

            selectedTab = index
        }
    }
}

struct BlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style

    func makeUIView(context: Context) -> UIVisualEffectView {
        let blurEffect = UIBlurEffect(style: style)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.clipsToBounds = true
        return blurView
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        // ...
    }
}

#Preview {
    ContentView()
        .environmentObject(
            ColorOverlapConfig(
                color: Color(.white), isFullScreen: false)
        )
        .modelContainer(for: [ColorModel.self])
}
