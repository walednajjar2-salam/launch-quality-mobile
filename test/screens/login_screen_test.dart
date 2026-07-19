import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'package:launch_quality_mobile/models/app_user.dart';
import 'package:launch_quality_mobile/screens/login_screen.dart';
import 'package:launch_quality_mobile/services/api_client.dart';
import 'package:launch_quality_mobile/services/auth_service.dart';
import 'package:launch_quality_mobile/services/bootstrap_service.dart';
import 'package:launch_quality_mobile/state/app_state.dart';
import 'package:launch_quality_mobile/theme/app_theme.dart';

// ─── Manual mock classes ────────────────────────────────────────────────────

class MockApiClient extends Mock implements ApiClient {}

class MockAuthService extends Mock implements AuthService {
  @override
  AppUser? get user => null;
}

class MockBootstrapService extends Mock implements BootstrapService {
  @override
  Future<BootstrapData> load() async => BootstrapData(
        data: const {},
        dashboard: const {},
        user: AppUser(
          id: '',
          username: '',
          name: '',
          role: '',
          active: false,
        ),
      );
}

// ─── Helper: pumps LoginScreen with a controlled AppState ──────────────────

Future<void> _pumpLoginScreen(
  WidgetTester tester, {
  AppStatus initialStatus = AppStatus.login,
  String? errorMessage,
}) async {
  final api = MockApiClient();
  final auth = MockAuthService();
  final bootstrap = MockBootstrapService();

  final appState = AppState(api: api, auth: auth, bootstrap: bootstrap);
  // Force the desired status without running boot() (which would hit the network).
  appState.status = initialStatus;
  appState.errorMessage = errorMessage;

  await tester.pumpWidget(
    ChangeNotifierProvider<AppState>.value(
      value: appState,
      child: MaterialApp(
        theme: AppTheme.dark(),
        home: const LoginScreen(),
      ),
    ),
  );
  await tester.pump();
}

// ─── Tests ──────────────────────────────────────────────────────────────────

void main() {
  group('LoginScreen', () {
    testWidgets('displays login form elements', (tester) async {
      await _pumpLoginScreen(tester);

      // Both text fields must be present.
      expect(find.byType(TextField), findsNWidgets(2));
      // Submit button.
      expect(find.byType(FilledButton), findsOneWidget);
      // Portal link.
      expect(find.byType(TextButton), findsOneWidget);
    });

    testWidgets('shows app name text', (tester) async {
      await _pumpLoginScreen(tester);
      expect(find.textContaining('جودة الانطلاقة'), findsWidgets);
    });

    testWidgets('username and password fields accept input', (tester) async {
      await _pumpLoginScreen(tester);

      final fields = find.byType(TextField);
      await tester.enterText(fields.first, 'Najjar');
      await tester.enterText(fields.last, 'Najjar2026');
      await tester.pump();

      expect(find.text('Najjar'), findsOneWidget);
    });

    testWidgets('submit button is enabled when not loading', (tester) async {
      await _pumpLoginScreen(tester, initialStatus: AppStatus.login);

      final btn = tester.widget<FilledButton>(find.byType(FilledButton));
      expect(btn.onPressed, isNotNull);
    });

    testWidgets('submit button is disabled while loading', (tester) async {
      await _pumpLoginScreen(tester, initialStatus: AppStatus.loading);

      final btn = tester.widget<FilledButton>(find.byType(FilledButton));
      expect(btn.onPressed, isNull);
    });

    testWidgets('displays error message from AppState', (tester) async {
      const errorText = 'اسم المستخدم أو كلمة المرور غير صحيحة';
      await _pumpLoginScreen(tester, errorMessage: errorText);

      expect(find.text(errorText), findsOneWidget);
    });

    testWidgets('toggle password visibility button exists', (tester) async {
      await _pumpLoginScreen(tester);

      // The password field has an IconButton suffix.
      expect(find.byType(IconButton), findsAtLeastNWidgets(1));
    });

    testWidgets('tapping visibility toggle changes icon', (tester) async {
      await _pumpLoginScreen(tester);

      // Initially the password is obscured → visibility icon is shown.
      expect(find.byIcon(Icons.visibility), findsOneWidget);

      await tester.tap(find.byIcon(Icons.visibility));
      await tester.pump();

      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
    });

    testWidgets('hint credentials text is displayed', (tester) async {
      await _pumpLoginScreen(tester);
      expect(find.textContaining('Najjar'), findsWidgets);
    });
  });
}
