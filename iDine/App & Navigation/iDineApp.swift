// The "HQ" of the entire App. It handles four core jobs:
//
// 1. Global Data: Creates the Order object in memory and keeps it alive
//    for the App's entire lifetime. (@State ensures persistence.)
//
// 2. Traffic Control: An enum (AppRoute) defines three app states —
//    splash, login, and main. A switch statement acts as a traffic light,
//    showing the correct screen based on the current state.
//
// 3. Key Distribution: Passes the Order object down to child views via
//    .environment(order), so every subpage (home, detail, cart) can
//    read and write to the same shared data.
//
// 4. Auto-Navigation: onAppear starts a 2.5-second timer. The app launches
//    into .splash, then automatically transitions to .login with animation.


import SwiftUI

@main
struct iDineApp: App {
    // Global Data Objects
    @State private var order = Order()
    @State private var tabController = TabController()
    
    // Navigation states for the root of the app
    enum AppRoute {
        case splash
        case login
        case main
    }
    
    @State private var currentRoute: AppRoute = .splash

    var body: some Scene {
        WindowGroup {
            ZStack {
                switch currentRoute {
                case .splash:
                    SplashView()
                        .transition(.opacity)
                    
                case .login:
                    LoginView(onLoginSuccess: {
                        currentRoute = .main
                    })
                    .environment(order)
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal: .opacity
                    ))
                    
                case .main:
                    MainView()
                        .environment(order)
                        .environment(tabController)
                        .transition(.opacity)
                }
            }
            .onAppear {
                // Automatic transition from Splash to Login after 2.5 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    withAnimation(.easeInOut(duration: 0.8)) {
                        currentRoute = .login
                    }
                }
            }
        }
    }
}
