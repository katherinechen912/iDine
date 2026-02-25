import SwiftUI

struct OrderView: View {
    @Environment(Order.self) var order
    @Environment(TabController.self) var tabController
    @State private var themeManager = ThemeManager.shared
    
    // Create a unique ID to control the navigation stack reset.
    @State private var stackId = UUID()
    
    var body: some View {
        NavigationStack {
            ZStack {
                // High-fidelity animated background.
                AppBackground()
                
                if order.items.isEmpty {
                    emptyState
                } else {
                    VStack(spacing: 0) {
                        // List to enable native swipe-to-delete.
                        orderList
                        checkoutButton
                    }
                }
            }
            .navigationTitle("Your Order") 
            .toolbar { EditButton() }
            
            // ---  NAVIGATION LOGIC ---
            // This observer detects when the cart becomes empty (0 items).
            // It triggers two actions:
            // 1. Resets the NavigationStack to clear lingering sub-views.
            // 2. Switches the active tab back to the 'Explore' menu.
            .onChange(of: order.items.count) { _, newValue in
                if newValue == 0 {
                    
                    // Force the ID to refresh. This completely clears the NavigationStack of any lingering sub-views (like PaymentView).
                    stackId = UUID()
                    
                    // Uses a spring animation to smoothly teleport the user home.
                    withAnimation(.spring()) {
                        tabController.activeTab = .menuTab
                    }
                }
            }
            // ---  ADDED LOGIC to return back to the cart END ---
        }
       // Bind the NavigationStack to this ID to enable the reset.
        .id(stackId)
    }
    
    private var orderList: some View {
        // List is required for the .onDelete modifier to function.
        List {
            ForEach(order.items) { item in
                HStack {
                    Text(item.name)
                        .font(.body)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    Text("$\(item.price)")
                        .fontWeight(.bold)
                        .foregroundColor(themeManager.currentTheme.primaryColor)
                }
                .padding()
                // Glass-morphism effect applied to each row.
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.3), lineWidth: 0.5)
                )
                // Removes the default gray background and separators of the List row.
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets(top: 6, leading: 20, bottom: 6, trailing: 20))
            }
            // enables swipe-to-delete.
            .onDelete(perform: deleteItems)
        }
        // Sets the list style to plain to remove default background colors.
        .listStyle(.plain)
    }
    
    private var checkoutButton: some View {
        NavigationLink(destination: CheckoutView()) {
            HStack {
                Text("Place Order")
                Spacer()
                Text("$\(order.total)")
                    .contentTransition(.numericText())
                    .animation(.snappy, value: order.total)
            }
            .font(.headline)
            
            // Ternary operator: It checks if the theme is 'midnight'.
            .foregroundColor(themeManager.currentTheme == .midnight ? .black : .white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(themeManager.currentTheme.ctaGradient)
            .clipShape(Capsule())
            .shadow(color: themeManager.currentTheme.primaryColor.opacity(0.3), radius: 10, y: 5)
        }
        .buttonStyle(SqueezeButtonStyle())
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
        .padding(.top, 10)
    }
    
    private var emptyState: some View {
        VStack(spacing: 20) {
            Image(systemName: "cart.badge.minus")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            Text("Your cart is empty")
                .font(.headline)
                .foregroundColor(.gray)
        }
    }

    // This function handles the actual data removal from the global Order object.
    func deleteItems(at offsets: IndexSet) {
        order.items.remove(atOffsets: offsets)
    }
}

#Preview {
    OrderView()
        .environment(Order())
        .environment(TabController())
}
