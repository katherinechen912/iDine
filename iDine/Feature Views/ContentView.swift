import SwiftUI
import AudioToolbox
import Combine
import UIKit

struct ContentView: View {
    @Environment(Order.self) var order
    // The packaged "local persistence" tool (underlying name: UserDefaults)
    @AppStorage("appLanguage") private var appLanguage = "en"
    
    // The Profile page changes color, and the background changes when you return to the Home page. They must share the same "brain"
    @State private var themeManager = ThemeManager.shared
    
    @State private var selectedCategory: String = "All"
    @State private var showSearch: Bool = false
    @State private var searchText: String = ""
    
    // A state variable that tracks the unique ID (name) of the menu item currently visible in the carousel center.
    @State private var scrolledItemID: String?
    
    // Core engine: 3.5-second automatic carousel timer
    // This timer is like the "heart" of the page; it must be stored in the page's state and cannot be arbitrarily reclaimed by the system.
    // publish - a term from the Combine responsive framework, meaning it acts like a broadcasting station, sending out a time signal every 3.5 seconds.
    @State private var carouselTimer = Timer.publish(every: 3.5, on: .main, in: .common).autoconnect()
    
    // 1. Load the Menu
    var menu: [MenuSection] {
        // Unlike the numeric ternary operators in the animation closures (which force the compiler
        // to guess between Double, Float, and CGFloat across multiple chained modifiers), this
        // ternary operator deals strictly with String literals.
        //
        // A string literal like "menu_en.json" is unambiguously of type String. There are no other
        // potential type options for the compiler to evaluate. Because there is zero ambiguity,
        // there is no combinatorial explosion. The Swift type inference engine resolves it instantly, which is why this specific ternary operation is perfectly safe and never triggers the Canvas timeout error.
        let fileName: String = appLanguage == "en" ? "menu_en.json" : "menu_zh.json"
        
        let decodedData: [MenuSection] = Bundle.main.decode([MenuSection].self, from: fileName)
        return decodedData
    }
    
    // 2. EXACT Target Items for Chef's Choice (Chinese needed to be matched and typed here otherwise it won't showed when changed to CN because.....)
    var recommendations: [MenuItem] {
        let targets: [String] = [
            "Penne Carbonara", "Paella Alicante", "Fillet Steak", "Power Muesli", "Tower Burger", "Pesto Farfalle",
            "奶油培根意面", "阿利坎特海鲜饭", "菲力牛排", "能量燕麦粥", "巨无霸汉堡", "青酱蝴蝶面"
        ]
        
        let allItems: [MenuItem] = menu.flatMap { section in section.items }
        let filteredItems: [MenuItem] = allItems.filter { item in targets.contains(item.name) }
        
        return filteredItems
    }

    var body: some View {
        NavigationStack {
            ZStack {
                // Diffuse light background
                AppBackground()
                
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 25.0) {
                        searchBarSection
                        chefChoiceSection
                        categorySection
                        menuListSection
                    }
                    .padding(.bottom, 100.0)
                }
                // Automatic carousel engine mount point
                // Acts as a listener that executes the following code block every time the timer fires.
                .onReceive(carouselTimer) { _ in
                    autoScrollLogic()
                }
            }
            // Injects the custom top header view directly into the hardware safe area.
            // This allows the header to gracefully overlap the dynamic island or notch.rotationEffect
            .safeAreaInset(edge: .top) {
                HomeHeaderView(language: $appLanguage, showSearch: $showSearch)
            }
        }
    }
    
    @ViewBuilder
    private var searchBarSection: some View {
        // --- 1. Expandable Search Bar ---
        if showSearch {
            let bar = HStack {
                Image(systemName: "magnifyingglass").foregroundColor(.gray)
                TextField(appLanguage == "en" ? "Search for pasta, drinks..." : "Search for pasta, drinks...", text: $searchText)
            }
            .padding()
            .background(Color(UIColor.systemBackground))
            .cornerRadius(15.0)
            
            bar
                .padding(.horizontal)
                .padding(.top, 15.0)
                .transition(.move(edge: .top).combined(with: .opacity))
        }
    }
    
    @ViewBuilder
    private var chefChoiceSection: some View {
        // --- 2. Chef's Choice ---
        VStack(alignment: .leading, spacing: 15.0) {
            Text(appLanguage == "en" ? "Chef's Choice" : "Chef's Choice")
                .font(.title3.bold())
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                // Lazy loading means "rendering on demand," meaning the system only draws a card when you're about to scroll down to it. This is an extremely important memory optimization technique in graphics rendering.
                LazyHStack(spacing: 20.0) {
                    ForEach(recommendations) { item in
                        buildChefCard(for: item)
                    }
                }
                .padding(.horizontal, 20.0)
                // Apple's physical scrolling library transforms previously freely scrollable lists into a page-turning mode similar to TikTok or the photo album, where each swipe generates physical resistance and then "snap" precisely snaps to the center of the screen.
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned)
            .scrollPosition(id: $scrolledItemID)
            // A listener that monitors changes to 'scrolledItemID'.
            // It triggers an action every time the focused card changes.
            // { _, _ in } closure Old Value, new value
            .onChange(of: scrolledItemID) { _, _ in
                // Haptic Feedback: A soft tap when the carousel snaps to the next card
                UIImpactFeedbackGenerator(style: .soft).impactOccurred()
            }
        }
    }
    
    @ViewBuilder
    private var categorySection: some View {
        // --- 3. Categories  ---
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12.0) {
                // Custom component breakdown (CategoryPill): "Call for the template." You've written a template called CategoryPill in another file, which requires three parameters: text (name), icon, and whether it's currently selected (isSelected). `selectedCategory == section.name` is a conditional statement: if the currently selected category is exactly the same as the pill's name, it will light up.
                CategoryPill(name: "All", icon: "square.grid.2x2.fill", isSelected: selectedCategory == "All") {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    AudioServicesPlaySystemSound(1306)
                    withAnimation(.spring()) { selectedCategory = "All" }
                }
                ForEach(menu) { section in
                    CategoryPill(name: section.name, icon: "leaf.fill", isSelected: selectedCategory == section.name) {
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        AudioServicesPlaySystemSound(1306)
                        withAnimation(.spring()) { selectedCategory = section.name }
                    }
                }
            }
            .padding(.horizontal)
        }
    }
    
    @ViewBuilder
    private var menuListSection: some View {
        // --- 4. Main Menu List
        VStack(alignment: .leading, spacing: 15.0) {
            ForEach(menu) { section in
                if selectedCategory == "All" || selectedCategory == section.name {
                    VStack(alignment: .leading, spacing: 15.0) {
                        Text(section.name).font(.headline).foregroundColor(.secondary).padding(.horizontal)
                        ForEach(section.items) { item in
                            buildFoodCard(for: item)
                        }
                    }
                }
            }
        }
    }
    @ViewBuilder
        private func buildChefCard(for item: MenuItem) -> some View {
            // The NavigationLink must be the top-level container to ensure priority.
            NavigationLink(destination: ItemDetail(item: item)) {
                RecommendationCard(item: item)
                    // contentShape(Rectangle()) creates a solid tappable area across the entire card.
                    // This prevents the "invisible gap" issue during 3D rotations.
                    .contentShape(Rectangle())
            }
            // Using PlainButtonStyle prevents the system from adding unwanted highlight effects.
            .buttonStyle(PlainButtonStyle())
            // scrollTransition handles the 3D rotation, scaling, and opacity based on scroll position.
            .scrollTransition { content, phase in
                let rotationAngle = Angle.degrees(phase.value * 12.0)
                let scaleVal: CGFloat = phase.isIdentity ? 1.0 : 0.9
                let opacityVal: Double = phase.isIdentity ? 1.0 : 0.7
                
                return content
                    .rotation3DEffect(rotationAngle, axis: (x: 0.0, y: 1.0, z: 0.0))
                    .scaleEffect(scaleVal)
                    .opacity(opacityVal)
            }
            // Assigns a unique identity to this view instance.
            // This 'anchor' allows the autoScrollLogic to target this specific card
            // when updating the scrolledItemID state.
            .id(item.name)
        }

    
    @ViewBuilder
    private func buildFoodCard(for item: MenuItem) -> some View {
        NavigationLink(destination: ItemDetail(item: item)) {
            FoodCard(item: item)
                // Tell the system to capture the underlying pixels in real time and apply Gaussian blur.
            // .scrollTransition(.animated.threshold(.visible(0.5))) { content, phase in
                            //     content
                            //         .opacity(phase.isIdentity ? 1.0 : 0.5)
                            //         .scaleEffect(phase.isIdentity ? 1.0 : 0.9)
                            //         .blur(radius: phase.isIdentity ? 0.0 : 2.0)}

                            // COMPILER TIMEOUT EXPLANATION:
                            // The inline ternary operators above force the Swift compiler to infer the exact numeric type
                            // (Double, Float, or CGFloat) for multiple chained modifiers simultaneously.
                            // This creates hundreds of possible type combinations. The Simulator has enough time to solve this,
                            // but the Canvas preview engine times out after a few hundred milliseconds and throws a type-check error.
                            //
                            // CURRENT EXPLICIT VERSION (Canvas Safe):
                            // By extracting the logic into explicit variables with defined types (CGFloat, Double),
                            //  eliminate the compiler's need to guess, dropping the calculation time to near zero.
                .scrollTransition(.animated.threshold(.visible(0.5))) { content, phase in
                    let scaleVal: CGFloat = phase.isIdentity ? 1.0 : 0.9
                    let opacityVal: Double = phase.isIdentity ? 1.0 : 0.5
                    let blurVal: CGFloat = phase.isIdentity ? 0.0 : 2.0
                    
                    return content
                        .opacity(opacityVal)
                        .scaleEffect(scaleVal)
                        .blur(radius: blurVal)
                }
        }
        .buttonStyle(PlainButtonStyle())
    }

    private func autoScrollLogic() {
        let recs = recommendations
        
        // Safety check: Prevents the app from crashing if the recommendation list is empty.
        // This ensures that the following mathematical operations (like modulo) are not performed on zero.
        guard !recs.isEmpty else { return }
        
        // Attempts to find the exact array index of the currently displayed card.
        if let currentId = scrolledItemID, let currentIndex = recs.firstIndex(where: { $0.name == currentId }) {
            // Mathematical modulo operation. It adds 1 to the current index.
            // If the index reaches the total count, the modulo resets it to 0, creating an infinite loop.
            let nextIndex = (currentIndex + 1) % recs.count
            withAnimation(.easeInOut(duration: 0.6)) {
                scrolledItemID = recs[nextIndex].name
            }
        } else {
            // Fallback: If no card is currently tracked, forces the view to scroll to the very first item.
            withAnimation(.easeInOut(duration: 0.6)) {
                scrolledItemID = recs.first?.name
            }
        }
    }
}

#Preview {
    ContentView()
        .environment(Order())
        .environment(TabController()) // Added for iOS 17 fallback depending on your exact setup
}
