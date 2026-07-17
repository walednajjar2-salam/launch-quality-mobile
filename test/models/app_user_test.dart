import 'package:flutter_test/flutter_test.dart';
import 'package:launch_quality_mobile/models/app_user.dart';

void main() {
  group('AppUser', () {
    test('fromJson serialization', () {
      final user = AppUser.fromJson({
        'id': '1',
        'username': 'najjar',
        'name': 'Najjar',
        'role': 'owner',
        'active': 1,
        'permissions': ['projects:read'],
      });

      expect(user.id, '1');
      expect(user.active, isTrue);
      expect(user.permissions, contains('projects:read'));
    });

    test('toJson serialization', () {
      final user = AppUser(
        id: '2',
        username: 'user',
        name: 'User',
        role: 'viewer',
        active: true,
        permissions: const ['clients:read'],
      );

      final json = user.toJson();

      expect(json['username'], 'user');
      expect(json['permissions'], ['clients:read']);
    });

    test('permission checking', () {
      final user = AppUser.fromJson({
        'id': '1',
        'username': 'u',
        'name': 'User',
        'role': 'owner',
        'active': true,
        'permissions': ['projects'],
      });

      expect(user.can('projects:read'), isTrue);
      expect(user.can('projects:delete'), isFalse);
    });

    test('role validation', () {
      final known = AppUser.fromJson({
        'id': '1',
        'username': 'u',
        'name': 'User',
        'role': 'admin',
        'active': true,
      });
      final unknown = AppUser.fromJson({
        'id': '1',
        'username': 'u',
        'name': 'User',
        'role': 'custom-role',
        'active': true,
      });

      expect(known.hasValidRole, isTrue);
      expect(unknown.hasValidRole, isFalse);
    });

    test('equality and hashing', () {
      final a = AppUser.fromJson({
        'id': '1',
        'username': 'u',
        'name': 'User',
        'role': 'owner',
        'active': true,
        'permissions': ['all'],
      });
      final b = AppUser.fromJson({
        'id': '1',
        'username': 'u',
        'name': 'User',
        'role': 'owner',
        'active': true,
        'permissions': ['all'],
      });

      expect(a, b);
      expect(a.hashCode, b.hashCode);
    });

    test('toString includes key fields', () {
      final user = AppUser.fromJson({
        'id': '9',
        'username': 'tester',
        'name': 'Tester',
        'role': 'viewer',
        'active': true,
      });

      expect(user.toString(), contains('tester'));
      expect(user.toString(), contains('viewer'));
    });
  });
}
