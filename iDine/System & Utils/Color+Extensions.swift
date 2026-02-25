//  Color+Extensions.swift
//  iDine

import SwiftUI

extension Color {
    // Initializes a SwiftUI Color using a web standard Hex string
    init(hex: String) {
        
        // Removes any non-alphanumeric characters like the '#' symbol
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        
        // A variable to hold the numerical value of the hex string
        var int: UInt64 = 0
        
        // Converts the text string into a 64-bit computer integer
        Scanner(string: hex).scanHexInt64(&int)
        
        let a, r, g, b: UInt64
        
        // Extracts the red, green, and blue values based on the string length
        switch hex.count {
        case 3:
            // Handles 3-character hex like "F00"
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            // Handles standard 6-character hex like "FF6B35" using bitwise shifts
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        default:
            // Fallback to solid black if the hex is invalid
            (a, r, g, b) = (255, 0, 0, 0)
        }
        
        // Divides the 0-255 values by 255 to feed SwiftUI's required 0.0-1.0 decimal format
        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: Double(a) / 255)
    }
}
