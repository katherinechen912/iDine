//
//  SplashView.swift
//  iDine
//

import SwiftUI

struct SplashView: View {
    @State private var scale = 1.1 // Start slightly zoomed in for "Ken Burns" effect
    
    var body: some View {
        ZStack {
            // 1. Large Hero Image
            Image("splash-food") // Place your food image in Assets
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .scaleEffect(scale)
                .ignoresSafeArea()
            
            // 2. Dark overlay for text readability
            Color.black.opacity(0.3).ignoresSafeArea()
            
            // 3. Branding
            VStack {
                Spacer()
                Text("Olive & Azure")
                    .font(.system(size: 40, weight: .bold, design: .serif))
                    .foregroundColor(.white)
                Text("CRAFTED WITH PASSION")
                    .font(.caption)
                    .tracking(4)
                    .foregroundColor(.white.opacity(0.8))
                Rectangle()
                    .frame(width: 40, height: 2)
                    .foregroundColor(.white)
                    .padding(.top, 10)
                Spacer().frame(height: 100)
            }
        }
        .onAppear {
            // Subtle zoom-out animation
            withAnimation(.easeOut(duration: 4.5)) {
                scale = 1.0
            }
        }
    }
}
