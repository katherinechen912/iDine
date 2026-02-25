import SwiftUI
import AVFoundation
import AudioToolbox

// CardBoxStyle is a custom ViewModifier used as a template to give different sections
// a consistent card look with shadows, borders, and interactive 3D effects.
struct CardBoxStyle: ViewModifier {
    // isPressed tracks if the user's finger is currently down on the card.
    // It starts as 'false' because no interaction has happened yet.
    @State private var isPressed = false
    
    // The 'body' function is the factory that takes the original view (content)
    // and wraps it in the card's visual container.
    func body(content: Content) -> some View {
        content
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color.white.opacity(0.5))
                    .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 6)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(Color.white.opacity(0.4), lineWidth: 1)
            )
            .padding(.horizontal, 20)
            // scaleEffect creates the physical 'press' sensation.
            // When pressed, it shrinks to 98% size; when released, it springs back to 100%.
            .scaleEffect(isPressed ? 0.98 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.5), value: isPressed)
            .onTapGesture {
                // Triggers a light vibration (haptic feedback) on the phone.
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                isPressed = true
                // Brief delay to allow the shrink animation to be visible before bouncing back.
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    isPressed = false
                }
            }
    }
}

// Extension on View allows us to call .cardBoxStyle() directly instead of
// using the more verbose .modifier(CardBoxStyle()) syntax.
extension View {
    func cardBoxStyle() -> some View {
        modifier(CardBoxStyle())
    }
}

struct ItemDetail: View {
    let item: MenuItem
    @Environment(Order.self) var order
    @Environment(\.dismiss) var dismiss
    
    @State private var themeManager = ThemeManager.shared
    @State private var quantity: Int = 1
    @State private var showSuccessPopup = false
    @State private var animateHeart = false
    @State private var isSparkling = false
    
    // Mapping of dietary restriction codes to specific theme colors.
    let colors: [String: Color] = ["D": .red, "G": .blue, "N": .mint, "S": .yellow, "V": .green]
    
    var body: some View {
        ZStack {
            // Fills the entire screen background with the current theme color.
            themeManager.currentTheme.backgroundColor.ignoresSafeArea()
            
            VStack(spacing: 0) {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 25) {
                        
                        // The Hero Section contains the high-impact visual elements at the top.
                        heroSection
                        
                        // Card 1: Primary information like Name, Price, and Haptic heart button.
                        VStack(alignment: .leading, spacing: 16) {
                            HStack(alignment: .top) {
                                Text(item.name).font(.system(size: 26, weight: .bold, design: .serif))
                                Spacer()
                                Text("$\(item.price)").font(.system(size: 26, weight: .heavy)).foregroundColor(themeManager.currentTheme.primaryColor)
                            }
                            
                            HStack(spacing: 12) {
                                if !item.restrictions.isEmpty {
                                    HStack(spacing: 4) {
                                        ForEach(item.restrictions, id: \.self) { r in
                                            Text(r).font(.caption2.bold()).padding(6).background(colors[r, default: .black]).clipShape(Circle()).foregroundColor(.white)
                                        }
                                    }
                                    Text("|").foregroundColor(.gray.opacity(0.3))
                                }
                                
                                HStack(spacing: 8) {
                                    Label("\(item.calories) Kcal", systemImage: "flame.fill").foregroundColor(.red.opacity(0.8))
                                    Label("20m", systemImage: "clock.fill").foregroundColor(.blue.opacity(0.8))
                                }
                                .font(.caption.bold()).foregroundColor(.primary.opacity(0.6))
                            }
                            
                            Divider().padding(.vertical, 4)
                            
                            HStack {
                                Button {
                                    order.toggleFavorite(item)
                                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                    withAnimation(.spring) { animateHeart = true }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { animateHeart = false }
                                } label: {
                                    HStack {
                                        Image(systemName: order.isFavorite(item) ? "heart.fill" : "heart").foregroundColor(order.isFavorite(item) ? .red : .primary)
                                            .scaleEffect(animateHeart ? 1.4 : 1.0)
                                        Text(order.isFavorite(item) ? "Favorited" : "Favorite").font(.subheadline.bold()).foregroundColor(.primary)
                                    }
                                    .padding(.vertical, 8).padding(.horizontal, 16)
                                    .background(Color.primary.opacity(0.06))
                                    .clipShape(Capsule())
                                }
                                
                                Spacer()
                                
                                HStack(spacing: 4) {
                                    Image(systemName: "camera.fill").font(.caption).foregroundColor(.secondary)
                                    Text(item.photoCredit.isEmpty ? "iDine Kitchen" : item.photoCredit)
                                        .font(.caption2).foregroundColor(.secondary)
                                }
                            }
                        }
                        .cardBoxStyle()
                        
                        // Card 2: Horizontal list of ingredients with icons.
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Ingredients").font(.headline)
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(item.ingredients, id: \.name) { ingredient in
                                        HStack(spacing: 6) {
                                            Text(ingredient.icon)
                                            Text(ingredient.name)
                                        }
                                        .font(.subheadline.bold())
                                        .padding(.horizontal, 16).padding(.vertical, 10)
                                        .background(themeManager.currentTheme.primaryColor.opacity(0.12))
                                        .foregroundColor(themeManager.currentTheme.primaryColor)
                                        .clipShape(Capsule())
                                    }
                                }
                            }
                        }
                        .cardBoxStyle()
                        
                        // Card 3: Long-form text description of the dish.
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Description").font(.headline)
                            Text(item.description).font(.body).lineSpacing(6).foregroundColor(.primary.opacity(0.8))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .cardBoxStyle()
                        
                    }
                    .padding(.bottom, 130)
                }
                
                // Floating bar at the bottom containing quantity controls and checkout button.
                bottomBar
            }
            // Blurs the entire background when the "Added to Cart" popup appears.
            .blur(radius: showSuccessPopup ? 5 : 0)
            
            if showSuccessPopup {
                AddToCartPopup(item: item, quantity: quantity, gradient: themeManager.currentTheme.ctaGradient)
                    .transition(AnyTransition.scale.combined(with: AnyTransition.opacity)).zIndex(100)
            }
        }
    }
    
    // heroSection handles the decorative background and the parallax image logic.
    var heroSection: some View {
        GeometryReader { proxy in
            // minY determines how far the user has scrolled.
            // Negative values mean the user is scrolling down.
            let minY = proxy.frame(in: .global).minY
            
            // parallaxOffset creates depth by moving the image at half the scroll speed.
            let parallaxOffset = minY < 0 ? (minY / 2) : 0
            
            // blurAmount adds a soft focus effect to the image as it slides out of view.
            let blurAmount = minY < 0 ? abs(minY) / 20 : 0
            
            ZStack {
                // Laurels are used as an ornamental frame behind the food image.
                Group {
                    Image(systemName: "laurel.leading")
                        .font(.system(size: 130))
                        .foregroundColor(.green.opacity(0.4))
                        .rotationEffect(.degrees(-18))
                        .offset(x: -140, y: 50)

                    Image(systemName: "laurel.trailing")
                        .font(.system(size: 130))
                        .foregroundColor(.green.opacity(0.4))
                        .rotationEffect(.degrees(18))
                        .offset(x: 140, y: 50)
                }
                .zIndex(-2)
                
                // Sparkle particles with a looping animation that triggers on appear.
                Group {
                    Image(systemName: "sparkles").font(.system(size: 24)).foregroundColor(.orange.opacity(0.8)).offset(x: -120, y: -110).scaleEffect(isSparkling ? 0.8 : 1.1)
                    Image(systemName: "sparkles").font(.system(size: 28)).foregroundColor(.orange).offset(x: 120, y: -120).scaleEffect(isSparkling ? 1.2 : 0.9)
                }
                .zIndex(-1)
                .onAppear { withAnimation(.easeInOut(duration: 1.5).repeatForever()) { isSparkling = true } }
                
                // The central dish photo with a physical border and shadow.
                Image(item.mainImage)
                    .resizable().scaledToFill()
                    .frame(width: 280, height: 280)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 5))
                    .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 8)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .offset(y: parallaxOffset)
            .blur(radius: blurAmount)
        }
        .frame(height: 300)
    }
    
    // bottomBar manages the quantity calculation and final "Add to Cart" action.
    var bottomBar: some View {
        HStack(spacing: 20) {
            HStack(spacing: 15) {
                Button(action: { if quantity > 1 { quantity -= 1 } }) { Image(systemName: "minus").frame(width: 40, height: 40).background(Color.primary.opacity(0.05)).clipShape(Circle()).foregroundColor(.primary) }
                
                // contentTransition(.numericText) ensures digits roll like an odometer during changes.
                Text("\(quantity)").font(.title2.bold()).frame(minWidth: 25).contentTransition(.numericText()).animation(.snappy, value: quantity)
                
                Button(action: { quantity += 1 }) { Image(systemName: "plus").frame(width: 40, height: 40).background(Color.primary).clipShape(Circle()).foregroundColor(Color(.systemBackground)) }
            }
            .padding(8).background(Color(.systemBackground)).clipShape(Capsule()).shadow(color: .black.opacity(0.05), radius: 5)
            
            Button {
                // Loops through and adds the specified quantity of the item to the global cart.
                for _ in 0..<quantity { order.add(item: item) }
                UINotificationFeedbackGenerator().notificationOccurred(.success)
                withAnimation { showSuccessPopup = true }
                // Dismisses the detail page after a short delay so the user sees the success state.
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) { dismiss() }
            } label: {
                HStack {
                    Text("Add")
                    Spacer()
                    Text("$\(item.price * quantity)").contentTransition(.numericText()).animation(.snappy, value: quantity)
                }
                .font(.headline).foregroundColor(.white).frame(maxWidth: .infinity).padding()
                .background(themeManager.currentTheme.ctaGradient)
                .clipShape(Capsule()).shadow(color: themeManager.currentTheme.primaryColor.opacity(0.3), radius: 10, y: 5)
            }
            .buttonStyle(SqueezeButtonStyle())
        }
        .padding(20)
        .background(themeManager.currentTheme.backgroundColor.ignoresSafeArea())
        .shadow(color: .black.opacity(0.05), radius: 15, y: -5)
    }
}

#Preview {
    // This uses the centralized sample data defined in Menu.swift 
    NavigationStack {
        ItemDetail(item: MenuItem.example)
            // Provides a mock Order environment to ensure the "Add to Cart" and "Favorite" logic works in the Canvas.
            .environment(Order())
    }
}
