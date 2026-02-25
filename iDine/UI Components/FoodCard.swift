//
//  FoodCard.swift
//  iDine
//

import SwiftUI

struct FoodCard: View {
    let item: MenuItem
    
    // Monitors the global theme manager to dynamically update colors (e.g., price and icons) based on the active theme.
    @State private var themeManager = ThemeManager.shared
    
    // A dictionary mapping dietary restriction codes to specific UI colors.
    let colors: [String: Color] = ["D": .red, "G": .blue, "N": .mint, "S": .yellow, "V": .green]
    
    var body: some View {
        HStack(spacing: 15) {
            
            // Left Column: Text Information
            VStack(alignment: .leading, spacing: 8) {
                
                // Title and Dietary Tags
                HStack {
                    Text(item.name)
                        .font(.headline)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                    
                    ForEach(item.restrictions, id: \.self) { restriction in
                        Text(restriction)
                            .font(.caption2.bold())
                            .padding(4)
                            .background(colors[restriction, default: .black])
                            .clipShape(Circle())
                            .foregroundColor(.white)
                    }
                }
                
                // Truncated Description
                Text(item.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                // Price and Add Icon
                HStack {
                    Text("$\(item.price)")
                        .font(.system(size: 16, weight: .heavy))
                        .foregroundColor(themeManager.currentTheme.primaryColor)
                    
                    Spacer()
                    
                    Image(systemName: "plus.circle.fill")
                        .font(.title3)
                        .foregroundColor(themeManager.currentTheme.primaryColor)
                }
            }
            
            Spacer()
            
            // Right Column: Main Image
            Image(item.mainImage)
                .resizable()
                .scaledToFill()
                .frame(width: 90, height: 90)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .padding()
        // Applies a frosted glass material, allowing the dynamic background colors to diffuse through the card.
        .background(.ultraThinMaterial)
        .cornerRadius(18)
        // Adds an ultra-fine, semi-transparent white border to create a subtle 3D "glowing edge" effect.
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(Color.white.opacity(0.4), lineWidth: 0.5)
        )
        .shadow(color: .black.opacity(0.03), radius: 8, y: 4)
        .padding(.horizontal)
    }
}
