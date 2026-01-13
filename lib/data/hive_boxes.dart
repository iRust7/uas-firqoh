import 'package:hive_flutter/hive_flutter.dart';
import '../models/note.dart';
import '../models/user.dart';
import '../services/session_service.dart';

class HiveBoxes {
  static Box<Note>? _notesBox;

  // Getter for notes box
  static Box<Note> get notesBox {
    if (_notesBox == null || !_notesBox!.isOpen) {
      throw Exception('Notes box not initialized. Call initHive() first.');
    }
    return _notesBox!;
  }

  // Initialize Hive and open boxes
  static Future<void> initHive() async {
    await Hive.initFlutter();
    
    // Register adapters
    Hive.registerAdapter(NoteAdapter());
    Hive.registerAdapter(UserAdapter());

    try {
      // Try to open boxes
      _notesBox = await Hive.openBox<Note>('notesBox');
    } catch (e) {
      // If there's an error (likely due to schema mismatch), delete and recreate
      print('Error opening notesBox: $e');
      print('Deleting corrupted box and recreating...');
      
      try {
        await Hive.deleteBoxFromDisk('notesBox');
      } catch (_) {}
      
      // Recreate box
      _notesBox = await Hive.openBox<Note>('notesBox');
    }
    
    // Initialize users box with error recovery
    try {
      await SessionService.initUsersBox();
    } catch (e) {
      print('Error opening usersBox: $e');
      print('Deleting corrupted box and recreating...');
      
      try {
        await Hive.deleteBoxFromDisk('usersBox');
      } catch (_) {}
      
      await SessionService.initUsersBox();
    }

    // Seed initial data if box is empty
    if (_notesBox!.isEmpty) {
      await seedInitialData();
    }
  }

  // Seed initial sample notes
  static Future<void> seedInitialData() async {
    final sampleNotes = [
      Note.create(
        title: 'Welcome to StudyNotes!',
        content: 'This is your first note. You can create, edit, and delete notes easily. Tap the + button to add a new note!',
        tag: 'General',
        isPinned: true,
        colorIndex: 1, // Yellow
      ),
      Note.create(
        title: 'Flutter Basics',
        content: 'Flutter uses widgets for everything. StatelessWidget for static UI, StatefulWidget for dynamic UI with state management.',
        tag: 'Flutter',
        colorIndex: 4, // Blue
      ),
      Note.create(
        title: 'Hive Database',
        content: 'Hive is a lightweight and fast NoSQL database written in pure Dart. Perfect for offline storage in Flutter apps!',
        tag: 'Database',
        colorIndex: 3, // Cyan
      ),
    ];

    for (final note in sampleNotes) {
      await _notesBox!.add(note);
    }
  }

  // Close all boxes
  static Future<void> close() async {
    await Hive.close();
  }
}
