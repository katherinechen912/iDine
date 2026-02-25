//
//  ItemRow.swift
//  iDine
//
//  Created by AME STUDENT on 2026/2/1.
//

import SwiftUI

struct ItemRow: View {
    let item: MenuItem
    
    let colors: [String: Color] = ["D": .red, "G": .blue, "N": .mint, "S": .yellow, "V": .green]
    
    var body: some View {
        // Horizontal Stack: Put things side by side
        HStack {
            // 1. First item: Stays on the LEFT
            Image(item.thumbnailImage)//Initializer
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.pink.opacity(0.2), lineWidth: 3))
            // 2. Second item: Stays on the RIGHT
                    // This is a Vertical Stack: Put things one above another
            VStack(alignment: .leading) {
                // 2a. Top row of the vertical stack
                Text(item.name)
                    .font(Font.headline)
                // 2b. Bottom row of the vertical stack
                Text("$\(item.price, specifier: "%.2f")")
            }
            
            Spacer()
            
            ForEach(item.restrictions, id: \.self) { restriction in
                Text(restriction)
                    .font(.caption)
                    .fontWeight(.black)
                    .padding(5)
                    .background(colors[restriction, default: .black])
                    .clipShape(Circle())
                    .foregroundStyle(.white)
                    
            }
        }
    }
}

#Preview {
    ItemRow(item: MenuItem.example)
}
