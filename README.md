# Hira (The Quran Companion)

<p align="center">
  <img src="Resources/SharedAssets.xcassets/Images/Icon.imageset/Icon.png" alt="Hira App Icon" width="128" height="128">
</p>

Hira is a premium, high-fidelity Al-Quran companion for iOS, crafted with modern SwiftUI to provide a distraction-free, spiritual experience. Designed with a focus on sophisticated glassmorphic aesthetics, modular architecture, and cinematic animations, Hira bridges the gap between traditional scripture and modern digital life.

---

## 🌟 Key Features

### 📖 Quran Dashboard (Mushaf 2.0)
A comprehensive dashboard featuring advanced access patterns:
- **Unified Mushaf Engine**: High-fidelity page-by-page rendering (Mushaf) and optimized Ayah-list views with Tajweed-enabled Arabic text.
- **Contribution Heat-map**: Visualize your reading consistency with a contribution graph powered by high-fidelity activity tracking.
- **Reading Progress (Khatam)**: Visualize your journey through the 30 Juz with circular progress models and live sync stats.
- **Advanced Synchronization**: First-class integration with **Quran Foundation**, syncing bookmarks and reading sessions across devices.

### 🧭 Explore & Discovery
- **Cinematic Discovery**: Discover tailored stories, trending recitations, and religious articles with a sleek, discovery-focused search interface.
- **Mosque & Halal Finder**: Discover religious services and dining with high-fidelity maps and detailed accessibility information.

### 🤲 Deen & Identity
- **Global Identity (OAuth2)**: Secure, cross-platform synchronization using the Quran Foundation's decentralized identity service.
- **Simplified Zakat**: A streamlined approach to religious giving (Sadaqah, Infaq, Wakaf) with built-in calculators for Gold, Trade, and more.
- **Universal Morphing Search**: A premium, animated search header that adapts to your scrolling behavior across all modules.

---

## 🏗️ Technical Architecture

Hira follows a modern **Clean Architecture** combined with **MVVM-C** at the presentation layer, ensuring high testability and modularity:

- **Unified Networking**: A custom `FoundationClient` with automatic **401 retry-loops** and stampede prevention for refreshing OAuth tokens.
- **Domain Persistence**: Utilizing **SwiftData** for performant local caching and offline-first scripture access.
- **State Management**: Leveraging the `@Observable` macro and the latest **Observation** framework for reactive UI updates.
- **Clean Layers**:
  - **Presentation**: ViewModels + Coordinators (`AppRouter`).
  - **Domain**: Pure Swift Use Cases and Entities.
  - **Data**: Repository implementations, API clients, and Keychain-backed token managers.

---

## 🔐 Security & Identity

Hira implements a robust, industry-standard authentication system to protect user data:

- **OAuth2 + PKCE**: Implements **Proof Key for Code Exchange (S256)** to prevent authorization code interception on mobile devices.
- **Secure Persistence**: All sensitive credentials (Access Tokens, Refresh Tokens) are stored in the **Apple Keychain** using a custom `KeychainService`, ensuring data is encrypted and isolated.
- **Identity Provider**: Directly integrated with the **Quran Foundation OAuth2** service, enabling a unified account across the ecosystem.
- **Token Lifecycle**:
  - **Auto-Refresh**: Background silent refresh via Hira Backend for seamless session continuity.
  - **Stampede Prevention**: Thread-safe token acquisition during high-concurrency network requests.
  - **Secure Logout**: Revocation of tokens on the management server and immediate local keychain purging.

---

## 🛠️ Development Setup

1. **Prerequisites**: macOS 15.0+ and Xcode 16.0+.
2. **Environment**: Ensure `Info.plist` is configured with the following keys (see [Documentation](./hira-docs/api/external/quran-foundation.md)):
   - `QURAN_FOUNDATION_CLIENT_ID`
   - `QURAN_FOUNDATION_OAUTH_URL`
   - `QURAN_FOUNDATION_REDIRECT_URI` (Standard: `hira://oauth`)
3. **Setup**:
   ```bash
   git clone https://github.com/teamhira/hira-swiftui.git
   cd hira-swiftui
   open Hira.xcodeproj
   ```
4. **Running**: Choose a simulator (iOS 18+) or device and press `Cmd + R` to build and run.

---

## 📚 Documentation

Detailed technical specifications, API references, and visual catalogs are available in the [hira-docs](file:///Users/kira/Documents/Al-Quran/hira-docs/) directory:
- [**Visual Feature Catalog**](./hira-docs/screenshot/README.md)
- [**Quran Foundation Integration**](./hira-docs/api/external/quran-foundation.md)
- [**Project Roadmap**](./hira-docs/roadmap.md)

---

## 📜 License

Hira is a **Proprietary** software. All rights are reserved by the owner.

---

<p align="center">
  Developed with ❤️ for the Ummah.
</p>
