
# My Stash

A **Flutter-based personal password management application** designed for securely storing and managing passwords. This app ensures the highest security standards by integrating encryption, secure local storage, and Firebase backend with Google authentication.

## Features

- **Encryption and Decryption**: Utilizes the [PointyCastle](https://pub.dev/packages/pointycastle) library for **AES-GCM encryption**, ensuring secure password storage and retrieval.
- **Local Secure Storage**: Keeps sensitive data securely stored locally when offline.
- **Cloud Sync with Firebase**: Synchronizes passwords to a Firebase backend for backup and accessibility.
- **Google Authentication**: Simplifies login with **Google Auth** integration.
- **User-Friendly Interface**: Intuitive and easy-to-navigate design for seamless password management.

---

## Tech Stack

- **Frontend**: [Flutter](https://flutter.dev/)
- **Encryption**: [PointyCastle (AES-GCM)](https://pub.dev/packages/pointycastle)
- **Backend**: [Firebase Authentication](https://firebase.google.com/products/auth), [Firebase Firestore](https://firebase.google.com/products/firestore)
- **Secure Storage**: [Flutter Secure Storage](https://pub.dev/packages/flutter_secure_storage)

---

## Setup

### Prerequisites

- Install [Flutter](https://flutter.dev/docs/get-started/install).
- Set up Firebase for your project. ([Firebase setup guide](https://firebase.google.com/docs/flutter/setup))

### Steps

1. **Clone the repository**:
   ```bash
   git clone <repository_url>
   cd my_stash
   ```
2. **Install Dependencies**
  ```bash
  flutter pub get
  ```
3. **Setup Firebase**
  Use this [Firebase Setup](https://firebase.google.com/docs/flutter/setup?hl=en&authuser=0&platform=android)

##Security Implementation
###AES-GCM Encryption

- Passwords are encrypted using the AES-GCM mode from the PointyCastle package.
Each password has a unique initialization vector (IV) to ensure robust encryption.
Local Secure Storage

- Sensitive data is stored locally using Flutter Secure Storage for offline access.
All data is encrypted at rest.
Cloud Storage

- Passwords are securely synced to Firebase Firestore, ensuring encrypted data transfer and backup.
Authentication

- Only authorized users can access their data using Firebase Google Authentication.

##Screenshot
[screenshot](screenshot/ss1.jpeg)
[screenshot](screenshot/ss2.jpeg)
