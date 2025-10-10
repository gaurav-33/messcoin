# MessCoin

<p align="center">
  <img src="assets/images/mess-coin-logo-light.png#gh-light-mode-only" alt="MessCoin Logo" width="200"/>
  <img src="assets/images/mess-coin-logo-dark.png#gh-dark-mode-only" alt="MessCoin Logo" width="200"/>
</p>

<p align="center">
  A comprehensive mess management system for educational institutions, designed to streamline operations for administrators, staff, and students.
</p>

---

## 📜 Table of Contents

- [About the Project](#about-the-project)
- [✨ Features](#-features)
- [📸 Screenshots](#-screenshots)
- [🛠️ Tech Stack](#-tech-stack)
- [📂 Project Structure](#-project-structure)
- [🚀 Getting Started](#-getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
  - [Running the App](#running-the-app)
- [👥 User Roles](#-user-roles)
- [🤝 Contributing](#-contributing)
- [📄 License](#-license)

---

## About the Project

MessCoin is a cross-platform mobile application built with Flutter that modernizes mess hall management. It replaces traditional paper-based systems with a digital wallet, real-time menu updates, feedback mechanisms, and detailed analytics, providing a seamless experience for everyone involved.

---

## ✨ Features

- **Digital Wallet:** Students can pay for meals using their "MessCoin" balance.
- **Menu Viewing:** Access daily and weekly mess menus.
- **Purchase History:** Track all transactions and view detailed history.
- **User Roles:** Dedicated interfaces and functionalities for Students, Mess Admins, Mess Staff, and HMC (Hostel Management Committee).
- **Feedback & Ratings:** Students can provide feedback and rate meals.
- **Profile Management:** Users can manage their profiles and view information.
- **Real-time Notifications:** Instant alerts for important updates powered by OneSignal and Socket.IO.
- **Data Visualization:** Admins can view statistics and reports through interactive charts.
- **Offline Support:** Key data is cached locally using Hive for offline access.

---

## 📸 Screenshots

*(Placeholder for application screenshots. Add images of the key screens here.)*

---

## 🛠️ Tech Stack

- **Framework:** [Flutter](https://flutter.dev/)
- **Language:** [Dart](https://dart.dev/)
- **State Management:** [GetX](https://pub.dev/packages/get)
- **Networking:**
  - [Dio](https://pub.dev/packages/dio) (for RESTful APIs)
  - [Socket.IO Client](https://pub.dev/packages/socket_io_client) (for real-time communication)
- **Local Storage:** [Hive](https://pub.dev/packages/hive)
- **Push Notifications:** [OneSignal](https://pub.dev/packages/onesignal_flutter)
- **UI/UX:**
  - [Flutter SVG](https://pub.dev/packages/flutter_svg) for vector graphics.
  - [fl_chart](https://pub.dev/packages/fl_chart) for charts and analytics.
- **Dependencies:**
  - `image_picker`: For selecting images from the gallery or camera.
  - `path_provider`: For finding commonly used locations on the filesystem.
  - `open_file`: For opening files from the device.
  - `file_saver`: For saving files to the device.

---

## 📂 Project Structure

The project is structured to separate concerns and maintain a clean codebase.

```
lib/
├── main.dart           # App entry point
├── config/             # App-wide configuration (colors, themes, constants)
├── core/               # Core components (API services, models, routes, storage)
├── utils/              # Utility functions and extensions
├── student/            # Student-specific features (views, controllers)
├── mess_admin/         # Mess Admin-specific features
├── mess_staff/         # Mess Staff-specific features
└── hmc/                # HMC-specific features
```

---

## 🚀 Getting Started

Follow these instructions to get a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

- **Flutter SDK:** Make sure you have the Flutter SDK installed. For installation instructions, see the [official Flutter documentation](https://flutter.dev/docs/get-started/install).
- **IDE:** An IDE like Android Studio or VS Code with the Flutter plugin.

### Installation

1.  **Clone the repository:**
    ```sh
    git clone https://github.com/your-username/messcoin.git
    cd messcoin
    ```

2.  **Install dependencies:**
    ```sh
    flutter pub get
    ```

3.  **Set up environment variables:**
    - Create a file named `.env` in the root of the project.
    - Copy the contents of `.env.example` into it and replace the placeholder values with your actual configuration.
    ```
    # .env
    API_URL=http://your-api-endpoint.com/api
    ONESIGNAL_APP_ID=YOUR_ONESIGNAL_APP_ID
    ```

### Running the App

1.  Make sure you have a device connected or an emulator running.
2.  Run the app using the following command:
    ```sh
    flutter run
    ```

---

## 👥 User Roles

- **Student:** The primary user who can view menus, make payments, see purchase history, and provide feedback.
- **Mess Staff:** Responsible for day-to-day operations, such as verifying payments or managing meal distribution.
- **Mess Admin:** Manages the entire mess system, including menus, user accounts, and viewing analytics.
- **HMC (Hostel Management Committee):** Oversees the mess operations and has access to high-level reports and administrative functions.

---

## 📄 License

This project is licensed under the terms of the `LICENSE` file.