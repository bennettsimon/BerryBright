//
//  FavouriteView.swift
//  BerryBright
//
//  Created by Simon on 03/01/2025.
//

import SwiftData
import SwiftUI

struct FavouriteView: View {
    @Query(sort: \ColorModel.date, order: .reverse) private var colors:
        [ColorModel]

    var body: some View {
        ZStack {
            ScrollView {
                Spacer(minLength: 62)

                ForEach(colors) { color in
                    HStack {
                        Spacer(minLength: 16)
                        ColorCardView(color: color)
                        Spacer(minLength: 16)
                    }
                }

                Spacer(minLength: 96)
            }
            .scrollIndicators(.hidden)
            .ignoresSafeArea()
            .toolbar(.hidden, for: .automatic)

            if colors.count < 1 {
                EmptyView()
            }
        }
    }
}

struct ColorCardView: View {
    var color: ColorModel
    @EnvironmentObject var colorOverlapConfig: ColorOverlapConfig
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        VStack {
            Spacer()

            HStack {
                // Hex & RGB string
                HStack {
                    Spacer()
                    Text(color.hexString)
                    Circle()
                        .frame(width: 4, height: 4)
                        .padding(.horizontal, 6)
                    Text(color.rgbString)
                    Spacer()
                }
                .frame(maxHeight: 52)
                .background(Color(.white).cornerRadius(20))

                Spacer(minLength: 16)

                // Full screen button
                HStack {
                    Image(
                        systemName:
                            "arrow.up.left.and.arrow.down.right"
                    )
                    .font(.system(size: 16))
                }
                .frame(maxWidth: 52, maxHeight: 52)
                .background(Color(.white).cornerRadius(20))
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.1)) {
                        colorOverlapConfig.isFullScreen = true
                        colorOverlapConfig.color = color.background
                    }
                }

            }
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .frame(height: 180)
        .background(color.background.cornerRadius(32))
        .contentShape(.contextMenuPreview, RoundedRectangle(cornerRadius: 32))
        .contextMenu {
            Button(action: {
                deleteColor(color)
            }) {
                Text("Delete")
                Image(systemName: "trash")
            }
        }
    }

    private func deleteColor(_ color: ColorModel) {
        withAnimation {
            modelContext.delete(color)
            try? modelContext.save()
        }
    }
}

struct EmptyView: View {
    var body: some View {
        VStack(spacing: 40) {
            ZStack {
                RoundedRectangle(cornerRadius: 32)
                    .fill(
                        Color(
                            red: 245 / 255, green: 245 / 255,
                            blue: 255 / 255)
                    )
                    .frame(width: 180, height: 180)
                    .rotationEffect(
                        .degrees(-15), anchor: .bottomLeading)

                RoundedRectangle(cornerRadius: 32)
                    .fill(.accent)
                    .frame(width: 180, height: 180)
                    .rotationEffect(
                        .degrees(10), anchor: .bottomTrailing)

                GeometryReader { geometry in
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.accent)
                            .frame(width: 52, height: 52)
                        Image(systemName: "bookmark")
                            .font(.system(size: 16))
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                    }
                    .position(
                        x: geometry.size.width - 46,
                        y: 46
                    )

                    ZStack {
                        Path { path in
                            path.move(
                                to: CGPoint(
                                    x: 149.596843 - 148.1427,
                                    y: 360.958894 - 360.5908))
                            path.addCurve(
                                to: CGPoint(
                                    x: 225 - 148.1427, y: 402 - 360.5908
                                ),
                                control1: CGPoint(
                                    x: 157.198948 - 148.1427,
                                    y: 390.986298 - 360.5908),
                                control2: CGPoint(
                                    x: 182.333333 - 148.1427,
                                    y: 404.666667 - 360.5908)
                            )
                        }
                        .stroke(
                            Color(.accent), lineWidth: 3
                        )
                        .frame(width: 76.9508462, height: 43.2342684)
                    }
                    .position(
                        x: 73,
                        y: geometry.size.height - 55
                    )

                }
                .frame(width: 180, height: 180)
                .background(
                    Color(
                        red: 217 / 255, green: 220 / 255,
                        blue: 255 / 255
                    ).cornerRadius(
                        32))
            }

            VStack(spacing: 12) {
                HStack(spacing: 12) {
                    Text("Use")
                    ZStack {
                        Circle()
                            .stroke()
                            .frame(width: 32, height: 32)
                        Image(systemName: "bookmark")
                            .font(.system(size: 12))
                            .fontWeight(.semibold)
                    }
                    Text("button")
                }
                .font(.system(size: 32, weight: .semibold))

                Text("to save your favourite")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(
                        Color(
                            UIColor.systemGray4.resolvedColor(
                                with: UITraitCollection(
                                    userInterfaceStyle: .light))
                        ))
            }
        }
    }
}

#Preview {
    FavouriteView()
        .modelContainer(for: [ColorModel.self])
}
