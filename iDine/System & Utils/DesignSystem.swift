import SwiftUI

@Observable
class ThemeManager {
    
    // Creates a single, globally accessible instance of the ThemeManager
    static let shared = ThemeManager()
    
    // The currently active theme for the app, defaulting to Spring
    var currentTheme: AppThemeMode = .spring
    
    // Defines the available themes. 'String' allows text representation,
    // and 'CaseIterable' allows looping through all themes to build UI pickers.
    enum AppThemeMode: String, CaseIterable {
        case appetite = "Appetite", spring = "Spring", midnight = "Midnight", dream = "Dream"
        
        var rawValue: String { self.title }
        
        var title: String {
            switch self {
            case .appetite: return "Appetite"
            case .spring: return "Spring"
            case .midnight: return "Midnight"
            case .dream: return "Dream"
            }
        }

        // The solid base layer color for the application background
        var backgroundColor: Color {
            switch self {
            case .appetite: return Color(hex: "FFF4E6")
            case .spring: return Color(hex: "F0F7F0")
            case .midnight: return Color(hex: "08080C")
            case .dream: return Color(hex: "F8F0FC")
            }
        }
        
        // High-contrast accent colors used to generate the blurred, moving mesh gradient
        var meshColors: [Color] {
            switch self {
            case .appetite:
                return [Color(hex: "FF5E00"), Color(hex: "FFB800"), Color(hex: "FF1A1A")]
            case .spring:
                return [Color(hex: "74E39A"), Color(hex: "FFE359"), Color(hex: "297045")]
            case .midnight:
                return [Color(hex: "8A2BE2"), Color(hex: "0052D4"), Color(hex: "00C9FF")]
            case .dream:
                return [Color(hex: "FF9A8B"), Color(hex: "D08BFF"), Color(hex: "8BA8FF")]
            }
        }
        
        // The small preview color displayed inside the theme selection circles on the Profile page
        var swatchColor: Color {
            switch self {
            case .appetite: return Color(hex: "FF5E00")
            case .spring: return Color(hex: "557A46")
            case .midnight: return Color(hex: "000000")
            case .dream: return Color(hex: "CFA5FF")
            }
        }

        // The main accent color used for typography, icons, and highlighting important elements
        var primaryColor: Color {
            switch self {
            case .appetite: return Color(hex: "FF5E00")
            case .spring: return Color(hex: "557A46")
            case .midnight: return Color(hex: "FFFFFF")
            case .dream: return Color(hex: "9A65CC")
            }
        }

        // The gradient styling applied specifically to the main Call-To-Action (CTA) buttons
        var ctaGradient: LinearGradient {
            switch self {
            case .appetite:
                return LinearGradient(colors: [Color(hex: "FF5E00"), Color(hex: "FF2E2E")], startPoint: .topLeading, endPoint: .bottomTrailing)
            case .spring:
                return LinearGradient(colors: [Color(hex: "7A9D54"), Color(hex: "A4C639")], startPoint: .topLeading, endPoint: .bottomTrailing)
            case .midnight:
                return LinearGradient(colors: [Color(hex: "00C9FF"), Color(hex: "0052D4")], startPoint: .topLeading, endPoint: .bottomTrailing)
            case .dream:
                return LinearGradient(colors: [Color(hex: "FF9A8B"), Color(hex: "FF6A88")], startPoint: .topLeading, endPoint: .bottomTrailing)
            }
        }
    }
}
