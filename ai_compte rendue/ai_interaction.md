# AI Interaction & Prompt Log

**Project:** `waiting_room_app`  
**Date:** October 6, 2026  
**Context:** Cross-Platform Mobile Development (Flutter & Android) — TP3  

---

## 1. AI Model & Working Environment

| Property | Details |
| :--- | :--- |
| **AI Model** | Gemini 3.8 Flash |
| **AI Environment** | Google Antigravity IDE (Agentic Coding Assistant) |
| **Operating System** | Windows 11 (PowerShell terminal execution) |
| **Flutter SDK** | Version 3.38.5 |
| **JDK (Final)** | Microsoft OpenJDK 21 LTS (`C:\Users\hanam\develop\jdk-21.0.6+7`) |
| **JDK (Conflicting)** | Oracle JDK 25 (`C:\Program Files\Java\jdk-25.0.2` — unaligned with Gradle) |
| **Gradle / Build System** | Gradle 8.14 with Kotlin DSL (`build.gradle.kts`) |
| **IDE** | Android Studio / IntelliJ IDEA |
| **Architecture** | Provider State Management (`provider: ^6.x`, `ChangeNotifier`, `ChangeNotifierProvider`) |

---

## 2. Methodology & Interaction Workflow

The AI assistant was utilized as an interactive pair-programmer following an iterative engineering cycle:
1. **Diagnosis & Root-Cause Analysis:** Providing full terminal error traces to isolate build system incompatibilities.
2. **Environment & Toolchain Alignment:** Step-by-step PowerShell scripting to install, configure, and isolate JDK 21 LTS.
3. **IDE Configuration:** Aligning Android Studio's internal Gradle JVM settings with the host toolchain.
4. **Architecture Refactoring:** Implementing the workshop-mandated `Provider` pattern in business logic and UI.
5. **Test-Driven Verification:** Updating unit and widget tests to validate reactive state changes.
6. **Static Analysis & Build Validation:** Ensuring zero lint errors, 100% test pass rate, and successful APK assembly.

---

## 3. Chronological Prompt Sequence

Below are the exact, structured prompts submitted to the AI assistant throughout the project, detailing the objective, input prompt, and target outcome for each phase:

---

### Prompt 1: Initial Build Failure & Gradle Diagnosis
* **Stage:** Diagnostic & Root Cause Analysis  
* **Context:** Initial Android sync and build failed before compilation started.  
* **Prompt:**
  ```text
  When I try to build or sync my Flutter Android app, Gradle fails with this exception:
  "The supplied phased action failed with an exception. 25.0.2 @[android/build.gradle.kts:L1]"

  Here is my system environment and error stack. Can you analyze the root cause of this failure and tell me why it is breaking on line 1 of build.gradle.kts?
  ```
* **AI Action & Result:**
  - Analyzed the Kotlin DSL parser in Gradle 8.14.
  - Identified that `JavaVersion.parse("25.0.2")` throws an `IllegalArgumentException` because Gradle 8.14 only supports up to Java 24.
  - Recommended downgrading to an LTS version (JDK 21).

---

### Prompt 2: JDK 21 LTS Downgrade & Windows Environment Setup
* **Stage:** Toolchain & Environment Configuration  
* **Context:** Needed to configure OpenJDK 21 LTS without breaking other developer tools on Windows.  
* **Prompt:**
  ```text
  Since Gradle 8.14 does not support Java 25, how do I configure my Windows environment and Flutter project to use Microsoft OpenJDK 21 LTS located at "C:\Users\hanam\develop\jdk-21.0.6+7"?

  Please provide the exact PowerShell commands to configure Flutter's JDK, set the user JAVA_HOME variable, and pin "org.gradle.java.home" in android/gradle.properties.
  ```
* **AI Action & Result:**
  - Provided commands: `flutter config --jdk-dir "C:\Users\hanam\develop\jdk-21.0.6+7"`.
  - Set persistent user `JAVA_HOME` via `[System.Environment]::SetEnvironmentVariable`.
  - Pinned `org.gradle.java.home` in `android/gradle.properties` to ensure reproducible builds.

---

### Prompt 3: Android Studio / IntelliJ Gradle Alignment
* **Stage:** IDE Alignment  
* **Context:** Terminal builds worked, but Android Studio sync still triggered the Gradle error due to cached IDE JDK settings.  
* **Prompt:**
  ```text
  Even after changing the CLI environment variables, Android Studio still fails Gradle sync with the same phased action error because it uses its own bundled or detected JDK.

  Where in Android Studio / IntelliJ settings can I change the Gradle JDK to point to OpenJDK 21 LTS?
  ```
* **AI Action & Result:**
  - Provided navigation path: `File > Settings > Build, Execution, Deployment > Build Tools > Gradle`.
  - Instructed setting **Gradle JDK** to JDK 21 (`C:\Users\hanam\develop\jdk-21.0.6+7`).
  - Instructed re-syncing Gradle files to verify IDE resolution.

---

### Prompt 4: Provider Architecture Refactoring (`queue_provider.dart`)
* **Stage:** Business Logic & State Management Migration  
* **Context:** Deprecating the old `WaitingRoomManager` in favor of a reactive Provider model.  
* **Prompt:**
  ```text
  Our workshop requires migrating from our old WaitingRoomManager to the Flutter provider state management pattern.

  Please create "lib/queue_provider.dart" with a QueueProvider class extending ChangeNotifier. It should maintain a private _clients list with a public getter, and implement:
  - addClient(String name)
  - removeClient(String name)
  - nextClient() (removes the first client if the list is not empty)

  Ensure notifyListeners() is called on every state modification.
  ```
* **AI Action & Result:**
  - Implemented `lib/queue_provider.dart` with encapsulated state, safe list operations, and proper `notifyListeners()` triggers.

---

### Prompt 5: UI Refactoring & Provider Integration (`main.dart`)
* **Stage:** UI Layer Refactoring  
* **Context:** Converting `WaitingRoomScreen` from `StatefulWidget` to `StatelessWidget` and connecting to `QueueProvider`.  
* **Prompt:**
  ```text
  Now refactor "lib/main.dart" to integrate QueueProvider.
  
  Requirements:
  1. Wrap the app in ChangeNotifierProvider(create: (_) => QueueProvider()).
  2. Convert WaitingRoomScreen from a StatefulWidget to a StatelessWidget.
  3. Replace all local state setState() calls: use context.watch<QueueProvider>() to display the queue and client count, and context.read<QueueProvider>() for mutations (Add and Delete actions).
  4. Add an action button in the AppBar with icon Icons.skip_next, tooltip 'Next Client', and key Key('nextClientButton') that invokes nextClient().
  ```
* **AI Action & Result:**
  - Cleaned up `lib/main.dart`, removed boilerplate state management, implemented reactive listeners, and added the AppBar action button with the required key.

---

### Prompt 6: Test Suite Alignment & Provider Scaffolding
* **Stage:** Unit & Widget Testing  
* **Context:** `flutter test` failed due to missing `Provider` ancestry and outdated class references.  
* **Prompt:**
  ```text
  Running "flutter test" currently fails because our widget tests are not wrapping widgets in a ChangeNotifierProvider and still refer to old classes.

  Please update "test/waiting_room_widget_test.dart" and "test/waiting_room_manager_test.dart" to test QueueProvider. The widget tests must wrap WaitingRoomApp with ChangeNotifierProvider(create: (_) => QueueProvider()) and cover:
  1. Adding a client via TextField and button tap.
  2. Removing a client via the delete icon button.
  3. Advancing the queue when tapping the 'nextClientButton' AppBar action.
  ```
* **AI Action & Result:**
  - Refactored both test files.
  - Wrapped test trees with `ChangeNotifierProvider` and `QueueProvider`.
  - All 6 tests (3 unit tests + 3 widget tests) passed cleanly.

---

### Prompt 7: Code Quality, Linting & Build Verification
* **Stage:** Quality Assurance & Validation  
* **Context:** Ensuring project meets academic code standards and compiles cleanly.  
* **Prompt:**
  ```text
  Please run "flutter analyze" to check for any lint warnings or unused imports, run "flutter test" to ensure all 6 test cases pass, check "flutter doctor -v" to verify the toolchain correctly uses JDK 21, and run "flutter build apk --debug" to verify the Android Gradle build completes cleanly.
  ```
* **AI Action & Result:**
  - Executed static analysis: 0 issues found.
  - Executed test suite: 6/6 passed.
  - Verified `flutter doctor -v` toolchain with OpenJDK 21.
  - Ran debug APK build successfully without Gradle exceptions.

---

### Prompt 8: Technical Summary Documentation Generation
* **Stage:** Documentation & Reporting  
* **Context:** Preparing the final workshop report for academic submission.  
* **Prompt:**
  ```text
  Generate a detailed markdown report in "SUMMARY.md" summarizing everything we did in this session.

  It should cover: the initial Gradle and test failures, root cause analysis of the Java 25 vs Gradle 8.14 incompatibility and Provider state management architecture, step-by-step resolution, and full test/build verification output.
  ```
* **AI Action & Result:**
  - Generated the comprehensive `SUMMARY.md` file documenting the entire troubleshooting journey and technical details.

---

## 4. Summary of Key AI Contributions

1. **System Incompatibility Diagnosis:** Quickly isolated an obscure low-level issue (`JavaVersion.parse` failing on Java 25 inside Gradle's Kotlin DSL).
2. **Environment Isolation:** Provided precise Windows PowerShell commands to set environment variables without corrupting existing tools.
3. **Architectural Best Practices:** Guided the transition to idiomatic Flutter `Provider` state management (`context.watch` vs `context.read`).
4. **Test Integrity:** Ensured full test coverage by properly scaffolding InheritedWidget/Provider dependencies inside widget tests.
