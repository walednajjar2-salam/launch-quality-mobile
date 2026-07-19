import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'screens/login_screen.dart';
import 'screens/portal/portal_gate_screen.dart';
import 'screens/portal/portal_shell.dart';
import 'screens/staff_shell.dart';
import 'services/api_client.dart';
import 'services/auth_service.dart';
import 'services/bootstrap_service.dart';
import 'services/portal_service.dart';
import 'state/app_state.dart';
import 'state/portal_state.dart';

GoRouter createRouter(AppState app, PortalState portal) {
  return GoRouter(
    refreshListenable: Listenable.merge([app, portal]),
    initialLocation: '/',
    redirect: (context, state) {
      final loc = state.uri.path;
      final staffNeedsLogin =
          app.status == AppStatus.login || app.status == AppStatus.booting;

      if (loc.startsWith('/portal')) {
        if (loc == '/portal/app' && portal.status != PortalStatus.ready) {
          return '/portal';
        }
        return null;
      }

      if (staffNeedsLogin && loc != '/') return '/';
      if (app.status == AppStatus.ready && loc == '/') return '/staff';
      if (app.status == AppStatus.error && loc != '/staff') return '/staff';
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
      GoRoute(
        path: '/portal',
        builder: (context, state) => PortalGateScreen(
          initialToken: state.uri.queryParameters['token'] ??
              state.uri.queryParameters['t'],
        ),
      ),
      GoRoute(
        path: '/portal/app',
        builder: (_, __) => const PortalShell(),
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
  late final PortalService _portalService;
  late final AppState _app;
  late final PortalState _portal;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _api = ApiClient();
    _auth = AuthService(_api);
    _bootstrap = BootstrapService(_api);
    _portalService = PortalService(_api);
    _app = AppState(api: _api, auth: _auth, bootstrap: _bootstrap);
    _portal = PortalState(_portalService);
    _router = createRouter(_app, _portal);
    _app.boot();
    _portal.boot();
  }

  @override
  void dispose() {
    _api.dispose();
    _app.dispose();
    _portal.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _app),
        ChangeNotifierProvider.value(value: _portal),
        Provider.value(value: _bootstrap),
        Provider.value(value: _auth),
        Provider.value(value: _portalService),
      ],
      child: MaterialApp.router(
        title: 'جودة الانطلاقة',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.light,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF00639A),
            brightness: Brightness.light,
          ),
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF00639A),
            brightness: Brightness.dark,
          ),
        ),
        themeMode: ThemeMode.system,
        routerConfig: _router,
        builder: (context, child) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: child ?? const SizedBox.shrink(),
          );
        },
      ),
    );
  }
}
