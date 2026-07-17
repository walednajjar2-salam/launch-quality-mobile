import 'package:flutter/foundation.dart';

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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'name': name,
      'role': role,
      'active': active,
      'permissions': permissions,
    };
  }

  /// Mirrors backend `has_permission()` in server.py
  bool can(String permission) {
    if (permissions.contains('all')) return true;
    if (permissions.contains(permission)) return true;
    final base = permission.split(':').first;
    if (permissions.contains(base) && !permission.endsWith(':delete')) {
      return true;
    }
    if (permission.endsWith(':read')) {
      if (permissions.contains(base) || permissions.contains('$base:read')) {
        return true;
      }
    }
    return false;
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

  bool get hasValidRole => {
        'owner',
        'admin',
        'executive_manager',
        'accountant',
        'operations',
        'maintenance',
        'viewer',
      }.contains(role);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppUser &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          username == other.username &&
          name == other.name &&
          role == other.role &&
          active == other.active &&
          listEquals(permissions, other.permissions);

  @override
  int get hashCode => Object.hash(
        id,
        username,
        name,
        role,
        active,
        Object.hashAll(permissions),
      );

  @override
  String toString() {
    return 'AppUser(id: $id, username: $username, name: $name, role: $role, active: $active, permissions: $permissions)';
  }
}
