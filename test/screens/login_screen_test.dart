import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:launch_quality_mobile/screens/login_screen.dart';
import 'package:launch_quality_mobile/services/api_client.dart';
import 'package:launch_quality_mobile/services/auth_service.dart';
import 'package:launch_quality_mobile/services/bootstrap_service.dart';
import 'package:launch_quality_mobile/state/app_state.dart';
import 'package:provider/provider.dart';

class TestAppState extends AppState {
  TestAppState._({required super.api, required super.auth, required super.bootstrap}) {
    status = AppStatus.login;
  }

  factory TestAppState() {
    final api = ApiClient(
      client: MockClient((_) async => http.Response('{"ok":true}', 200)),
    );
    return TestAppState._(
      api: api,
      auth: AuthService(api),
      bootstrap: BootstrapService(api),
    );
  }

  int loginCalls = 0;
  String? lastUsername;
  String? lastPassword;

  @override
  Future<void> login(String username, String password) async {
    loginCalls += 1;
    lastUsername = username;
    lastPassword = password;
  }
}

void main() {
  Future<void> pumpLogin(WidgetTester tester, TestAppState appState) async {
    await tester.pumpWidget(
      ChangeNotifierProvider<AppState>.value(
        value: appState,
        child: const MaterialApp(home: LoginScreen()),
      ),
    );
  }

  group('LoginScreen', () {
    testWidgets('renders login form widgets', (tester) async {
      final appState = TestAppState();
      await pumpLogin(tester, appState);

      expect(find.text('اسم المستخدم'), findsOneWidget);
      expect(find.text('كلمة المرور'), findsOneWidget);
      expect(find.text('تسجيل الدخول'), findsOneWidget);
    });

    testWidgets('empty username shows validation error', (tester) async {
      final appState = TestAppState();
      await pumpLogin(tester, appState);

      await tester.enterText(find.byType(TextField).first, '');
      await tester.enterText(find.byType(TextField).last, 'secret');
      await tester.tap(find.text('تسجيل الدخول'));
      await tester.pump();

      expect(find.text('اسم المستخدم مطلوب'), findsOneWidget);
      expect(appState.loginCalls, 0);
    });

    testWidgets('empty password shows validation error', (tester) async {
      final appState = TestAppState();
      await pumpLogin(tester, appState);

      await tester.enterText(find.byType(TextField).first, 'user');
      await tester.enterText(find.byType(TextField).last, '');
      await tester.tap(find.text('تسجيل الدخول'));
      await tester.pump();

      expect(find.text('كلمة المرور مطلوبة'), findsOneWidget);
      expect(appState.loginCalls, 0);
    });

    testWidgets('successful login flow calls app state login', (tester) async {
      final appState = TestAppState();
      await pumpLogin(tester, appState);

      await tester.enterText(find.byType(TextField).first, 'najjar');
      await tester.enterText(find.byType(TextField).last, 'pass123');
      await tester.tap(find.text('تسجيل الدخول'));
      await tester.pump();

      expect(appState.loginCalls, 1);
      expect(appState.lastUsername, 'najjar');
      expect(appState.lastPassword, 'pass123');
    });

    testWidgets('app error message is displayed', (tester) async {
      final appState = TestAppState();
      appState.errorMessage = 'خطأ في تسجيل الدخول';
      await pumpLogin(tester, appState);

      expect(find.text('خطأ في تسجيل الدخول'), findsOneWidget);
    });

    testWidgets('login button press triggers submit path', (tester) async {
      final appState = TestAppState();
      await pumpLogin(tester, appState);

      await tester.enterText(find.byType(TextField).first, 'owner');
      await tester.enterText(find.byType(TextField).last, 'owner2015');
      await tester.tap(find.text('تسجيل الدخول'));
      await tester.pump();

      expect(appState.loginCalls, greaterThan(0));
    });
  });
}
