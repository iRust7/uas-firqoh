# StudyNotes

A Flutter-based note-taking app designed for students and learners. Built with offline-first architecture using Hive for local data persistence.

## What It Does

StudyNotes helps you organize your study materials with features like color categorization, pinning important notes, and multi-user support. Everything is stored locally on your device, so you can access your notes without an internet connection.

## Key Features

**Core Functionality**
- Create, edit, and delete notes with rich text content
- Organize notes by tags and categories
- Pin important notes to keep them at the top
- Choose from 8 color themes for visual organization
- Switch between list and grid view layouts

**User Management**
- Multi-user authentication system
- Secure local login with session management
- Profile customization per user

**Additional Tools**
- Calendar view to see notes by date
- Real-time search across all notes
- Share notes to WhatsApp, Email, or other apps
- Copy note content to clipboard
- Lottie animations for enhanced UX

## Tech Stack

- **Framework**: Flutter 3.x
- **Local Database**: Hive (NoSQL)
- **Session Management**: SharedPreferences
- **Animations**: Lottie
- **Calendar**: table_calendar package
- **Sharing**: share_plus package

## Project Structure

```
lib/
├── models/          # Data models (Note, User)
├── screens/         # UI screens
├── services/        # Business logic (SessionService)
├── widgets/         # Reusable components
├── utils/           # Helper functions (NoteColors)
├── data/            # Hive box initialization
└── animation/       # Lottie JSON files
```

## Setup & Installation

**Prerequisites**
- Flutter SDK (3.0.0 or higher)
- Android SDK / Xcode
- Git

**Clone & Run**
```bash
git clone <repository-url>
cd studynotes
flutter pub get
flutter run
```

**Build APK**
```bash
flutter build apk --release
```

The APK will be available at: `build/app/outputs/flutter-apk/app-release.apk`

## How to Use

1. **First Launch**: Create an account with username, email, and password
2. **Add Notes**: Tap the floating action button (+) on the home screen
3. **Organize**: 
   - Assign colors to categorize notes
   - Add tags for filtering
   - Pin important notes
4. **Find Notes**: Use the search tab or calendar view
5. **Share**: Open any note and use the share or copy buttons

## Data Storage

All data is stored locally using Hive:
- Notes are saved in `notesBox`
- User accounts in `usersBox`
- Session state in SharedPreferences

**Note**: Uninstalling the app will delete all stored data. Consider exporting important notes before uninstalling.

## Development Notes

**Code Generation**

The app uses Hive's code generation for type adapters. After modifying model classes:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

**Hot Reload vs Hot Restart**

- Use `r` in terminal for hot reload (UI changes)
- Use `R` for hot restart (state changes, new assets)

## Known Limitations

- No cloud sync (all data is local only)
- No note attachments (text only)
- Single device usage
- No password recovery (local auth)

## Future Enhancements

Potential features for future versions:
- Cloud backup/sync
- Markdown support
- Note attachments (images, files)
- Export to PDF
- Dark mode theme

## License

This project is created for educational purposes as part of a university mobile programming course.

## Contact

For questions or issues, please open an issue in the repository.

---

**Built with Flutter** • **Offline-First** • **Multi-User Support**
