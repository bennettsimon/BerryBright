//
//  Overlap.swift
//  BerryBright
//
//  Created by Simon on 06/01/2025.
//

import SwiftUI

class ColorOverlapConfig: ObservableObject {
    @Published var color: Color
    @Published var isFullScreen: Bool
    
    init(color: Color, isFullScreen: Bool) {
        self.color = color
        self.isFullScreen = isFullScreen
    }
}
