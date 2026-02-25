import SwiftUI

struct FavoritesView: View {
    
    // Retrieves the shared Order object from the environment using its type identity (.self)
    @Environment(Order.self) var order
    
    // Monitors the global theme manager to dynamically update text colors based on the current theme
    @State private var themeManager = ThemeManager.shared
    
    var body: some View {
        // The foundational container that allows views to be pushed and popped like a deck of cards
        NavigationStack {
            // Layers views on top of each other along the Z-axis (back to front)
            ZStack {
                // The dynamic mesh gradient placed at the very bottom layer
                AppBackground()
                
                if order.favorites.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "heart.slash").font(.system(size: 60)).foregroundColor(.gray)
                        Text("No saved dishes yet.").font(.headline).foregroundColor(.gray)
                    }
                } else {
                    List {
                        // ForEach iterates through the array to build dynamic rows
                        ForEach(order.favorites) { item in
                            // The interactive button that triggers the transition to the ItemDetail screen
                            NavigationLink(destination: ItemDetail(item: item)) {
                                HStack {
                                    Image(item.mainImage).resizable().scaledToFill()
                                        .frame(width: 60, height: 60).clipShape(RoundedRectangle(cornerRadius: 10))
                                    VStack(alignment: .leading) {
                                        Text(item.name).font(.headline)
                                        Text("$\(item.price)").font(.subheadline).foregroundColor(themeManager.currentTheme.primaryColor)
                                    }
                                }
                            }
                            // Ensures the individual row background is completely transparent
                            .listRowBackground(Color.clear)
                        }
                        
                        // Enables the native iOS swipe-to-delete gesture on the list rows.
                        // When a user swipes and deletes a row, SwiftUI automatically provides
                        // the numerical position (index) of that specific row via the 'indexSet' variable.
                        .onDelete { indexSet in
                            
                            // Locates the exact position within the 'favorites' data array using the provided indexSet,
                                // and permanently removes the item stored at that specific offset.
                            order.favorites.remove(atOffsets: indexSet)
                        }
                    }
                    // Strips away default Apple styling (like gray backgrounds) for a cleaner, transparent list
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Saved Dishes")
        }
    }
}
