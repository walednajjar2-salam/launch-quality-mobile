class AppUser {
  AppUser({
    required this.id,
    required this.username,
    required this.name,
    required this.role,
    required this.active,
    this.permissions = const [],
  });

  final String id;
  final String username;
  final String name;
  final String role;
  final bool active;
  final List<String> permissions;

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id']?.toString() ?? '',
      username: json['username']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      role: json['role']?.toString() ?? '',
      active: json['active'] == true || json['active'] == 1,
      permissions: (json['permissions'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
    );
  }

  String get roleLabel => {
        'owner': 'مالك المؤسسة',
        'admin': 'مدير النظام',
        'executive_manager': 'المدير التنفيذي',
        'accountant': 'محاسب',
        'operations': 'تشغيل',
        'maintenance': 'صيانة',
        'viewer': 'مشاهد',
      }[role] ??
      role;

  bool can(String permission) => permissions.contains(permission);
}
