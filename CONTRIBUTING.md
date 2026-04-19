# Contributing to Hira

Thank you for your interest in contributing to Hira! We welcome developers, designers, and translators to help improve this spiritual companion.

## 🚀 How to Contribute

Hira follows a structured workflow to maintain its premium quality and high-fidelity standards.

### 🐛 Reporting Bugs
*   Check existing issues to avoid duplicates.
*   Include steps to reproduce, OS version, device, and relevant screenshots/logs.

### ✨ Requesting Features
*   Open an **Issue** with the `enhancement` label.
*   Ensure features align with Hira's "vibrant minimalist" aesthetic and utilize the established Design System.

### 🛠️ Pull Requests
1.  Fork and create a branch: `git checkout -b feature/amazing-feature`.
2.  **Code Style**: Adhere to Swift 6.0 concurrency standards and the Observation framework (`@Observable`).
3.  **Persistence**: Use **SwiftData** for any local persistence needs, ensuring language-aware caching.
4.  **Assets**: Follow the **PascalCase** naming convention for new images and icons. Place them in `SharedAssets.xcassets/Images`.
5.  **UI Consistency**: Ensure all views support **Dark/Light modes** and utilize `MorphingBackgroundView` for consistent aesthetics.
6.  **Accessibility**: Every interactive component MUST have localized accessibility labels and traits.
7.  **Localization**: Synchronize changes across all **4 localization files** (`en`, `id`, `ms`, `ar`).
8.  Push and open a PR with a clear summary and screenshots of UI changes.

---

### 🎨 Design Guidelines
Hira is built on a specific Design System. Please utilize the following tokens found in `Shared/DesignSystem`:
- **Typography**: Use `TextStyle` static properties (e.g., `.display`, `.body`).
- **Spacing**: Use `AppSpacing` (xs, sm, md, lg, xl).
- **Radius**: Use `AppRadius` (sm, md, lg).
- **Shadows**: Use `AppShadow` for elevation.
- **Motion**: Use `spring` or `interactiveSpring` for micro-animations to maintain the "alive" feel.

---

### 🌏 Localization
When adding new strings:
- Use unique, descriptive keys (e.g., `quran_ayah_bookmarked`).
- Provide translations for all supported languages.
- Keep the keys sorted alphabetically or in the same logical order across all files.

---

By contributing, you agree that your contributions will be owned by the project owner and released under its proprietary terms.
