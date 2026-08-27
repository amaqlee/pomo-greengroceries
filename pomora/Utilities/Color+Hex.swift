//
//  Color+Hex.swift
//  pomora
//
//  Created by Amanda Lee on 8/26/26.
//

import SwiftUI

//converts from rgb -> hex, so we can use Color(hex: ___) syntax
extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex.trimmingCharacters(in: .init(charactersIn: "#")))
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        self.init(
            red: Double((rgb >> 16) & 0xFF) / 255,
            green: Double((rgb >> 8) & 0xFF) / 255,
            blue: Double(rgb & 0xFF) / 255
        )
    }
}
