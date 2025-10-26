# VangtiChai

Responsive Flutter implementation of the CSE 489 Assignment 1 change-calculator app. The app lets users enter an amount using a custom numeric keypad and shows the minimum number of Bangladeshi Taka notes (500, 100, 50, 20, 10, 5, 2, 1) required to make that amount.

## Project Highlights
- Custom keypad built from scratch; supports append, clear, and backspace interactions.
- Responsive layouts tailored for phones and tablets in both portrait and landscape orientations using `OrientationBuilder`, `LayoutBuilder`, and adaptive flex ratios.
- State preserved automatically when rotating the device, because the amount and change breakdown live in the widget's `State`.
- Consistent spacing and typography expressed as Dart constants (mirrors the "no hard-coded XML values" requirement).
- Material 3 styling with tonal/elevated buttons for better affordance.

## Getting Started
1. Ensure you have the Flutter SDK (3.13 or newer recommended) installed and an emulator/device available.
2. From the project root:
   ```bash
   flutter pub get
   flutter run
   ```
3. Choose an emulator that matches the assignment targets:
   - Pixel XL (411x731 dp) - portrait and landscape.
   - Nexus 10 tablet (800x1280 dp) - portrait and landscape.

If you created this directory without running `flutter create`, run the following once to add missing platform folders before executing the steps above:
```bash
flutter create .
```

## Testing Notes
- Designed against the Pixel XL and Nexus 10 size classes using Flutter's layout tools.
- Please verify on real emulators/devices as part of submission; this environment does not include the Android emulator, so runtime validation could not be executed here.
- Other helpful checks: `flutter analyze` and `flutter test`.

## Implementation Overview
- `lib/main.dart`: Contains the entire app.
  - `_VangtiChaiHomeState` handles keypad input, state persistence, and change calculation.
  - `_ChangeSummary` renders the note table with subtle opacity changes when counts are zero.
  - `_NumericKeypad` lays out eleven buttons in a 4x3 grid using custom stateless widgets.
  - Layout logic uses a portrait column with side-by-side panels, and a landscape row with an embedded column to satisfy the "slightly altered" requirement.
- The change calculation performs integer division for each denomination in descending order, guaranteeing the minimal number of notes.
- Formatting uses the `intl` package (`NumberFormat.decimalPattern`) for a readable amount display.

## Future Enhancements
1. Add widget tests for keypad input and change-calculation edge cases.
2. Localize the UI (e.g., Bangla strings, `NumberFormat` locale).
3. Provide accessibility hints for VoiceOver/TalkBack users.
