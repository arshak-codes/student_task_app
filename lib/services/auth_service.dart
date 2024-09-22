import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _emailKey = 'user_email';
  static const String _passwordKey = 'user_password';

  Future<bool> login(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_emailKey, email);
    await prefs.setString(_passwordKey, password);
    return true; // Login success
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_emailKey);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_emailKey);
    await prefs.remove(_passwordKey);
  }
}
