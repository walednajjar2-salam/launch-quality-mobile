import 'package:shared_preferences/shared_preferences.dart';

import '../models/app_user.dart';
import 'api_client.dart';

class AuthService {
  AuthService(this._api);

  static const _tokenKey = 'jawdah_cloud_token';

  final ApiClient _api;
  AppUser? user;

  Future<AppUser> login(String username, String password) async {
    final res = await _api.post('login', body: {
      'username': username.trim(),
      'password': password,
    });
    final token = res['token']?.toString() ?? '';
    if (token.isEmpty) {
      throw ApiException('تعذر تسجيل الدخول');
    }
    _api.setToken(token);
    user = AppUser.fromJson(res['user'] as Map<String, dynamic>);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    return user!;
  }

  Future<AppUser?> restoreSession() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    if (token == null || token.isEmpty) return null;
    _api.setToken(token);
    final me = await _api.get('me');
    user = AppUser.fromJson(me['user'] as Map<String, dynamic>);
    return user;
  }

  Future<void> logout() async {
    try {
      await _api.post('logout');
    } catch (_) {}
    _api.setToken(null);
    user = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }
}
