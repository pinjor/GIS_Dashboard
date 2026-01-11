# GIS Dashboard

A Flutter application for geographic information system visualization for vaccination data of Bangladesh.

## Setup Instructions

### Prerequisites

- Flutter SDK (3.8.1 or higher)
- Dart SDK
- Android Studio / VS Code
- Git

### Getting Started

1. **Clone the repository**

   ```bash
   git clone https://github.com/pinjor/GIS_Dashboard.git
   cd GIS_Dashboard
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Generate required files(NOW OPTIONAL, AS IT IS ALREADY IN THE REPO CURRENTLY)**

   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

   This generates the `.freezed.dart` and `.g.dart` files that are excluded from version control.

4. **Run the application**
   ```bash
   flutter run
   ```

### Development Notes

- Generated files (`.freezed.dart`, `.g.dart`) are gitignored
- Always run `build_runner` after pulling new changes that modify model files
- Use `dart run build_runner build --delete-conflicting-outputs` to resolve conflicts 
- which is already mentioned in step 3 above.
