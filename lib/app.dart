import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'screens/login_screen.dart';
import 'screens/staff_shell.dart';
import 'services/api_client.dart';
import 'services/auth_service.dart';
import 'services/bootstrap_service.dart';
import 'state/app_state.dart';
import 'theme/app_theme.dart';

GoRouter createRouter(AppState app) {
  return GoRouter(
    refreshListenable: app,
    initialLocation: '/',
    redirect: (context, state) {
      final loc = state.matchedLocation;
      final ready = app.status == AppStatus.ready;
      final needsLogin = app.status == AppStatus.login ||
          app.status == AppStatus.booting ||
          app.status == AppStatus.error;
      if (needsLogin && loc != '/') return '/';
      if (ready && loc == '/') return '/staff';
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (_, __) => const LoginScreen(),
      ),
      GoRoute(
        path: '/staff',
        builder: (_, __) => const StaffShell(),
      ),
    ],
  );
}

class LaunchQualityApp extends StatefulWidget {
  const LaunchQualityApp({super.key});

  @override
  State<LaunchQualityApp> createState() => _LaunchQualityAppState();
}

class _LaunchQualityAppState extends State<LaunchQualityApp> {
  late final ApiClient _api;
  late final AuthService _auth;
  late final BootstrapService _bootstrap;
  late final AppState _app;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _api = ApiClient();
    _auth = AuthService(_api);
    _bootstrap = BootstrapService(_api);
    _app = AppState(api: _api, auth: _auth, bootstrap: _bootstrap);
    _router = createRouter(_app);
    _app.boot();
  }

  @override
  void dispose() {
    _api.dispose();
    _app.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _app),
        Provider.value(value: _bootstrap),
        Provider.value(value: _auth),
      ],
      child: MaterialApp.router(
        title: 'Launch Quality Staff',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        routerConfig: _router,
        builder: (context, child) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Consumer<AppState>(
              builder: (_, app, __) {
                if (app.status == AppStatus.loading ||
                    app.status == AppStatus.booting) {
                  return const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                }
                return child ?? const SizedBox.shrink();
              },
            ),
          );
        },
      ),
    );
  }
}
