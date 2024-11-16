# NBA Highlights - Flutter Project


A cross-platform mobile application built with Flutter for viewing NBA highlights and categories. The app fetches data from Firebase Realtime Database, displays categories as thumbnails, and allows users to view details of each category. Additionally, it includes text-to-speech functionality for accessibility.

## Requirements
Before you begin setting up the project, ensure you have the following tools and services installed:

Flutter SDK
Firebase Project
Android Studio (or Visual Studio Code)
Xcode for iOS development (if targeting iOS)
Setup Instructions

1. Clone the Repository
First, clone this repository to your local machine:
**git clone https://github.com/shivaniiRana/NBA.git**

2. Install Flutter SDK
If you haven't already, install Flutter SDK by following the Flutter installation guide.
Once installed, ensure Flutter is correctly set up.

3. Install Dependencies
In the root directory of the project, run the following command to install the required packages:

bash->Copy command: 
**flutter pub get**

This will fetch all the necessary dependencies listed in the pubspec.yaml file.

4. Firebase Setup
4.1. Create a Firebase Project
If you haven't already, create a Firebase project in the Firebase Console.

4.2. Add Firebase to Your Flutter App
Follow these steps to integrate Firebase with your Flutter app:

For Android:

In the Firebase Console, go to Project settings and click on the Android icon to add your Android app.
Download the google-services.json file.

Place the **google-services.json** file in the android/app directory.
Modify your android/build.gradle and android/app/build.gradle files as described in the Firebase Flutter Setup Guide.

For iOS:

In the Firebase Console, go to Project settings and click on the iOS icon to add your iOS app.
Download the **GoogleService-Info.plist**
 file.
Place the GoogleService-Info.plist file in the ios/Runner directory.
Follow the setup steps in the Firebase Flutter Setup Guide for iOS.


5. Running the App
Once all dependencies are installed and Firebase is set up, you can run the app on an Android/iOS emulator or a physical device.

To run on an Android device or emulator:
bash->
Copy command:
**flutter run**

To run on an iOS device or emulator:
bash->Copy code:
**flutter run**
Make sure you have an Android emulator or iOS simulator running.


## Features 
The app has the following features:

- Splash Screen: Displays an introductory screen with the app logo while the app initializes.
- Landing Page (Categories Screen): Displays a grid of categories fetched from Firebase, where each category has a thumbnail image and name.
- Category Details Screen: Displays detailed information about a selected category, including images, descriptions, and a text-to-speech feature.

## Project Structure
This Flutter project follows a modular and maintainable structure. Below is a brief overview of the directory and files: **(please refer Raw text for structure)**

bash
Copy code
nba-highlights/
├── assets/
│   ├── images/
│   │   └── nbalogo.png   # Splash screen logo
│   │   └── nba.png       # App icon
├── lib/
│   ├── main.dart         # Entry point of the app
│   ├── home_page.dart    # Landing page with categories grid
│   ├── category_screen.dart # Screen to show category details
│   └── splash_screen.dart  # Splash screen
├── pubspec.yaml          # Project dependencies
└── README.md             # Project setup instructions (this file)
lib/main.dart
The entry point of the app, which initializes Firebase and displays the splash screen.

lib/home_page.dart
Displays the landing page with a grid of categories fetched from Firebase.

lib/category_screen.dart
Displays detailed information for each category, including images, descriptions, and text-to-speech functionality.

lib/splash_screen.dart
Shows a splash screen while the app is loading.


## Libraries

Dependencies
The app uses the following dependencies:

flutter: The main framework for building cross-platform applications.
firebase_core: Required for Firebase initialization.
firebase_auth: For Firebase authentication (if needed in the future).
cloud_firestore: For Firebase Firestore database (future use for advanced features).
firebase_database: Used to fetch categories and content from Firebase Realtime Database.
cached_network_image: Efficient image loading and caching.
flutter_tts: Text-to-speech functionality for accessibility.
provider: State management solution.
flutter_launcher_icons: Generates app icons for Android/iOS.
flutter_native_splash: Configures splash screen for both Android/iOS.

Additional Notes
Code Structure: The code is modular, with each screen and feature separated into its own file. The app follows the Atomic Design principles for maintainability.
State Management: The app uses Provider for managing state, ensuring a responsive UI and clean architecture.
