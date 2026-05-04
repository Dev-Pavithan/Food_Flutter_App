import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  bool _isGuest = true;
  String _email = '';
  bool _isInitialized = false;
  bool _isLoggedIn = false;

  bool get isGuest => _isGuest;
  String get email => _email;
  bool get isInitialized => _isInitialized;
  bool get isLoggedIn => _isLoggedIn;

  UserProvider() {
    _loadUser();
  }

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    _email = prefs.getString('user_email') ?? '';
    _isGuest = prefs.getBool('is_guest') ?? true;
    _isLoggedIn = prefs.getBool('is_logged_in') ?? false;
    _isInitialized = true;
    notifyListeners();
  }

  Future<void> setUser(String email, bool isGuest) async {
    _email = email;
    _isGuest = isGuest;
    _isLoggedIn = true;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_email', email);
    await prefs.setBool('is_guest', isGuest);
    await prefs.setBool('is_logged_in', true);
    
    notifyListeners();
  }

  Future<void> logout() async {
    _email = '';
    _isGuest = true;
    _isLoggedIn = false;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_email');
    await prefs.remove('is_guest');
    await prefs.setBool('is_logged_in', false);
    
    notifyListeners();
  }
}
