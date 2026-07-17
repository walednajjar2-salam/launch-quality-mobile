import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../config/api_config.dart';
import '../models/app_user.dart';
import 'api_client.dart';

class BootstrapData {
  BootstrapData({
    required this.data,
    required this.dashboard,
    required this.user,
    this.companySettings = const {},
  });

  final Map<String, List<Map<String, dynamic>>> data;
  final Map<String, dynamic> dashboard;
  final AppUser user;
  final Map<String, dynamic> companySettings;

  List<Map<String, dynamic>> table(String name) =>
      List<Map<String, dynamic>>.from(data[name] ?? const []);

  Map<String, dynamic> get kpis =>
      Map<String, dynamic>.from(dashboard['kpis'] as Map? ?? {});

  List<Map<String, dynamic>> get decisions =>
      List<Map<String, dynamic>>.from(dashboard['decisions'] as List? ?? []);
}

class BootstrapService {
  BootstrapService(this._api);

  final ApiClient _api;

  static const _cacheKey = 'bootstrap_cache';

  BootstrapData _parse(Map<String, dynamic> res) {
    final rawData = res['data'] as Map<String, dynamic>? ?? {};
    final parsed = <String, List<Map<String, dynamic>>>{};
    rawData.forEach((key, value) {
      parsed[key] = List<Map<String, dynamic>>.from(
        (value as List? ?? []).map(
          (e) => Map<String, dynamic>.from(e as Map),
        ),
      );
    });
    return BootstrapData(
      data: parsed,
      dashboard: Map<String, dynamic>.from(res['dashboard'] as Map? ?? {}),
      user: AppUser.fromJson(res['user'] as Map<String, dynamic>),
      companySettings:
          Map<String, dynamic>.from(res['company_settings'] as Map? ?? {}),
    );
  }

  Future<BootstrapData> load({bool forceRefresh = false}) async {
    if (!forceRefresh) {
      try {
        final prefs = await SharedPreferences.getInstance();
        final cached = prefs.getString(_cacheKey);
        if (cached != null) {
          final json = jsonDecode(cached) as Map<String, dynamic>;
          return _parse(json);
        }
      } catch (_) {
        // Cache corrupted or unavailable – fall through to network fetch.
      }
    }

    final res = await _api.get('bootstrap', timeout: ApiConfig.bootstrapTimeout);

    // Persist to cache for next cold start.
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_cacheKey, jsonEncode(res));
    } catch (_) {
      // Non-fatal – caching is best-effort.
    }

    return _parse(res);
  }

  Future<void> clearCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_cacheKey);
    } catch (_) {}
  }

  Future<Map<String, dynamic>> refreshDashboard() async {
    final res = await _api.get('dashboard');
    return Map<String, dynamic>.from(res['dashboard'] as Map? ?? {});
  }

  Future<List<Map<String, dynamic>>> portalProofs({String status = 'pending'}) async {
    final res = await _api.get('portal/proofs?status=$status');
    return List<Map<String, dynamic>>.from(res['items'] as List? ?? []);
  }

  Future<void> reviewProof({
    required String proofId,
    required String action,
    String? reviewNote,
  }) async {
    await _api.post('portal/review_proof', body: {
      'proof_id': proofId,
      'action': action,
      if (reviewNote != null && reviewNote.isNotEmpty) 'review_note': reviewNote,
    });
  }

  Future<void> payInvoice({
    required String invoiceId,
    required double amount,
    String method = 'Bank Transfer',
    String? note,
  }) async {
    await _api.post('pay_invoice', body: {
      'invoice_id': invoiceId,
      'amount': amount,
      'method': method,
      if (note != null) 'note': note,
    });
  }

  Future<void> updateMaintenance(Map<String, dynamic> item) async {
    await _api.put('maintenance/${item['id']}', body: item);
  }

  Future<void> createMaintenance(Map<String, dynamic> item) async {
    await _api.post('maintenance', body: item);
  }
}
