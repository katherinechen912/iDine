🍽️ iDine: A Modern SwiftUI Culinary Experience
A sleek, high-performance food ordering application built entirely with SwiftUI, featuring a sophisticated Glassmorphism design language and dynamic theme management.

✨ The User Journey
1. Immersive Splash Experience
Custom Boot Animation: The journey begins with SplashView, featuring a smooth logo transition that sets the premium tone of the app.

Dynamic Greeting: Personalized home screen headers that welcome users by name (e.g., "Welcome, Katherine!").
<img width="1206" height="2622" alt="Simulator Screenshot - iPhone 17 Pro - 2026-02-25 at 15 05 24" src="https://github.com/user-attachments/assets/7926c7e9-cedc-4121-b17e-a2694abc8736" />

2. Glassmorphism Design Language
Frosted Glass Components: Utilization of .ultraThinMaterial on FoodCard and ItemDetail components to create a layered, translucent aesthetic.

Subtle Glow Effects: Implementation of ultra-fine white overlays and soft shadows to achieve a "glowing edge" 3D effect.

3. Advanced Customization
Real-time Theme Engine: A global ThemeManager that allows users to switch primary color schemes instantly across all views.

Localization Support: Full bilingual support (English and Chinese) driven by structured JSON data (menu_en.json and menu_zh.json).

🛠️ Technical Stack & Architecture
UI Framework: SwiftUI (Declarative UI).

Data Management: Decodable JSON for menu content and dietary restriction tags.

State Management: Optimized @State and @Binding flow for order tracking and navigation.

Version Control: Professional Git workflow with structured commit history.

📂 Project Structure
App & Navigation: iDineApp, SplashView, LoginView.

Feature Views: Home, Order History, Item Detail, and Checkout.

UI Components: Reusable FoodCard and HomeHeaderView with custom styling.

🚀 How to Run
Clone this repository.

Open iDine.xcodeproj in Xcode 15+.

Select an iPhone Simulator and press Cmd + R.
