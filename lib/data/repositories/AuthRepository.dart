import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AuthRepository {
  static const String _userKey = 'user_key';
  final SharedPreferences _prefs;

  AuthRepository(this._prefs);

  User signUp({
    required String fullName,
    required String email,
    required String password,
    String? phoneNumber,
  }) {
    final existingUser = _getUserByEmail(email);
    if (existingUser != null) {
      throw Exception('Email already exists');
    }

    final user = User(
      fullName: fullName,
      email: email,
      password: password, // In real app, hash the password
      phoneNumber: phoneNumber,
    );

    List<User> users = [];
    final usersJson = _prefs.getString(_userKey);

    if (usersJson != null) {
      try {
        users = (json.decode(usersJson) as List)
            .map((e) => User.fromJson(e as Map<String, dynamic>))
            .toList();
      } catch (e) {
        // Handle parsing error
        print('Error parsing users: $e');
      }
    }

    // Add new user and save
    users.add(user);
    _prefs.setString(
        _userKey, json.encode(users.map((u) => u.toJson()).toList()));
    _saveCurrentUser(user);

    return user;
  }

  User login({
    required String email,
    required String password,
  }) {
    final user = _getUserByEmail(email);
    if (user == null) {
      throw Exception('User not found');
    }
    if (user.password != password) {
      throw Exception('Invalid password');
    }
    _saveCurrentUser(user);
    return user;
  }

  void logout() {
    _prefs.remove('current_user');
  }

  User? getCurrentUser() {
    final userJson = _prefs.getString('current_user');
    if (userJson == null) return null;
    return User.fromJson(json.decode(userJson));
  }

  User? _getUserByEmail(String email) {
    final usersJson = _prefs.getString(_userKey);
    if (usersJson == null) return null;

    try {
      final users = (json.decode(usersJson) as List)
          .map((e) => User.fromJson(e as Map<String, dynamic>))
          .toList();

      return users.firstWhere(
        (user) => user.email == email,
        orElse: () => throw Exception('User not found'),
      );
    } catch (e) {
      return null; // Return null if there's any error in parsing
    }
  }

  void _saveCurrentUser(User user) {
    _prefs.setString('current_user', json.encode(user.toJson()));
  }
}
