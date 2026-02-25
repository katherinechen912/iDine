//
//  LoginView.swift
//  iDine
//

import SwiftUI

struct LoginView: View {
    // Accesses the global order data to save the user's name upon login.
    @Environment(Order.self) var order
    
    // A callback closure that notifies the parent view (iDineApp) when the login is successful.
    var onLoginSuccess: () -> Void
    
    // Local state variables to capture user input before finalizing the login.
    @State private var nameInput = ""
    @State private var tableSize = 2
    
    // Connects to the centralized ThemeManager to ensure UI colors stay synchronized across all screens.
    @State private var themeManager = ThemeManager.shared
    
    var body: some View {
        // ZStack allows layering the dynamic background behind the interactive content.
        ZStack {
            // Displays the animated mesh gradient background defined in the DesignSystem.
            AppBackground()
            
            VStack(spacing: 30) {
                // Branding Section: Displays the app's visual identity.
                Image("app-logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .clipShape(RoundedRectangle(cornerRadius: 25))
                    .shadow(radius: 10)
                
                VStack(spacing: 8) {
                    Text("Olive & Azure")
                        .font(.system(size: 32, weight: .bold, design: .serif))
                }
                
                // Input Section: Captures the user's name and party size using frosted glass styling.
                VStack(spacing: 20) {
                    TextField("Enter your name", text: $nameInput)
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(12)
                    
                    HStack {
                        Text("Table for how many?").foregroundColor(.secondary)
                        Spacer()
                        
                        // This component creates a selection menu for choosing the number of people at the table.
                        // Picker("Table Size", selection: $tableSize)
                        Picker("Table Size", selection: $tableSize) {
                            // A loop that generates 10 individual options from 1 to 10.
                            ForEach(1...10, id: \.self) { num in
                                
                                // Displays the number as text to the user.
                                // The .tag connects the visual text to the actual numerical value stored in $tableSize.
                                Text("\(num)").tag(num)
                            }
                        }
                        
                        // Defines the visual appearance as a pop-up menu instead of a scrolling wheel.
                        .pickerStyle(.menu)
                        .padding(.horizontal, 10)
                        .background(Color.primary.opacity(0.05))
                        .cornerRadius(8)
                    }
                }
                .padding(.horizontal, 40)
                
                // CTA (Call To Action) Button: The primary interactive element to enter the app.
                Button {
                    // Saves the user's name to the global state if provided.
                    if !nameInput.isEmpty { order.userName = nameInput }
                    // Triggers the transition to the main application interface.
                    withAnimation { onLoginSuccess() }
                } label: {
                    Text("Confirm")
                        .font(.headline).foregroundColor(.white)
                        .frame(maxWidth: .infinity).padding()
                        // Uses the theme-specific gradient for high visual impact.
                        .background(themeManager.currentTheme.ctaGradient)
                        .clipShape(Capsule())
                }
                .padding(.horizontal, 40)
                // Applies a physical "squish" animation from the SharedComponents library.
                .buttonStyle(SqueezeButtonStyle())
                
                Spacer()
            }
            .padding(.top, 60)
        }
    }
}

#Preview {
    // Provides a mock environment to render the LoginView inside Xcode's Canvas.
    LoginView(onLoginSuccess: {
        print("Login Success Preview Triggered")
    })
    .environment(Order())
}
