//
//  ProfileView.swift
//  iDine
//
//  Design: Modular view structure to completely prevent SwiftUI compiler timeout errors.
//

import SwiftUI
import PhotosUI
import AuthenticationServices

// MARK: - Step 1: Main View Container
// This is the root structure that coordinates the different profile sections.
struct ProfileView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                // Renders the global animated aura background.
                AppBackground()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 35) {
                        // Calling modular sub-views to keep the main body lean.
                        ProfileAvatarSection()
                        ProfileAccountSection()
                        ProfilePreferencesSection()
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 100)
                }
            }
            .navigationTitle("Profile")
        }
    }
}

// MARK: - Step 2: User Identity Section (Avatar & Name)
// Handles profile photo selection and displays the user's name from the global state.
struct ProfileAvatarSection: View {
    @Environment(Order.self) var order
    @State private var themeManager = ThemeManager.shared
    @State private var avatarItem: PhotosPickerItem?
    @State private var avatarImage: Image?
    
    var body: some View {
        VStack(spacing: 12) {
            // PhotosPicker allows users to choose a custom image from their library.
            PhotosPicker(selection: $avatarItem, matching: .images) {
                ZStack(alignment: .bottomTrailing) {
                    if let img = avatarImage {
                        img
                            .resizable()
                            .scaledToFill()
                            .frame(width: 110, height: 110)
                            .clipShape(Circle())
                    } else {
                        // Default system icon using the theme's primary color.
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .frame(width: 110, height: 110)
                            .foregroundColor(themeManager.currentTheme.primaryColor)
                            .background(Color.primary.opacity(0.05))
                            .clipShape(Circle())
                    }
                    
                    Image(systemName: "camera.circle.fill")
                        .font(.title)
                        .foregroundColor(.white)
                        .background(themeManager.currentTheme.primaryColor.clipShape(Circle()))
                }
            }
            // Displays 'Katherine' as a fallback if no name is set in the Order.
            Text(order.userName.isEmpty ? "Katherine" : order.userName)
                .font(.title2.bold())
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Step 3: Account & Authentication Section
// Provides multiple login methods including Apple, Google, and Email.
struct ProfileAccountSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Create Account").font(.headline).padding(.horizontal)
            
            // 1. Native Apple Sign-In Button.
            SignInWithAppleButton(.continue) { request in
                print("Apple Login Requested")
            } onCompletion: { result in
                print("Apple Login Completed")
            }
            .signInWithAppleButtonStyle(.black)
            .frame(height: 50)
            .cornerRadius(12)
            .padding(.horizontal)
            
            // 2. Google Social Login Button.
            SocialLoginBtn(icon: "g.circle.fill", label: "Continue with Google", color: Color(hex: "DB4437")) {
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            }
            
            // 3. Traditional Email Registration.
            SocialLoginBtn(icon: "envelope.fill", label: "Sign up with Email", color: .secondary) {
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            }
        }
    }
}

// MARK: - Step 4: User Preferences & History Section
// Manages app settings like theme and language, plus links to order history and payments.
struct ProfilePreferencesSection: View {
    @AppStorage("appLanguage") private var appLanguage = "en"
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Preferences").font(.headline).padding(.horizontal)
            
            VStack(spacing: 0) {
                // Theme Selection: Iterates through enum cases to prevent rendering lag.
                HStack(spacing: 15) {
                    Text("Theme").foregroundColor(.primary)
                    Spacer()
                    ForEach(ThemeManager.AppThemeMode.allCases, id: \.rawValue) { mode in
                        ThemeCircleView(mode: mode)
                    }
                }
                .padding()
                
                Divider().padding(.leading, 15)
                
                // Language Toggle: Switches between English and Chinese.
                Button(action: {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    withAnimation { appLanguage = (appLanguage == "en" ? "zh" : "en") }
                }) {
                    HStack(spacing: 15) {
                        Image(systemName: "globe").foregroundColor(.primary.opacity(0.7)).frame(width: 20)
                        Text("Language").foregroundColor(.primary)
                        Spacer()
                        Text(appLanguage == "en" ? "English" : "中文").font(.subheadline).foregroundColor(.secondary)
                        Image(systemName: "chevron.right").font(.caption).foregroundColor(.secondary)
                    }
                    .padding().contentShape(Rectangle())
                }
                .buttonStyle(PlainButtonStyle())
                
                Divider().padding(.leading, 50)
                
                // Order History Integration: Navigates to the record of past purchases.
                NavigationLink(destination: OrderHistoryView()) {
                    HStack(spacing: 15) {
                        Image(systemName: "clock.fill")
                            .foregroundColor(.primary.opacity(0.7))
                            .frame(width: 20)
                        Text("Order History")
                            .foregroundColor(.primary)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .contentShape(Rectangle())
                }
                .buttonStyle(PlainButtonStyle())
                
                Divider().padding(.leading, 50)
                
                // Navigation link to the payment processing view.
                NavigationLink(destination: PaymentView(isManagementMode: true)) { // 🌟 Pass 'true' here
                    HStack(spacing: 15) {
                        Image(systemName: "creditcard.fill")
                            .foregroundColor(.primary.opacity(0.7))
                            .frame(width: 20)
                        Text("Payment Methods")
                            .foregroundColor(.primary)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .contentShape(Rectangle())
                }
                .buttonStyle(PlainButtonStyle())
            }
            .background(Color(UIColor.systemBackground))
            .cornerRadius(15)
            .padding(.horizontal)
            .shadow(color: .black.opacity(0.04), radius: 10, y: 5)
        }
    }
}

// MARK: - Step 5: Helper Components
// Specialized sub-views that handle specific UI interactions to reduce main view complexity.

struct ThemeCircleView: View {
    let mode: ThemeManager.AppThemeMode
    @State private var themeManager = ThemeManager.shared
    
    var body: some View {
        Circle()
            .fill(mode.swatchColor)
            .frame(width: 32, height: 32)
            .overlay(
                // Highlights the currently selected theme with a thicker stroke.
                Circle().stroke(Color.primary.opacity(0.2), lineWidth: themeManager.currentTheme == mode ? 3 : 1)
            )
            .onTapGesture {
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                withAnimation(.spring) {
                    themeManager.currentTheme = mode
                }
            }
    }
}

// MARK: - Step 6: Social Login Button Template
// This reusable structure acts as a "factory" to generate consistent buttons
// for third-party authentication providers like Google or Email.
// Button template factory

struct SocialLoginBtn: View {
    let icon: String
    let label: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                Text(label).fontWeight(.semibold)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(color)
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.horizontal)
    }
}

#Preview {
    ProfileView()
        .environment(Order())
        .environment(TabController())
}
