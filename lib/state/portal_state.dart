import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/portal_data.dart';
import '../services/portal_service.dart';

enum PortalStatus { idle, loading, ready, error }

class PortalState extends ChangeNotifier {
  PortalState(this._portal);

  static const _tokenKey = 'portal_token';

  final PortalService _portal;

  PortalStatus status = PortalStatus.idle;
  String? errorMessage;
  String? token;
  PortalData? data;
  int tabIndex = 0;

  Future<void> boot({String? initialToken}) async {
    final prefs = await SharedPreferences.getInstance();
    token = (initialToken ?? prefs.getString(_tokenKey))?.trim();
    if (token == null || token!.isEmpty) {
      status = PortalStatus.idle;
      notifyListeners();
      return;
    }
    await openWithToken(token!);
  }

  Future<void> openWithToken(String value) async {
    token = value.trim();
    status = PortalStatus.loading;
    errorMessage = null;
    notifyListeners();
    try {
      data = await _portal.loadDashboard(token!);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_tokenKey, token!);
      status = PortalStatus.ready;
    } catch (e) {
      status = PortalStatus.error;
      errorMessage = e.toString();
      data = null;
    }
    notifyListeners();
  }

  Future<void> refresh() async {
    if (token == null || token!.isEmpty) return;
    await openWithToken(token!);
  }

  Future<void> logout() async {
    token = null;
    data = null;
    tabIndex = 0;
    status = PortalStatus.idle;
    errorMessage = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    notifyListeners();
  }

  void setTab(int index) {
    tabIndex = index;
    notifyListeners();
  }

  Future<void> submitProof({
    required String invoiceId,
    required double amount,
    String? transferRef,
    String? note,
  }) async {
    if (token == null) return;
    await _portal.submitProof(
      token: token!,
      invoiceId: invoiceId,
      amount: amount,
      transferRef: transferRef,
      note: note,
    );
    await refresh();
  }

  Future<void> submitMaintenance({
    required String title,
    String priority = 'Medium',
    String? notes,
  }) async {
    if (token == null) return;
    await _portal.submitMaintenance(
      token: token!,
      title: title,
      priority: priority,
      notes: notes,
    );
    await refresh();
  }
}
