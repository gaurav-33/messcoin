
<p align="center">
  <img src="assets/images/mess-coin-logo-light.png#gh-light-mode-only" alt="MessCoin Logo" width="200"/>
  <img src="assets/images/mess-coin-logo-dark.png#gh-dark-mode-only" alt="MessCoin Logo" width="200"/>
</p>

<h1 align="center">MessCoin</h1>

<p align="center">
  A comprehensive mess management system for educational institutions, designed to streamline operations for administrators, staff, and students.
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.x-blue.svg" alt="Flutter Version">
  <img src="https://img.shields.io/badge/Dart-3.x-blue.svg" alt="Dart Version">
  <img src="https://img.shields.io/badge/License-Custom-red.svg" alt="License">
  <img src="https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web%20%7C%20Windows-green.svg" alt="Platform">
</p>

---

## 📜 Table of Contents

- [About the Project](#about-the-project)
- [Key Features](#-key-features)
- [Tech Stack & Architecture](#-tech-stack--architecture)
- [UI Showcase](#-ui-showcase)
- [Video Demonstration](#-video-demonstration)
- [Getting Started](#-getting-started)
- [Download for Testing](#-download-for-testing)
- [Test Credentials](#-test-credentials)
- [Project Structure](#-project-structure)
- [License](#-license)
- [Contact](#-contact)

---

## 🌟 About the Project

MessCoin is a modern, cross-platform application developed using Flutter, aimed at digitizing and revolutionizing the mess management systems within educational institutions. The project is designed to solve the inefficiencies of traditional, paper-based mess systems by providing a seamless, intuitive, and efficient digital platform for students, mess administrators, staff, and the hostel management committee (HMC).

This application replaces manual processes with a digital wallet system, real-time menu updates, a feedback mechanism, and comprehensive analytics, ensuring transparency and convenience for all stakeholders.

---

## ✨ Key Features

### For Students
- **Digital Wallet**: Secure and easy-to-use digital wallet for all mess-related transactions.
- **Menu on the Go**: View daily and weekly mess menus anytime, anywhere.
- **Transaction History**: Keep track of all your spending with a detailed purchase history.
- **Feedback System**: Rate meals and provide valuable feedback for continuous improvement.
- **Profile Management**: View and manage your personal profile.

### For Mess Admins
- **User Management**: Onboard and manage accounts for students and staff.
- **Menu Creation**: Easily create, update, and publish daily and weekly menus.
- **Analytics Dashboard**: Access insightful statistics and reports on sales, feedback, and user activity through interactive charts.
- **Real-time Monitoring**: Monitor mess activities and transactions in real-time.

### For Mess Staff
- **Effortless Payments**: Verify student payments quickly through the app.
- **Streamlined Operations**: Assist in daily mess operations with a dedicated interface.

### For HMC (Hostel Management Committee)
- **High-Level Oversight**: Access to comprehensive reports and analytics for strategic decision-making.
- **System Administration**: Oversee the entire mess system and manage administrative functions.

---

## 🛠️ Tech Stack & Architecture

MessCoin is built with a modern and scalable tech stack, ensuring a high-quality and maintainable codebase.

- **Framework**: **Flutter** (version 3.x)
- **Programming Language**: **Dart** (version 3.x)
- **Architecture**: Clean Architecture with a focus on separation of concerns.
- **State Management**: **GetX** - for reactive state management, dependency injection, and route management.
- **Networking**:
  - **Dio**: For robust and efficient handling of RESTful API calls.
  - **Socket.IO Client**: For real-time communication and instant updates.
- **Local Storage**: **Hive** - a lightweight and fast NoSQL database for local caching and offline support.
- **Push Notifications**: **OneSignal** - for sending real-time notifications to users.
- **UI/UX**:
  - **Flutter SVG**: For rendering high-quality vector graphics.
  - **fl_chart**: For creating beautiful and interactive charts in the admin dashboard.
- **Dependencies**:
  - `image_picker`: For selecting images from the gallery or camera.
  - `path_provider`: For accessing the device's file system.
  - `open_file`: For opening files on the device.
  - `file_saver`: For saving files to the device.

---

## 🖼️ UI Showcase

Here are some glimpses of the MessCoin application.


| Login Screen | Student Dashboard | Admin Dashboard |
| :---: | :---: | :---: |
| ![login](https://github.com/user-attachments/assets/a13631c6-b1af-4345-be4c-0e1d057d8457) | ![Student Dashboard](https://github.com/user-attachments/assets/97a86f9b-c920-4d86-b831-b2dab3169a6d) | ![Admin Dashboard](https://github.com/user-attachments/assets/23d13226-688b-467f-b712-951c356cc2f8) |

| Menu Page | Transaction History | Feedback Page |
| :---: | :---: | :---: |
| ![menu](https://github.com/user-attachments/assets/284ddd1b-dabb-4fa0-8041-6fe7062865bc) | ![history](https://github.com/user-attachments/assets/98672225-305d-40dc-9d2b-845a1ad44cda) | ![feedback](https://github.com/user-attachments/assets/0d9d29a6-0e83-4afb-89d5-0bd8fb49f874) |

---

## 🎥 Video Demonstration

A complete video walkthrough of the admin role, showcasing all the features from user management to analytics.


[**Watch the Admin Role Demo Here**](https://youtu.be/0JJSJ-SnTLQ)

---

## 🚀 Getting Started

To get a local copy up and running, follow these simple steps.

### Prerequisites

- **Flutter SDK**: Version 3.x or higher.
- **IDE**: Android Studio or VS Code with the Flutter plugin.
- **Backend Server**: Ensure the backend server for MessCoin is running and accessible.

### Installation

1. **Clone the repository:**
   ```sh
   git clone https://github.com/gaurav-33/messcoin.git
   cd messcoin
   ```

2. **Install dependencies:**
   ```sh
   flutter pub get
   ```

3. **Set up environment variables:**
   - Create a file named `.env` in the root of the project.
   - Copy the contents of `.env.example` into it and replace the placeholder values with your actual backend API URL and OneSignal App ID.
   ```
   # .env
   API_URL=http://your-api-endpoint.com/api
   ONESIGNAL_APP_ID=YOUR_ONESIGNAL_APP_ID
   ```

### Running the App

1. Make sure you have a device connected or an emulator running.
2. Run the app using the following command:
   ```sh
   flutter run
   ```

---

## 📥 Download for Testing

You can test the application by downloading the pre-built binaries for Android and Windows.

- [**Download for Android (.apk)**](https://drive.google.com/file/d/1iw_WesCWBdBGG9zSErj8f-QkG7XI94sK/view?usp=sharing)
- [**Download for Windows (.exe)**](https://drive.google.com/file/d/1ymOr4ByQ7C8LVaYQL1UAXyCgKetmz4be/view?usp=sharing)

---

## 👥 Test Credentials

Use the following credentials to test the application with different user roles.

| Role | Username | Password |
| :--- | :--- | :--- |
| **Student** | `student@test.com` | `password` |
| **Mess Admin** | `messadmin@test.com` | `password` |
| **HMC Admin** | `hmcadmin@test.com` | `password` |
| **Employee** | `employee@test.com` | `password` |

---

## 📂 Project Structure

The project follows a clean and scalable structure to ensure maintainability.

```
lib/
├── main.dart           # Application entry point
├── config/             # App-wide configuration (colors, themes, constants)
├── core/               # Core components (API services, models, routes, storage)
├── utils/              # Utility functions and extensions
├── student/            # Student-specific features (views, controllers)
├── mess_admin/         # Mess Admin-specific features
├── mess_staff/         # Mess Staff-specific features
└── hmc/                # HMC-specific features
```

---


## 📄 License

This project is licensed under the End-User License Agreement (EULA). See the `LICENSE` file for more details.

---

## 📧 Contact

Gaurav Suman - [gauravsuman2k24@gmail.com](gauravsuman2k24@gmail.com)

Project Link: [https://github.com/gaurav-33/messcoin](https://github.com/gaurav-33/messcoin)

