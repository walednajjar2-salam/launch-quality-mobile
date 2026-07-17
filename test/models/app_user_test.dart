import 'package:flutter_test/flutter_test.dart';

import 'package:launch_quality_mobile/models/app_user.dart';

void main() {
  group('AppUser', () {
    // ─── Helpers ────────────────────────────────────────────────────────────
    AppUser makeUser({
      String id = '1',
      String username = 'testuser',
      String name = 'Test User',
      String role = 'user',
      bool active = true,
      List<String> permissions = const [],
    }) {
      return AppUser(
        id: id,
        username: username,
        name: name,
        role: role,
        active: active,
        permissions: permissions,
      );
    }

    // ─── can() ──────────────────────────────────────────────────────────────
    group('can', () {
      test('returns true when permission is explicitly listed', () {
        final user = makeUser(permissions: ['view_dashboard', 'edit_projects']);
        expect(user.can('view_dashboard'), isTrue);
        expect(user.can('edit_projects'), isTrue);
      });

      test('returns false when permission is not listed', () {
        final user = makeUser(permissions: []);
        expect(user.can('admin_access'), isFalse);
      });

      test('returns true for any permission when "all" is granted', () {
        final user = makeUser(permissions: ['all']);
        expect(user.can('admin_access'), isTrue);
        expect(user.can('view_dashboard'), isTrue);
      });

      test('base permission grants read but not delete', () {
        final user = makeUser(permissions: ['projects']);
        expect(user.can('projects:read'), isTrue);
        expect(user.can('projects:delete'), isFalse);
      });

      test('explicit :read permission works', () {
        final user = makeUser(permissions: ['projects:read']);
        expect(user.can('projects:read'), isTrue);
        expect(user.can('projects:write'), isFalse);
      });

      test('returns false for unrelated permission', () {
        final user = makeUser(permissions: ['clients:read']);
        expect(user.can('projects:read'), isFalse);
      });
    });

    // ─── fromJson ───────────────────────────────────────────────────────────
    group('fromJson', () {
      test('creates correct object from full JSON', () {
        final json = {
          'id': '42',
          'username': 'jdoe',
          'name': 'Jane Doe',
          'role': 'admin',
          'active': true,
          'permissions': ['view', 'edit'],
        };

        final user = AppUser.fromJson(json);
        expect(user.id, '42');
        expect(user.username, 'jdoe');
        expect(user.name, 'Jane Doe');
        expect(user.role, 'admin');
        expect(user.active, isTrue);
        expect(user.permissions, ['view', 'edit']);
      });

      test('uses empty defaults for missing fields', () {
        final user = AppUser.fromJson({});
        expect(user.id, '');
        expect(user.username, '');
        expect(user.name, '');
        expect(user.role, '');
        expect(user.active, isFalse);
        expect(user.permissions, isEmpty);
      });

      test('converts numeric id to string', () {
        final user = AppUser.fromJson({'id': 99});
        expect(user.id, '99');
      });

      test('treats active == 1 as true', () {
        final user = AppUser.fromJson({'active': 1});
        expect(user.active, isTrue);
      });

      test('treats active == false as false', () {
        final user = AppUser.fromJson({'active': false});
        expect(user.active, isFalse);
      });
    });

    // ─── toJson ─────────────────────────────────────────────────────────────
    group('toJson', () {
      test('preserves all fields', () {
        final user = makeUser(
          id: '7',
          username: 'admin',
          name: 'Admin User',
          role: 'admin',
          active: true,
          permissions: ['all'],
        );

        final json = user.toJson();
        expect(json['id'], '7');
        expect(json['username'], 'admin');
        expect(json['name'], 'Admin User');
        expect(json['role'], 'admin');
        expect(json['active'], isTrue);
        expect(json['permissions'], ['all']);
      });

      test('roundtrip: fromJson(toJson()) produces identical values', () {
        final original = makeUser(
          id: '123',
          username: 'roundtrip',
          name: 'Round Trip',
          role: 'operations',
          active: false,
          permissions: ['clients:read', 'projects:read'],
        );

        final restored = AppUser.fromJson(original.toJson());
        expect(restored.id, original.id);
        expect(restored.username, original.username);
        expect(restored.name, original.name);
        expect(restored.role, original.role);
        expect(restored.active, original.active);
        expect(restored.permissions, original.permissions);
      });
    });

    // ─── roleLabel ──────────────────────────────────────────────────────────
    group('roleLabel', () {
      test('returns Arabic label for known roles', () {
        expect(makeUser(role: 'owner').roleLabel, 'مالك المؤسسة');
        expect(makeUser(role: 'admin').roleLabel, 'مدير النظام');
        expect(makeUser(role: 'accountant').roleLabel, 'محاسب');
      });

      test('returns raw role for unknown roles', () {
        expect(makeUser(role: 'custom_role').roleLabel, 'custom_role');
      });
    });
  });
}
