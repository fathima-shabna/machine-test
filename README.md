# Noviindus Ayurvedic Centre Patient Management

A professional Flutter application designed for an Ayurvedic Centre to manage patient data, track treatments, and generate high-quality PDF receipts. Built with a focus on clean architecture, performance, and a premium user experience.

## 🚀 Key Features

- **User Authentication**: Secure token-based login system.
- **Patient Dashboard**: Real-time patient listing with pull-to-refresh functionality.
- **Dynamic Registration**: Step-by-step patient registration with dynamic treatment and branch selection.
- **PDF Receipt Generation**: Automatically generate downloadable and printable receipts matching the Figma design upon successful registration.
- **Clean Architecture**: Organized codebase using the Provider pattern for efficient state management.
- **Robust Networking**: Dio-powered API integration with custom interceptors for token management and logging.

## 🛠️ Tech Stack

- **Framework**: [Flutter](https://flutter.dev/)
- **State Management**: [Provider](https://pub.dev/packages/provider)
- **Networking**: [Dio](https://pub.dev/packages/dio)
- **PDF Generation**: [pdf](https://pub.dev/packages/pdf) & [printing](https://pub.dev/packages/printing)
- **Local Storage**: [shared_preferences](https://pub.dev/packages/shared_preferences)
- **Formatting**: [intl](https://pub.dev/packages/intl)

## 📁 Project Structure

```text
lib/
├── controllers/    # ChangeNotifier classes for business logic & state
├── models/         # Data models and JSON serialization logic
├── services/        # API services and PDF generation logic
├── ui/              # Flutter screens and reusable components
└── main.dart       # App entry point and Provider initialization
```

## ⚙️ Installation & Setup

1. **Clone the repository**:
   ```bash
   git clone https://github.com/fathima-shabna/machine-test.git
   ```

2. **Navigate to the project directory**:
   ```bash
   cd noviindus_test
   ```

3. **Install dependencies**:
   ```bash
   flutter pub get
   ```

4. **Run the application**:
   ```bash
   flutter run
   ```

## 📝 API Requirements

- **Base URL**: `https://flutter-amr.noviindus.in/api/`
- **Authentication**: All protected endpoints require a Bearer Token obtained during login.

## 📸 Screenshots

*(Add your screenshots here to showcase the premium UI!)*

---
Developed as a part of the Noviindus Flutter Machine Test.
