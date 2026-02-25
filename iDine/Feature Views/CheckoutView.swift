//  CheckoutView.swift
//  iDine
//  Created by Katherine on 2026/02/18.

import SwiftUI
import AVFoundation

struct CheckoutView: View {

    // This is the global data store. It keeps track of the food items you added
    // to your cart and the total money owed across the entire app.
    // Global shopping cart
    @Environment(Order.self) var order
    
    // This allows the code to tell the current screen to close/go back to the previous page.
    @Environment(\.dismiss) var dismiss
    
    // The controller for the bottom 4 tab icons; used here to force a jump back to the Home tab.
    @Environment(TabController.self) private var tabController
    
    
    
    /// @State variables (such as paymentType, tipAmount). These are the user's "temporary choices" on this page. They don't need to be stored in the global system; they only need to remain on this page for real-time total price calculation or to be passed to the next step when the user clicks confirm.
    ///
    // This connects to your ThemeManager to get the current colors (Spring, Midnight, etc.).
    @State private var themeManager = ThemeManager.shared
    
    // These variables store the choices the user makes on this screen.
    let paymentTypes = ["Cash", "Credit Card", "Debit Card", "iDine Points"]
    @State private var paymentType = "Cash"
    
    @State private var addLoyaltyDetails = false
    @State private var loyaltyNumber = ""
    
    let tipAmounts = [10, 15, 20, 25, 0]
    @State private var tipAmount = 15
    
    let pickupTimes = ["Now", "Tonight", "Tomorrow Morning"]
    @State private var pickupTime = "Now"
    
    // This calculates the final price by adding the tip percentage to the order total.
    var totalPrice: String {
        let total = Double(order.total)
        // Math: Total Price = Base Price + (Base Price * Tip Percentage / 100)
        let tipValue = total / 100 * Double(tipAmount)
        return (total + tipValue).formatted(.currency(code: "USD"))
    }

    var body: some View {
        ZStack {
            // Displays the moving mesh gradient background.
            AppBackground()
            
            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: 20) {
                        
                        // Card 1: Payment and Loyalty.
                        VStack(spacing: 15) {
                            // We use HStack here to make sure the label text is visible
                            // next to the selection menu.
                            HStack {
                                Text("Payment Method").foregroundColor(.secondary)
                                Spacer()
                                Picker("Payment Method", selection: $paymentType) {
                                    ForEach(paymentTypes, id: \.self) { Text($0) }
                                }
                            }
                            
                            Divider()
                            
                            Toggle("Add iDine loyalty card", isOn: $addLoyaltyDetails)
                            
                            if addLoyaltyDetails {
                                TextField("Enter your iDine ID", text: $loyaltyNumber)
                            }
                        }
                        .padding()
                        .background(.ultraThinMaterial) // The frosted glass effect.
                        .cornerRadius(16)
                        
                        // Card 2: Tip Section.
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Add a tip?").font(.subheadline).foregroundColor(.secondary)
                            Picker("Percentage:", selection: $tipAmount) {
                                ForEach(tipAmounts, id: \.self) { Text("\($0)%") }
                            }
                            .pickerStyle(.segmented)
                        }
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(16)
                        
                        // Card 3: Pickup Time.
                        VStack(spacing: 15) {
                            // Using HStack again to ensure the "Pickup Time" label is not hidden.
                            HStack {
                                Text("Pickup Time").foregroundColor(.secondary)
                                Spacer()
                                Picker("Pickup Time", selection: $pickupTime) {
                                    ForEach(pickupTimes, id: \.self) { Text($0) }
                                }
                            }
                        }
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(16)
                    }
                    .padding()
                }
                
                // This button moves the user to the PaymentView screen.
                NavigationLink(destination: PaymentView()) {
                    HStack {
                        Text("Confirm Order")
                        Spacer()
                        // Animation: Treats numbers as individual rolling digits instead of fading text.
                        Text(totalPrice).contentTransition(.numericText())
                    }
                    .font(.headline)
                    // Ternary Operator Condition ? Result A : Result B
                    .foregroundColor(themeManager.currentTheme == .midnight ? .black : .white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(themeManager.currentTheme.ctaGradient)
                    .clipShape(Capsule())
                    .shadow(color: themeManager.currentTheme.primaryColor.opacity(0.3), radius: 10, y: 5)
                }
                
                // custom styles in SharedComponents.swift
                // Adds the physical "squish" effect when tapped.
                .buttonStyle(SqueezeButtonStyle())
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
                .padding(.top, 10)
            }
        }
        
        // Signboard: Sets the title text displayed at the very top of the navigation bar.
        .navigationTitle("Checkout")
        
        // Observer: Detects when the cart is cleared (after payment) and triggers the jump back to the main Menu.
        // Payment successful -> Shopping cart cleared -> Automatically scroll back to home page.
        .onChange(of: order.items.isEmpty) { oldValue, newValue in
            if newValue == true {
                tabController.switchTab(to: .menuTab)
            }
        }
    }
}
// Preview module with 'Mock' environments to prevent Canvas crash.
#Preview {
    NavigationStack {
        CheckoutView()
            .environment(Order())
            .environment(TabController())
    }
}
