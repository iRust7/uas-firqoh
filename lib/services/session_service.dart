import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/user.dart';

class SessionService {
  static const String _isLoggedInKey = 'isLoggedIn';
  static const String _currentUsernameKey = 'currentUsername';
  static const String _usersBoxName = 'usersBox';

  // Get users box
  static Box<User> get _usersBox => Hive.box<User>(_usersBoxName);

  // Initialize users box
  static Future<void> initUsersBox() async {
    if (!Hive.isBoxOpen(_usersBoxName)) {
      await Hive.openBox<User>(_usersBoxName);
    }
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  // Get current logged in username
  static Future<String?> getCurrentUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_currentUsernameKey);
  }

  // Register new user
  static Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String password,
  }) async {
    // Check if username already exists
    final existingUser = _usersBox.values.firstWhere(
      (user) => user.username.toLowerCase() == username.toLowerCase(),
      orElse: () => User(username: '', email: '', password: '', createdAt: 0),
    );

    if (existingUser.username.isNotEmpty) {
      return {
        'success': false,
        'message': 'Username already exists',
      };
    }

    // Check if email already exists
    final existingEmail = _usersBox.values.firstWhere(
      (user) => user.email.toLowerCase() == email.toLowerCase(),
      orElse: () => User(username: '', email: '', password: '', createdAt: 0),
    );

    if (existingEmail.email.isNotEmpty) {
      return {
        'success': false,
        'message': 'Email already registered',
      };
    }

    // Create new user
    final newUser = User.create(
      username: username,
      email: email,
      password: password,
    );

    await _usersBox.add(newUser);

    return {
      'success': true,
      'message': 'Registration successful',
    };
  }

  // Attempt login with credentials
  static Future<bool> login(String username, String password) async {
    final user = _usersBox.values.firstWhere(
      (user) => user.username.toLowerCase() == username.toLowerCase() && 
                user.password == password,
      orElse: () => User(username: '', email: '', password: '', createdAt: 0),
    );

    if (user.username.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_isLoggedInKey, true);
      await prefs.setString(_currentUsernameKey, user.username);
      return true;
    }

    return false;
  }

  // Logout
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, false);
    await prefs.remove(_currentUsernameKey);
  }

  // Get current user
  static Future<User?> getCurrentUser() async {
    final username = await getCurrentUsername();
    if (username == null) return null;

    return _usersBox.values.firstWhere(
      (user) => user.username == username,
      orElse: () => User(username: '', email: '', password: '', createdAt: 0),
    );
  }
}
