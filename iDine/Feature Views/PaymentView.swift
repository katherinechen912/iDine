//
//  PaymentView.swift
//  iDine
//
//  Created by Katherine on 2026/02/18.
//

import SwiftUI
import AudioToolbox

struct PaymentView: View {
    // MARK: - Step 1: Environment & State Management
    @Environment(Order.self) var order
    @Environment(TabController.self) var tabController
    
    // Added LOGIC: Determines if the view is for managing cards or for checking out.
    // If true, the "Pay Now" button is hidden.
    var isManagementMode: Bool = false
    
    @State private var themeManager = ThemeManager.shared
    @State private var isProcessing = false
    @State private var showSuccess = false
    
    var body: some View {
        ZStack {
            AppBackground()
            
            VStack(spacing: 25) {
                if !showSuccess {
                    paymentSelection
                } else {
                    successState
                }
            }
            .padding()
        }
        // Dynamically updates the title based on the mode and success state.
        .navigationTitle(showSuccess ? "" : (isManagementMode ? "Payment Methods" : "Payment"))
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: - Step 2: Payment UI Selection
    private var paymentSelection: some View {
        VStack(spacing: 30) {
            
            // --- 🌟 LOGIC CHANGE START ---
            // Only show the "Pay Now" button if we are NOT in management mode.
            if !isManagementMode {
                Button(action: processPayment) {
                    HStack {
                        if isProcessing {
                            ProgressView().tint(.white)
                        } else {
                            Text("Pay Now")
                            Image(systemName: "creditcard.fill")
                        }
                    }
                    .font(.title3.bold())
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(Color.black)
                    .clipShape(Capsule())
                }
                .buttonStyle(SqueezeButtonStyle())
                .disabled(isProcessing)
            }
            // --- 🌟 LOGIC CHANGE END ---
            
            // Options display section.
            VStack(alignment: .leading, spacing: 10) {
                Text("Saved Cards").font(.subheadline).foregroundColor(.secondary).padding(.leading, 5)
                VStack(spacing: 0) {
                    paymentRow(icon: "creditcard.fill", label: "Mastercard", detail: "**** 1234")
                    Divider().padding(.leading, 50)
                    paymentRow(icon: "creditcard", label: "Visa", detail: "**** 5678")
                    Divider().padding(.leading, 50)
                    paymentRow(icon: "applelogo", label: "Apple Pay", detail: "")
                }
                .background(.ultraThinMaterial)
                .cornerRadius(16)
            }
            
            // --- 🌟 ADDITION FOR MANAGEMENT MODE ---
            // Shows an "Add New Card" option if user is in their Profile settings.
            if isManagementMode {
                Button(action: { print("Navigate to Add Card Flow") }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Add New Card")
                    }
                    .font(.headline)
                    .foregroundColor(themeManager.currentTheme.primaryColor)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
                }
            }
            
            Spacer()
        }
        .padding(.top, 20)
    }
    
    // MARK: - Step 3: Success Visual State
    private var successState: some View {
        VStack(spacing: 30) {
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.3))
                    .frame(width: 160, height: 160)
                
                Image(systemName: "checkmark.seal.fill")
                    .font(.system(size: 90))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.2), radius: 10, y: 5)
                    .symbolEffect(.bounce.up.byLayer, options: .repeat(2), value: showSuccess)
            }
            .scaleEffect(showSuccess ? 1 : 0.5)
            .animation(.spring(response: 0.4, dampingFraction: 0.5), value: showSuccess)
            
            VStack(spacing: 10) {
                Text("Payment Successful")
                    .font(.title.bold())
                    .foregroundColor(.primary)
                Text("Your order has been placed.")
                    .foregroundColor(.secondary)
            }
        }
    }
    
    // MARK: - Step 4: Reusable Row Component (UI Consistency)
    private func paymentRow(icon: String, label: String, detail: String) -> some View {
        HStack(spacing: 15) {
            Image(systemName: icon).frame(width: 30)
            VStack(alignment: .leading) {
                Text(label).font(.body)
                Text(detail).font(.caption).foregroundColor(.secondary)
            }
            Spacer()
            Image(systemName: "circle").foregroundColor(.secondary)
        }
        .padding()
    }
    
    // MARK: - Step 5: Core Processing Logic
    private func processPayment() {
        order.finalizeOrder()
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        withAnimation { isProcessing = true }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation(.easeInOut) {
                isProcessing = false
                showSuccess = true
            }
            
            AudioServicesPlaySystemSound(1407)
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                order.items.removeAll()
            }
        }
    }
}

// MARK: - Step 6: Xcode Preview
#Preview {
    NavigationStack {
        // Previewing the Management Mode specifically.
        PaymentView(isManagementMode: true)
            .environment(Order())
            .environment(TabController())
    }
}
