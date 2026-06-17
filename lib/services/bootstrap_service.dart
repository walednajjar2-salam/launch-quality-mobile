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

  Future<BootstrapData> load() async {
    final res = await _api.get('bootstrap', timeout: ApiConfig.bootstrapTimeout);
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
