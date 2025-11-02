# VangtiChai – Responsive Change Calculator

Bangladeshi Taka change calculator built with Flutter for the CSE 489 Assignment 1. Enter an amount with a custom keypad and instantly see the minimum number of notes required.

![Flutter](https://img.shields.io/badge/Flutter-3.13+-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.2+-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Material3](https://img.shields.io/badge/Material_Design-3-757575?style=for-the-badge&logo=material-design&logoColor=white)

---

## [![Watch on YouTube](https://img.shields.io/badge/Watch%20on-YouTube-red?logo=youtube&logoColor=white)](https://youtu.be/5aVbnxNVuM4)


## Preview
<img width="2940" height="1912" alt="Screenshot 2025-11-02 at 11 41 31 PM" src="https://github.com/user-attachments/assets/89572d6f-7b51-4ebb-b278-f8f2c1a43e4b" />

## Key Features

### Change Calculation
- Greedy denomination breakdown (500, 100, 50, 20, 10, 5, 2, 1) guarantees the minimum number of notes.
- Live recalculation whenever the keypad input changes.
- Uses `intl` formatting for a readable, locale-aware amount display.

### Custom Input Experience
- Numeric keypad purpose-built for the assignment with append, clear, and backspace actions.
- Grid layout automatically adapts button aspect ratio to fit the available space.
- Buttons leverage Material 3 tonal, filled, and outlined variants for strong affordance.

### Responsive Layout
- Portrait layout stacks amount display over side-by-side change summary and keypad panels.
- Landscape layout keeps both panels visible while anchoring the amount to the left.
- `LayoutBuilder` and `OrientationBuilder` drive dynamic flex ratios so the UI feels balanced on phones and tablets.

### Assignment-Friendly Codebase
- Consistent spacing, typography, and sizing constants avoid hard-coded magic numbers.
- State held in the widget tree to survive orientation changes without additional work.
- Single-file implementation keeps review straightforward for instructors.

---

## Tech Stack

- **Framework:** Flutter (Material 3, Widgets, LayoutBuilder)
- **Language:** Dart 3
- **Packages:** `intl` for number formatting
- **Tooling:** Flutter CLI, Dart formatter

---

## Screenshots

> Capture emulator screenshots (portrait and landscape, phone and tablet) and place them in `docs/images/`, then reference them here.
```
![Phone Portrait](docs/images/phone-portrait.png)
![Tablet Landscape](docs/images/tablet-landscape.png)
```

---

## Project Structure

```
vangti-chai-mobile-app/
├── lib/
│   └── main.dart        # Entire Flutter UI + business logic
├── android/             # Generated Android host
├── ios/                 # Generated iOS host
├── web/                 # Flutter web support
├── linux/, macos/, windows/
├── pubspec.yaml         # Dependencies and assets
└── README.md
```

---

## Getting Started

### Prerequisites
- Flutter SDK 3.13 or newer (`flutter --version`)
- Dart SDK (bundled with Flutter)
- Android Emulator or physical device (Pixel XL and Nexus 10 are assignment targets)

### Installation
```bash
git clone https://github.com/theHasanMahmud/Vangti-Chai-Android-App.git
cd "Vangti Chai Mobile App"
flutter pub get
```

### Run the App
```bash
flutter run
```

If the project was downloaded without platform folders, bootstrap them once:
```bash
flutter create .
```

---

## Testing and Quality Checks

```bash
flutter analyze        # Static analysis
flutter test           # Widget/unit tests (add as needed)
```

Manual validation: rotate between portrait/landscape, switch between phone and tablet devices, and confirm change breakdown accuracy for edge values (0, single-digit, max 9-digit input).

---

## How It Works

1. `_appendDigit`, `_clearAmount`, and `_backspace` mutate `_amount` while guarding against overflows and leading zeros.
2. `_noteBreakdown` recalculates the denomination counts on every build using integer division and subtraction.
3. `_ChangeSummary` lists each denomination with an opacity hint for unused notes.
4. `_NumericKeypad` renders an adaptive `GridView` so buttons scale smoothly across screen sizes.

---

## Roadmap

1. Add automated widget tests for keypad interactions and change output.
2. Localize copy in Bangla and English.
3. Layer accessibility hints for screen readers.
4. Persist recent amounts for quick reuse.

---

## Contact

Questions or feedback? Reach out at `hasanmahmudmajumder@gmail.com`.

---

If this project helps you, consider starring the repository and sharing it with classmates.
