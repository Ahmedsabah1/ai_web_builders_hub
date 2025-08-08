# GitHub Actions APK Build Workflow

This repository includes an automated GitHub Actions workflow that builds an Android APK whenever code is pushed to the main or master branch.

## What the Workflow Does

The workflow (`.github/workflows/build-apk.yml`) performs the following steps:

1. **Environment Setup**
   - Sets up Ubuntu latest runner
   - Installs Java JDK 17 (required for Flutter/Android)
   - Sets up Android SDK
   - Installs Flutter SDK 3.24.0 (stable channel)

2. **Project Preparation**
   - Checks out the repository code
   - Installs Flutter dependencies with `flutter pub get`
   - Runs code analysis with `flutter analyze`
   - Executes tests with `flutter test`

3. **APK Building**
   - Builds a release APK using `flutter build apk --release`
   - The APK is created in `build/app/outputs/flutter-apk/app-release.apk`

4. **Artifact Upload**
   - Uploads the built APK as a workflow artifact
   - Artifact name: `ai-web-builders-hub-apk`
   - Retention period: 30 days
   - Available for download from the GitHub Actions page

## How to Download the APK

1. Go to the repository's **Actions** tab
2. Click on the latest successful workflow run
3. Scroll down to the **Artifacts** section
4. Download the `ai-web-builders-hub-apk` artifact
5. Extract the ZIP file to get the APK

## Workflow Triggers

The workflow runs automatically on:
- Push to `main` branch
- Push to `master` branch
- Pull requests to `main` or `master` branches

## Android Configuration

The repository includes complete Android build configuration:
- Gradle build files
- Android manifest
- MainActivity in Kotlin
- App icons and launch screens
- Proper Android SDK and NDK setup

## Requirements

- Flutter SDK 3.0.0 or higher
- Android SDK with minimum API level as specified in Flutter defaults
- Java 17 for building

The workflow handles all these requirements automatically in the CI environment.