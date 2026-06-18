import 'package:flutter/foundation.dart';

import '../models/app_user.dart';
import '../services/api_client.dart';
import '../services/auth_service.dart';
import '../services/bootstrap_service.dart';

enum AppStatus { booting, login, loading, ready, error }

class AppState extends ChangeNotifier {
  AppState({
    required ApiClient api,
    required AuthService auth,
    required BootstrapService bootstrap,
  })  : _api = api,
        _auth = auth,
        _bootstrap = bootstrap;

  final ApiClient _api;
  final AuthService _auth;
  final BootstrapService _bootstrap;

  AppStatus status = AppStatus.booting;
  String? errorMessage;
  BootstrapData? bootstrap;
  int navIndex = 0;

  AppUser? get user => _auth.user;
  ApiClient get api => _api;

  String _friendlyError(Object e) {
    final msg = e.toString();
    if (msg.contains('Invalid username or password')) {
      return 'اسم المستخدم أو كلمة المرور غير صحيحة';
    }
    if (msg.contains('Too many login attempts')) {
      return 'محاولات كثيرة — انتظر قليلاً ثم أعد المحاولة';
    }
    if (msg.contains('Authentication required')) {
      return 'انتهت الجلسة — سجّل الدخول من جديد';
    }
    return msg;
  }

  Future<void> boot() async {
    status = AppStatus.booting;
    errorMessage = null;
    notifyListeners();
    try {
      final restored = await _auth.restoreSession();
      if (restored == null) {
        status = AppStatus.login;
      } else {
        await loadBootstrap();
      }
    } catch (e) {
      await _auth.logout();
      status = AppStatus.login;
      errorMessage = _friendlyError(e);
    }
    notifyListeners();
  }

  Future<void> login(String username, String password) async {
    status = AppStatus.loading;
    errorMessage = null;
    notifyListeners();
    try {
      await _auth.login(username, password);
      await loadBootstrap();
    } catch (e) {
      status = AppStatus.login;
      errorMessage = _friendlyError(e);
      notifyListeners();
    }
  }

  Future<void> loadBootstrap() async {
    status = AppStatus.loading;
    notifyListeners();
    try {
      bootstrap = await _bootstrap.load();
      await _auth.syncFromMe();
      status = AppStatus.ready;
      errorMessage = null;
    } catch (e) {
      status = AppStatus.error;
      errorMessage = _friendlyError(e);
    }
    notifyListeners();
  }

  Future<void> refresh() => loadBootstrap();

  Future<void> logout() async {
    await _auth.logout();
    bootstrap = null;
    navIndex = 0;
    status = AppStatus.login;
    errorMessage = null;
    notifyListeners();
  }

  void setNavIndex(int index) {
    navIndex = index;
    notifyListeners();
  }

  bool canRead(String table) => user?.can('$table:read') ?? false;
}
