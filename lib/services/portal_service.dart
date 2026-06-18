import 'api_client.dart';
import '../models/portal_data.dart';

class PortalService {
  PortalService(this._api);

  final ApiClient _api;

  Future<PortalData> loadDashboard(String token) async {
    final clean = token.trim();
    if (clean.isEmpty) {
      throw ApiException('رابط البوابة غير صالح');
    }
    final res = await _api.get(
      'portal/dashboard?token=${Uri.encodeQueryComponent(clean)}',
    );
    return PortalData.fromJson(res);
  }

  Future<void> submitProof({
    required String token,
    required String invoiceId,
    required double amount,
    String? transferRef,
    String? note,
    String? proofImage,
  }) async {
    await _api.post('portal/submit_proof', body: {
      'token': token.trim(),
      'invoice_id': invoiceId,
      'amount': amount,
      if (transferRef != null && transferRef.isNotEmpty) 'transfer_ref': transferRef,
      if (note != null && note.isNotEmpty) 'note': note,
      if (proofImage != null && proofImage.isNotEmpty) 'proof_image': proofImage,
    });
  }

  Future<void> submitMaintenance({
    required String token,
    required String title,
    String priority = 'Medium',
    String? notes,
  }) async {
    await _api.post('portal/maintenance', body: {
      'token': token.trim(),
      'title': title,
      if (notes != null && notes.isNotEmpty) 'notes': notes,
      'priority': priority,
    });
  }
}
