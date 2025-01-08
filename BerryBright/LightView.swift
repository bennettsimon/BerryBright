//
//  LightView.swift
//  BerryBright
//
//  Created by Simon on 03/01/2025.
//

import SwiftUI

struct LightView: View {
    @State private var colorPercentage: Float = 97
    @State private var brightness: Float = 70
    @State private var screenBrightness = UIScreen.main.brightness
    
    @EnvironmentObject var colorOverlapConfig: ColorOverlapConfig
    @Environment(\.modelContext) private var modelContext

    var selectedColor: ColorModel {
        let colorModel = ColorModel(
            colorPercentage: colorPercentage,
            brightness: brightness,
            screenBrightness: screenBrightness,
            hex: "",
            rgb: "",
            date: Date()
        )
        return colorModel
    }

    var body: some View {
        VStack(spacing: 16) {
            // Color paltte
            VStack {
                // Bookmark button
                HStack {
                    Spacer()
                    HStack {
                        Image(
                            systemName:
                                "bookmark"
                        )
                        .font(.system(size: 16))
                    }
                    .frame(maxWidth: 52, maxHeight: 52)
                    .background(Color(.white).cornerRadius(20))
                }
                .onTapGesture {
                    let generator = UIImpactFeedbackGenerator(style: .light)
                    generator.impactOccurred()
                    
                    saveColor()
                }

                Spacer()

                HStack {
                    // Hex & RGB string
                    HStack {
                        Spacer()
                        Text(selectedColor.hexString)
                        Circle()
                            .frame(width: 4, height: 4)
                            .padding(.horizontal, 6)
                        Text(selectedColor.rgbString)
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
                            colorOverlapConfig.color = selectedColor.background
                        }
                    }

                }
            }
            .padding(16)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                selectedColor.background.cornerRadius(32)
            )

            // Color picker slider
            GeometryReader { geometry in
                ZStack {

                    LinearGradient(
                        gradient: Gradient(colors: [
                            .red, .yellow, .green, .cyan, .blue,
                            .purple,
                            .red,
                        ]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .cornerRadius(16)

                    RoundedRectangle(cornerRadius: 16)
                        .frame(width: 16, height: 40)
                        .foregroundStyle(.white)
                        .position(
                            x: CGFloat(self.colorPercentage / 100)
                                * (geometry.size.width - 24) + 12,
                            y: geometry.size.height / 2
                        )
                        .shadow(
                            color: Color(
                                .sRGBLinear, white: 0, opacity: 0.13),
                            radius: 2)

                }

                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged({ value in
                            self.colorPercentage = min(
                                max(
                                    0,
                                    Float(
                                        value.location.x
                                            / geometry.size.width * 100)
                                ),
                                100)
                        })
                )
            }
            .frame(maxWidth: .infinity)
            .frame(height: 48)

            // Brightness slider
            GeometryReader { geometry in
                ZStack {

                    LinearGradient(
                        gradient: Gradient(colors: [
                            .white,
                            selectedColor.background,
                        ]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .cornerRadius(16)

                    RoundedRectangle(cornerRadius: 16)
                        .frame(width: 16, height: 40)
                        .foregroundStyle(.white)
                        .position(
                            x: CGFloat(self.brightness / 100)
                                * (geometry.size.width - 24) + 12,
                            y: geometry.size.height / 2
                        )
                        .shadow(
                            color: Color(
                                .sRGBLinear, white: 0, opacity: 0.13),
                            radius: 2)

                }
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged({ value in
                            self.brightness = min(
                                max(
                                    0,
                                    Float(
                                        value.location.x
                                            / geometry.size.width * 100)
                                ),
                                100)
                        })
                )
            }
            .frame(maxWidth: .infinity)
            .frame(height: 48)

            // Screen brightness slider
            GeometryReader { geometry in
                ZStack {
                    HStack {
                        RoundedRectangle(cornerRadius: 12)
                            .frame(
                                width: min(
                                    max(
                                        12,
                                        (CGFloat(self.screenBrightness)
                                            * geometry.size.width)),
                                    geometry.size.width - 8)
                            )
                            .foregroundStyle(.white)

                        Spacer()
                            .frame(minWidth: 0)
                    }
                    .padding(4)

                    HStack {
                        Image(systemName: "light.min")
                            .font(.system(size: 16))
                            .fontWeight(.medium)

                        Spacer()

                        Image(systemName: "light.max")
                            .font(.system(size: 16))
                            .fontWeight(.medium)
                    }
                    .padding(12)
                }
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged({ value in
                            let newBrightness = min(
                                max(
                                    0,
                                    value.location.x
                                        / geometry.size.width),
                                1.0
                            )
                            self.screenBrightness = CGFloat(
                                Float(newBrightness))
                            UIScreen.main.brightness = CGFloat(
                                newBrightness)
                        })
                )
            }
            .frame(maxWidth: .infinity, maxHeight: 48)
            .background(
                Color(
                    UIColor.systemGray6.resolvedColor(
                        with: UITraitCollection(
                            userInterfaceStyle: .light))
                ).cornerRadius(16))
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 20)

    }

    private func saveColor() {
        modelContext.insert(selectedColor)

        do {
            try modelContext.save()
            print("success")
        } catch {
            print("Failed to save data: \(error)")
        }
    }
}

#Preview {
    LightView()
        .modelContainer(for: [ColorModel.self])
}
