//
//  ColorModel.swift
//  BerryBright
//
//  Created by Simon on 06/01/2025.
//

import Foundation
import SwiftData
import SwiftUI

@Model
class ColorModel {
    var colorPercentage: Float
    var brightness: Float
    var screenBrightness: CGFloat
    var date: Date

    init(
        colorPercentage: Float, brightness: Float, screenBrightness: CGFloat,
        hex: String, rgb: String, date: Date
    ) {
        self.colorPercentage = colorPercentage
        self.brightness = brightness
        self.screenBrightness = screenBrightness
        self.date = date
    }

    var color: (red: Double, green: Double, blue: Double) {
        calculateRGB(
            for: Double(colorPercentage) / 100.0, brightness: Double(brightness)
        )
    }

    var background: Color {
        let rgbValues = color
        return Color(
            red: rgbValues.red / 255.0,
            green: rgbValues.green / 255.0,
            blue: rgbValues.blue / 255.0
        )
    }

    var rgbString: String {
        let rgbValues = color
        return
            "\(Int(rgbValues.red)) \(Int(rgbValues.green)) \(Int(rgbValues.blue))"
    }

    var hexString: String {
        let rgbValues = color
        return String(
            format: "#%02X%02X%02X",
            Int(rgbValues.red),
            Int(rgbValues.green),
            Int(rgbValues.blue)
        )
    }

    private func calculateRGB(for position: Double, brightness: Double) -> (
        red: Double, green: Double, blue: Double
    ) {
        let totalSegments = 6
        let segmentLength = 1.0 / Double(totalSegments)
        let segment = Int(position / segmentLength)
        let fraction =
            (position - Double(segment) * segmentLength) / segmentLength

        let (baseRed, baseGreen, baseBlue): (Double, Double, Double)
        switch segment {
        case 0:
            baseRed = 255
            baseGreen = 255 * fraction
            baseBlue = 0
        case 1:
            baseRed = 255 * (1.0 - fraction)
            baseGreen = 255
            baseBlue = 0
        case 2:
            baseRed = 0
            baseGreen = 255
            baseBlue = 255 * fraction
        case 3:
            baseRed = 0
            baseGreen = 255 * (1.0 - fraction)
            baseBlue = 255
        case 4:
            baseRed = 255 * fraction
            baseGreen = 0
            baseBlue = 255
        case 5:
            baseRed = 255
            baseGreen = 0
            baseBlue = 255 * (1.0 - fraction)
        default:
            baseRed = 255
            baseGreen = 0
            baseBlue = 0
        }

        let adjustedRed =
            255 * (1.0 - brightness / 100.0) + baseRed * (brightness / 100.0)
        let adjustedGreen =
            255 * (1.0 - brightness / 100.0) + baseGreen * (brightness / 100.0)
        let adjustedBlue =
            255 * (1.0 - brightness / 100.0) + baseBlue * (brightness / 100.0)

        return (adjustedRed, adjustedGreen, adjustedBlue)
    }
}
