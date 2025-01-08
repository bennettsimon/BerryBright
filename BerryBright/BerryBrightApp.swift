//
//  BerryBrightApp.swift
//  BerryBright
//
//  Created by Simon on 03/01/2025.
//

import SwiftData
import SwiftUI

@main
struct BerryBrightApp: App {
    init() {
        // Force to use light theme
        UIView.appearance().overrideUserInterfaceStyle = .light
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(
                    ColorOverlapConfig(
                        color: Color(.white), isFullScreen: false))
        }
        .modelContainer(for: [ColorModel.self])
    }
}
