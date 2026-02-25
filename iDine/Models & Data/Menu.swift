import SwiftUI
import Foundation

// Top-level container representing a category in the JSON menu.
struct MenuSection: Codable, Identifiable {
    var id: UUID
    var name: String
    var items: [MenuItem]
}

// The primary object representing a dish. It holds all nutritional and pricing data.
struct MenuItem: Codable, Hashable, Identifiable {
    var id: UUID
    var name: String
    
    // Optional property to handle localized image naming conventions.
    var englishName: String?
    
    var photoCredit: String
    var price: Int
    var restrictions: [String]
    var description: String
    var calories: Int
    var attributeTitle: String
    var ingredients: [Ingredient]

    // Formats the name into a lowercase-hyphenated string for the Asset Catalog.
    var mainImage: String {
        let imageNameToUse = englishName ?? name
        return imageNameToUse.replacingOccurrences(of: " ", with: "-").lowercased()
    }

    // Appends a suffix to the main image name to fetch the smaller thumbnail version.
    var thumbnailImage: String {
        "\(mainImage)-thumb"
    }

    // Compiler Directive: This block only exists during development and testing.
    #if DEBUG
    // A static instance used to populate UI layouts in Xcode Previews.
    static let example = MenuItem(
        id: UUID(),
        name: "Maple French Toast",
        englishName: nil,
        photoCredit: "Joseph Gonzalez",
        price: 6,
        restrictions: ["G", "V"],
        description: "Sweet, fluffy, and served piping hot, our French toast is flown in fresh every day from Maple City, Canada.",
        calories: 650,
        attributeTitle: "Ingredients",
        ingredients: [Ingredient(name: "Bread", icon: "🍞")]
    )
    #endif
}

// A supporting data structure representing a single ingredient.
// Placed at the end of the file as it is a dependency of MenuItem.
struct Ingredient: Codable, Hashable, Identifiable {
    // Satisfies Identifiable by using the unique name of the ingredient as the ID.
    var id: String { name }
    var name: String
    var icon: String
}
