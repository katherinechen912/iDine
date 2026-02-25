import SwiftUI

struct MainView: View {
    // Accesses the navigation brain to handle tab switching.
    @Environment(TabController.self) var tabController
    // Accesses the order data to update badges and triggers.
    @Environment(Order.self) var order
    
    @State private var themeManager = ThemeManager.shared

    var body: some View {
        // The selection is bound to the activeTab property in TabController.
        TabView(selection: Bindable(tabController).activeTab) {
            
            // Tab 1: The main menu discovery page.
            Tab("Explore", systemImage: "house", value: DineTab.menuTab) {
                ContentView()
            }
            
            // Tab 2: The list of items the user has liked.
            Tab("Saved", systemImage: "heart", value: DineTab.favoriteTab) {
                FavoritesView()
            }
            
            // Tab 3: The shopping cart with a live item counter.
            Tab("Cart", systemImage: "bag", value: DineTab.orderTab) {
                OrderView()
                    // Triggers a subtle vibration whenever the item count increases.
                    .sensoryFeedback(SensoryFeedback.increase, trigger: order.items.count)
            }
            // Displays a red numeric badge over the cart icon.
            .badge(order.items.count)
            
            // Tab 4: User settings and theme selection.
            Tab("Profile", systemImage: "person.crop.circle", value: DineTab.profileTab) {
                ProfileView()
            }
        }
        // Colors the icons based on the active theme's primary color.
        .tint(themeManager.currentTheme.primaryColor)
        // Automatically switches system appearance (status bar, etc.) to match the theme.
        .preferredColorScheme(themeManager.currentTheme == .midnight ? .dark : .light)
    }
}

// Logical controller that persists the current navigation state.
@Observable
class TabController {
    // Defaults to the menu tab upon app launch.
    var activeTab: DineTab = .menuTab
    
    // Function used by other views (like Checkout) to jump to a specific tab.
    func switchTab(to tab: DineTab) {
        activeTab = tab
    }
}

// A blueprint defining the four valid navigation targets in the app.
// This should be defined only once to prevent naming conflicts.
enum DineTab {
    case menuTab
    case favoriteTab
    case orderTab
    case profileTab
}
