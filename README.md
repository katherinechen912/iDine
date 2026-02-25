🍽️ iDine: A Modern SwiftUI Culinary Experience
A sleek, high-performance food ordering application built entirely with SwiftUI, featuring a sophisticated Glassmorphism design language and dynamic theme management.

✨ The User Journey
1. Immersive Splash Experience
Custom Boot Animation: The journey begins with SplashView, featuring a smooth logo transition that sets the premium tone of the app.
<img width="1206" height="2622" alt="Simulator Screenshot - iPhone 17 Pro - 2026-02-25 at 15 05 24" src="https://github.com/user-attachments/assets/7926c7e9-cedc-4121-b17e-a2694abc8736" />
Dynamic Greeting: Personalized home screen headers that welcome users by name (e.g., "Welcome, Katherine!").

<img width="1206" height="2622" alt="Simulator Screenshot - iPhone 17 Pro - 2026-02-25 at 15 06 29" src="https://github.com/user-attachments/assets/158707e3-2fa5-4d1f-bc47-f4cb1fdc1bc3" />


2. Glassmorphism Design Language
Frosted Glass Components: Utilization of .ultraThinMaterial on FoodCard and ItemDetail components to create a layered, translucent aesthetic.
<img width="1206" height="2622" alt="Simulator Screenshot - iPhone 17 Pro - 2026-02-25 at 15 07 40" src="https://github.com/user-attachments/assets/607f2f4b-ba1f-4e80-937c-b4b9afff2212" />
<img width="1206" height="2622" alt="simulator_screenshot_0B9AA854-FF8D-433F-B8D9-C76A7C9C6366" src="https://github.com/user-attachments/assets/498c7b64-9032-4ce4-84eb-81e01a690d13" />

Subtle Glow Effects: Implementation of ultra-fine white overlays and soft shadows to achieve a "glowing edge" 3D effect.

3. Advanced Customization
Real-time Theme Engine: A global ThemeManager that allows users to switch primary color schemes instantly across all views.
<img width="1206" height="2622" alt="simulator_screenshot_BCFDEBAD-E420-4F5C-B1DD-497BCE7ACF1D" src="https://github.com/user-attachments/assets/744280fd-8ddc-4e72-b4f2-563569372ef7" />
<img width="1206" height="2622" alt="simulator_screenshot_BFAFFA42-0EFF-40A0-9A4E-D77FC32C7261" src="https://github.com/user-attachments/assets/8d79494f-89f1-44d1-a6d9-14294016f7cd" />
<img width="1206" height="2622" alt="simulator_screenshot_C0F42336-4DEA-4119-A080-90FAB46B507D" src="https://github.com/user-attachments/assets/32ef118b-6f13-4407-a4f7-d36b84fdc3a6" />


Localization Support: Full bilingual support (English and Chinese) driven by structured JSON data (menu_en.json and menu_zh.json).

🛠️ Technical Stack & Architecture
UI Framework: SwiftUI (Declarative UI).

Data Management: Decodable JSON for menu content and dietary restriction tags.

State Management: Optimized @State and @Binding flow for order tracking and navigation.

Version Control: Professional Git workflow with structured commit history.

📂 Project Structure
App & Navigation: iDineApp, SplashView, LoginView.

Feature Views: Home, Order History, Item Detail, and Checkout.
<img width="1206" height="2622" alt="Simulator Screenshot - iPhone 17 Pro - 2026-02-25 at 15 10 29" src="https://github.com/user-attachments/assets/16cd9bf8-5c2f-4938-9192-067d9ccf3493" />

<img width="1206" height="2622" alt="simulator_screenshot_DE398979-6137-4A8D-8A37-3B69E533461B" src="https://github.com/user-attachments/assets/82d86c3d-6bff-4802-aecd-6ae2588528af" />
<img width="1206" height="2622" alt="simulator_screenshot_949EC585-F0DA-4E79-BB0E-2CC42D861440" src="https://github.com/user-attachments/assets/3b33f705-623e-4500-b070-c7e1ebbeed6b" />
<img width="1206" height="2622" alt="simulator_screenshot_0200C516-E225-4649-A9C7-77154A84690A" src="https://github.com/user-attachments/assets/e9850bb3-8fa8-40f0-bb93-cc094e03d130" />

<img width="1206" height="2622" alt="simulator_screenshot_D28DC66E-32DD-4D78-8918-D32E0B0C8FD3" src="https://github.com/user-attachments/assets/400f874d-d99a-470c-83cd-a386b5fc0e28" />

<img width="1206" height="2622" alt="simulator_screenshot_81652FA3-D8A8-4862-B76D-186F74D80066" src="https://github.com/user-attachments/assets/51408106-89b4-4321-9f9b-030606ff55a6" />
<img width="1206" height="2622" alt="simulator_screenshot_F40C19DF-0D2D-48B1-BCA4-AFDBCF0D01C2" src="https://github.com/user-attachments/assets/6cdaf0fa-7695-4890-9271-e4488e5b47f4" />

<img width="1206" height="2622" alt="simulator_screenshot_739C2ACD-1490-48CA-8CE4-63E6D7D3D326" src="https://github.com/user-attachments/assets/6afa3dc7-f39a-46d3-843d-ab20a54819e0" />
<img width="1206" height="2622" alt="simulator_screenshot_73947DB1-98D2-4A01-844F-7C6CC67EB41C" src="https://github.com/user-attachments/assets/f7eae0e9-7b07-4fe9-9988-1c8230d31eec" />
<img width="1206" height="2622" alt="simulator_screenshot_7C9B290F-B568-4495-B3AE-1C8DAC4AFAFC" src="https://github.com/user-attachments/assets/846b964c-fb0c-4dac-a52e-7ace999257e0" />


UI Components: Reusable FoodCard and HomeHeaderView with custom styling.

🚀 How to Run
Clone this repository.

Open iDine.xcodeproj in Xcode 15+.

Select an iPhone Simulator and press Cmd + R.
