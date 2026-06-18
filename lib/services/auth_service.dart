import 'package:shared_preferences/shared_preferences.dart';

import '../models/app_user.dart';
import 'api_client.dart';

class AuthService {
  AuthService(this._api);

  static const _tokenKey = 'jawdah_cloud_token';

  final ApiClient _api;
  AppUser? user;

  AppUser userFromMe(Map<String, dynamic> me) {
    final userJson = Map<String, dynamic>.from(me['user'] as Map<String, dynamic>);
    final perms = (me['permissions'] as List<dynamic>? ?? [])
        .map((e) => e.toString())
        .toList();
    userJson['permissions'] = perms;
    return AppUser.fromJson(userJson);
  }

  Future<void> syncFromMe() async {
    final me = await _api.get('me');
    user = userFromMe(me);
  }

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
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await syncFromMe();
    return user!;
  }

  Future<AppUser?> restoreSession() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    if (token == null || token.isEmpty) return null;
    _api.setToken(token);
    await syncFromMe();
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
