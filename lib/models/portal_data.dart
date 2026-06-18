class PortalData {
  PortalData({
    required this.client,
    required this.summary,
    required this.contracts,
    required this.invoices,
    required this.payments,
    required this.maintenance,
    required this.proofs,
    required this.properties,
    this.company = const {},
  });

  final Map<String, dynamic> client;
  final Map<String, dynamic> summary;
  final List<Map<String, dynamic>> contracts;
  final List<Map<String, dynamic>> invoices;
  final List<Map<String, dynamic>> payments;
  final List<Map<String, dynamic>> maintenance;
  final List<Map<String, dynamic>> proofs;
  final Map<String, dynamic> properties;
  final Map<String, dynamic> company;

  factory PortalData.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> map(dynamic v) =>
        v is Map ? Map<String, dynamic>.from(v) : <String, dynamic>{};

    List<Map<String, dynamic>> list(dynamic v) => List<Map<String, dynamic>>.from(
          (v as List? ?? []).map((e) => Map<String, dynamic>.from(e as Map)),
        );

    return PortalData(
      client: map(json['client']),
      summary: map(json['summary']),
      contracts: list(json['contracts']),
      invoices: list(json['invoices']),
      payments: list(json['payments']),
      maintenance: list(json['maintenance']),
      proofs: list(json['proofs']),
      properties: map(json['properties']),
      company: map(json['company']),
    );
  }

  String get clientName => client['name']?.toString() ?? 'مستأجر';
}
