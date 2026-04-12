# Hira (The Quran Companion)

<p align="center">
  <img src="Resources/SharedAssets.xcassets/Images/Icon.imageset/Icon.png" alt="Hira App Icon" width="128" height="128">
</p>

Hira is a premium, high-fidelity Al-Quran companion for iOS, crafted with modern SwiftUI to provide a distraction-free, spiritual experience. Designed with a focus on sophisticated glassmorphic aesthetics, modular architecture, and cinematic animations, Hira offers a range of tools including a rich Quran dashboard, personalized discovery in the Explore tab, and integrated Charity management.

---

## 🌟 Key Features

### 📖 Quran Dashboard (Mushaf 2.0)
A comprehensive dashboard featuring advanced access patterns:
- **Page-Based Mushaf**: High-fidelity page-by-page rendering with Tajweed-enabled Arabic text.
- **Juz Progressive Tracking**: Visualize your journey through the 30 Juz with circular progress models and last-read statistics.
- **Advanced Persistence**: Offline-first experience using **SwiftData** for caching Surahs, translations, and recitations.
- **Detailed Bookmarking**: Save and categorize your spiritual insights with a full Arabic text preview for each bookmarked ayah.

### 🧭 Explore & Discovery
- **Cinematic Discovery**: Discover tailored stories, trending recitations, and religious articles with a sleek, discovery-focused search interface.
- **Dynamic Reels**: High-fidelity video recitation previews powered by Hira's modern media controller.

### 🤲 Charity & Deen
- **Simplified Zakat**: A streamlined approach to religious giving (Sadaqah, Infaq, Wakaf) with built-in calculators for Gold, Trade, and more.
- **Tarteel AI**: Voice-based recitation recognition and verification (Tarteel) powered by on-device processing.
- **Universal Morphing Search**: A premium, animated search header that adapts to your scrolling behavior.

---

## 🏗️ Technical Architecture

Hira is built using a modern **MVVM-C (Model-View-ViewModel-Coordinator)** architecture adapted for SwiftUI, leveraging the latest Apple frameworks:

- **Observation Framework**: Utilizing the `@Observable` macro for high-performance state management.
- **SwiftData Persistence**: Utilizing the latest Apple persistence framework for language-aware local caching and offline support.
- **Declarative Navigation**: Centralized `AppRouter` using `NavigationPath` for complex multi-module routing.
- **Premium UI/UX**: Custom design system including dynamic **Mesh Backgrounds**, Twitter-style splash transitions, and glassmorphic components.
- **Localization-First Approach**: Support for **4 core languages**: English (`en`), Indonesian (`id`), Malay (`ms`), and Arabic (`ar`).
- **Full Accessibility**: High-quality VoiceOver support with semantic grouping and localized descriptions.

---

## 🛠️ Development Setup

1. **Prerequisites**: macOS 15.0+ and Xcode 16.0+.
2. **Setup**:
   ```bash
   git clone https://github.com/teamhira/hira-swiftui.git
   cd hira-swiftui
   open Hira.xcodeproj
   ```
3. **Running**: Choose a simulator (iOS 18+) or device and press `Cmd + R` to build and run the application.

---

## 🌍 Supported Languages

| Language | Code | Status |
| :--- | :--- | :--- |
| English | `en` | ✅ Full Support |
| Indonesian | `id` | ✅ Full Support |
| Malay | `ms` | ✅ Full Support |
| Arabic | `ar` | ✅ Full Support |

---

## 📜 License

Hira is a **Proprietary** software. All rights are reserved by the owner. Unauthorized use, reproduction, or distribution is prohibited.

---

<p align="center">
  Developed with ❤️ for the Ummah.
</p>
