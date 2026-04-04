# Contributing to Hira

Thank you for your interest in contributing to Hira! We welcome developers, designers, and translators to help improve this spiritual companion.

## 🚀 How to Contribute

Hira follows a structured workflow to maintain its premium quality and high-fidelity standards.

### 🐛 Reporting Bugs
*   Ensure the bug hasn't been reported yet by checking the **Issues** tab.
*   Provide a clear, descriptive title and a concise summary.
*   Include steps to reproduce, the context (OS version, device), and any relevant screenshots.

### ✨ Requesting Features
*   Open an **Issue** with the `enhancement` label.
*   Describe your vision for the feature and how it aligns with Hira's "minimalist glass" aesthetic.
*   Prototypes or designs in Figma/Sketch are highly encouraged.

### 🛠️ Pull Requests
1.  Fork the repository and create your feature branch: `git checkout -b feature/amazing-feature`.
2.  Adhere to the existing code style (SwiftUI 5.0+, Swift 6.0 compatibility).
3.  Ensure all views are responsive and support **Dark/Light modes**.
4.  Include **VoiceOver accessibility** support for all new components.
5.  If adding strings, ensure they are synchronized across all **4 localization files** (`en`, `id`, `ms`, `ar`).
6.  Commit your changes: `git commit -m 'Add some amazing feature'`.
7.  Push to the branch: `git push origin feature/amazing-feature`.
8.  Open a Pull Request with a detailed description of your changes.

---

### 🎨 Design Guidelines
Hira is built on a specific design system. Please ensure all new UI components:
- Use consistent `HiraCleanCard` styling.
- Maintain appropriate padding (typically 24pt for containers).
- Utilize the theme-aware colors provided in `ThemeModel`.
- Support **Dynamic Type** for accessibility.

---

### 🌏 Localization
When adding new features that require text:
- Add a unique, descriptive key (e.g., `quran_tab_juz`).
- Provide translations for English (`en`), Indonesian (`id`), Malay (`ms`), and Arabic (`ar`).
- Maintain the same vertical order of keys in all files to ensure easy comparison.

---

By contributing, you agree that your contributions will be licensed under the project's [MIT License](LICENSE).
