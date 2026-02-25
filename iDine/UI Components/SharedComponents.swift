import SwiftUI

// MARK: -  1. Physical Button Interactions
// Defines a custom tactile response for buttons using spring physics.
struct SqueezeButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            // Shrinks the element to 92% size when pressed to mimic physical depression.
            .scaleEffect(configuration.isPressed ? 0.92 : 1.0)
            // Slightly dims the content to provide visual feedback during the tap.
            .opacity(configuration.isPressed ? 0.9 : 1.0)
            // A spring animation where response controls speed and damping controls friction.
            .animation(.spring(response: 0.35, dampingFraction: 0.55, blendDuration: 0.1), value: configuration.isPressed)
    }
}

// MARK: - 2. Content Visuals
// MARK: - UI Components
// A card component for the "Chef's Choice" carousel, featuring a bottom-heavy gradient for text legibility.
struct RecommendationCard: View {
    let item: MenuItem
    
    var body: some View {
        // ZStack overlays layers: Image -> Gradient -> Text.
        ZStack(alignment: .bottomLeading) {
            Image(item.mainImage)
                .resizable().scaledToFill()
                .frame(width: 200, height: 260).clipped()
            
            // Ensures white text remains legible even against bright food images.
            LinearGradient(colors: [.black.opacity(0.6), .clear], startPoint: .bottom, endPoint: .center)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.name).font(.headline).foregroundColor(.white).lineLimit(1)
                Text("$\(item.price)").font(.subheadline.bold()).foregroundColor(.white.opacity(0.9))
            }
            .padding()
        }
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.1), radius: 10, y: 5)
    }
}

// A toggleable category button with color-swap logic based on selection state.
struct CategoryPill: View {
    let name: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                Text(name)
            }
            .font(.system(size: 14, weight: .semibold))
            .padding(.vertical, 10).padding(.horizontal, 18)
            // Inverts background and text colors when the pill is selected.
            .background(isSelected ? Color.primary : Color(.systemBackground))
            .foregroundColor(isSelected ? Color(.systemBackground) : Color.primary)
            .clipShape(Capsule())
            .shadow(color: .black.opacity(0.05), radius: 3)
            // Scales up slightly when active to draw attention.
            .scaleEffect(isSelected ? 1.05 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: 3. Interactive Popups
// A 3D-styled notification popup using system materials for a premium look.
struct AddToCartPopup: View {
    let item: MenuItem
    let quantity: Int
    let gradient: LinearGradient
    
    var body: some View {
        VStack(spacing: 15) {
            Image(systemName: "checkmark.circle.fill").font(.system(size: 50)).foregroundStyle(gradient)
            Text("Added to Cart!").font(.headline)
            
            HStack {
                Image(item.mainImage).resizable().scaledToFill().frame(width: 60, height: 60).clipShape(Circle())
                VStack(alignment: .leading) {
                    Text(item.name).font(.subheadline.bold())
                    Text("x \(quantity)").font(.caption).foregroundColor(.secondary)
                }
            }
            .padding(12).background(Color(uiColor: .systemBackground)).cornerRadius(15)
        }
        .padding(25)
        // Applies the system frosted glass effect (blur + transparency).
        .background(.ultraThinMaterial)
        .cornerRadius(25)
        .shadow(radius: 20)
        // Tilts the popup 8 degrees on the X-axis for a spatial UI feel.
        .rotation3DEffect(Angle.degrees(8), axis: (x: 1, y: 0, z: 0))
    }
}

// MARK: - Navigation & Layouts
// The top navigation bar managing identity, language, and theme switching.
struct HomeHeaderView: View {
    @Binding var language: String
    @Binding var showSearch: Bool
    
    @Environment(Order.self) var order
    @Environment(TabController.self) var tabController
    @State private var themeManager = ThemeManager.shared
    
    var body: some View {
        HStack(spacing: 8) {
            Button { tabController.activeTab = .profileTab } label: {
                // User avatar with strictly fixed dimensions.
                Image(systemName: "person.crop.circle.fill")
                    .resizable().scaledToFit().frame(width: 36, height: 36)
                    .foregroundColor(themeManager.currentTheme.primaryColor)
            }
            
            VStack(alignment: .leading) {
                Text(language == "en" ? "Welcome," : "欢迎，").font(.caption).foregroundColor(.secondary)
                Text(order.userName.isEmpty ? "Katherine" : order.userName)
                    .font(.headline).lineLimit(1)
            }
            
            Spacer(minLength: 5)
            
            HStack(spacing: 4) {
                Button { withAnimation { showSearch.toggle() } } label: {
                    Image(systemName: "magnifyingglass").font(.system(size: 14, weight: .bold))
                        .frame(width: 28, height: 28)
                        .foregroundColor(themeManager.currentTheme.primaryColor)
                        .background(Color(UIColor.systemBackground).opacity(0.3)).clipShape(Circle())
                }
                
                // Language selection logic using local state binding.
                Button {
                    withAnimation(.spring()) { language = (language == "en" ? "zh" : "en") }
                } label: {
                    HStack(spacing: 4) {
                        Text("EN").fontWeight(language == "en" ? .bold : .medium)
                            .foregroundColor(language == "en" ? themeManager.currentTheme.primaryColor : .gray.opacity(0.5))
                        Text("CN").fontWeight(language == "zh" ? .bold : .medium)
                            .foregroundColor(language == "zh" ? themeManager.currentTheme.primaryColor : .gray.opacity(0.5))
                    }
                    .font(.system(size: 10))
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                    .padding(.horizontal, 8).frame(height: 28)
                    .background(Color(UIColor.systemBackground).opacity(0.3)).clipShape(Capsule())
                }
                
                // Cycles through theme modes defined in ThemeManager.
                Button {
                    withAnimation {
                        let modes = ThemeManager.AppThemeMode.allCases
                        let index = modes.firstIndex(of: themeManager.currentTheme)!
                        themeManager.currentTheme = modes[(index + 1) % modes.count]
                    }
                } label: {
                    HStack(spacing: 3) {
                        Image(systemName: "paintpalette.fill").font(.system(size: 10))
                        Text("Theme").font(.system(size: 10, weight: .bold))
                    }
                    .lineLimit(1).fixedSize() // .fixedSize()
                    .padding(.horizontal, 8).frame(height: 28)
                    .foregroundColor(themeManager.currentTheme.primaryColor)
                    .background(Color(UIColor.systemBackground).opacity(0.3)).clipShape(Capsule())
                    
                }
            }
        }
        .padding(.horizontal).padding(.vertical, 10)
    }
}

// MARK: - 4. Navigation & Environment

// Creates an animated multi-color aura using drifting blurred circles.
struct AppBackground: View {
    @State private var themeManager = ThemeManager.shared
    @State private var animate = false
    var colors: [Color] { themeManager.currentTheme.meshColors }
    
    var body: some View {
        ZStack {
            // Solid base layer from theme settings.
            // Modern iPhones reserve "safe areas" at the top (notch/Dynamic Island) and bottom (Home Indicator) where content won't be placed by default. ignoresSafeArea() tells the system to extend this view edge-to-edge across the entire physical screen
            themeManager.currentTheme.backgroundColor.ignoresSafeArea()
            
            // Dynamic Background Circle Logic
            // This specific circle creates a drifting glow in the bottom half of the screen.
            // GeometryReader measures the device screen to size the background elements.
            GeometryReader { proxy in
                ZStack {
                    // Circle 1 drifts top-left.
                    Circle()
                        .fill(colors[0].opacity(0.7))
                        .frame(width: proxy.size.width * 1.0)
                        // Turns the solid circle into a soft glow.
                        .blur(radius: 80)
                    
                    // X axis: Horizontal movement
                    // Y axis: Vertical movement
                    
                        .offset(x: animate ? -proxy.size.width * 0.2 : 0, y: animate ? -proxy.size.height * 0.2 : 0)
                    
                    // Circle 2 drifts right.
                    Circle()
                        .fill(colors[1].opacity(0.6))
                        .frame(width: proxy.size.width * 0.9)
                        .blur(radius: 70)
                        .offset(x: animate ? proxy.size.width * 0.3 : proxy.size.width * 0.1, y: animate ? proxy.size.height * 0.1 : -proxy.size.height * 0.1)
                    
                    // Circle 3 drifts bottom-right.
                    Circle()
                        .fill(colors[2].opacity(0.7))
                        .frame(width: proxy.size.width * 1.0)
                        .blur(radius: 90)
                        .offset(x: animate ? -proxy.size.width * 0.1 : proxy.size.width * 0.2, y: animate ? proxy.size.height * 0.4 : proxy.size.height * 0.2)
                }
            }
            .ignoresSafeArea()
        }
        .onAppear {
            // Triggers a looping 8-second drift animation upon appearing.
            withAnimation(.easeInOut(duration: 8).repeatForever(autoreverses: true)) { animate.toggle() }
        }
    }
}
