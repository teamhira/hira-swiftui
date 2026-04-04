# Hira (The Quran Companion)

<p align="center">
  <img src="Resources/AppIcon.png" alt="Hira App Icon" width="128" height="128">
</p>

Hira is a premium, high-fidelity Al-Quran companion for iOS, crafted with modern SwiftUI to provide a distraction-free, spiritual experience. Designed with a focus on sophisticated glassmorphic aesthetics and modular architecture, Hira offers a range of tools including a rich Quran dashboard, personalized discovery in the Explore tab, and integrated Charity management.

---

## 🌟 Key Features

### 📖 Quran Dashboard
A comprehensive dashboard featuring three primary access patterns:
- **Juz Progressive Tracking**: Visualize your journey through the 30 Juz with circular progress models and last-read statistics.
* **Detailed Bookmarking**: Save and categorize your spiritual insights with a full Arabic text preview for each bookmarked ayah.
- **Daily Reminders**: Beautifully curated ayah card designs for morning and midday reflections, with full social interaction capabilities.

### 🧭 Explore & Discovery
- **Cinematic Discovery**: Discover tailored stories, trending recitations, and religious articles with a sleek, discovery-focused search interface.
- **Dynamic Reels**: High-fidelity video recitation previews powered by Hira's modern media controller.

### 🤲 Charity Module
- **Simplified Zakat**: A streamlined approach to religious giving, featuring categories like Sedekah, Infaq, Wakaf, and more.
- **Urgent Causes**: Visual priority rows for community needs that require immediate attention.
- **Universal Morphing Search**: A premium, animated search header that adapts to your scrolling behavior.

---

## 🏗️ Technical Architecture

Hira is built using a modern **MVVM-C (Model-View-ViewModel-Coordinator)** architecture adapted for SwiftUI, leveraging the latest Apple frameworks:

- **Declarative Navigation**: Centralized `AppRouter` using `NavigationPath` for complex multi-module routing.
- **Observation Framework**: Utilizing the new `@Observable` macro for high-performance state management and minimal view updates.
- **Custom Design System**: A robust design system built on top of `HiraCleanCard` and `VisualEffectBlur`, ensuring a consistent, "premium glass" look across all modules.
- **Localization-First Approach**: Support for **4 core languages**: English (`en`), Indonesian (`id`), Malay (`ms`), and Arabic (`ar`), with standardized line-by-line synchronization across all `.strings` files.
- **Full Accessibility**: High-quality VoiceOver support using semantic grouping, accessibility traits, and localized descriptions for all interactive and informative components.

---

## 🛠️ Development Setup

1. **Prerequisites**: macOS 14.0+ and Xcode 15.0+.
2. **Setup**:
   ```bash
   git clone https://github.com/[username]/Hira.git
   cd Hira
   open Hira.xcodeproj
   ```
3. **Running**: Choose a simulator or device and press `Cmd + R` to build and run the application.

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

Hira is available under the **MIT License**. For more information, please see the [LICENSE](LICENSE) file.

---

<p align="center">
  Developed with ❤️ for the Ummah.
</p>
