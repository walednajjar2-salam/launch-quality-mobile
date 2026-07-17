import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import '../theme/app_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _userCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;
  String? _validationError;

  @override
  void dispose() {
    _userCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final username = _userCtrl.text.trim();
    final password = _passCtrl.text;
    if (username.isEmpty) {
      setState(() => _validationError = 'اسم المستخدم مطلوب');
      return;
    }
    if (password.isEmpty) {
      setState(() => _validationError = 'كلمة المرور مطلوبة');
      return;
    }
    setState(() => _validationError = null);
    await HapticFeedback.lightImpact();
    await context.read<AppState>().login(username, password);
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final loading = app.status == AppStatus.loading;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: LuxuryBackground(
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 460),
                  child: GlassCard(
                    accent: BrandColors.gold,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: Image.asset(
                              'assets/logo.png',
                              width: 96,
                              height: 96,
                              errorBuilder: (_, __, ___) => Icon(
                                Icons.apartment_rounded,
                                size: 72,
                                color: BrandColors.goldBright,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'جودة الانطلاقة للخدمات',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: BrandColors.goldBright,
                              ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Najjar / Najjar2026 · owner / owner2015',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: BrandColors.textMuted, fontSize: 12),
                        ),
                        const SizedBox(height: 24),
                        TextField(
                          controller: _userCtrl,
                          enabled: !loading,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(labelText: 'اسم المستخدم'),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _passCtrl,
                          enabled: !loading,
                          obscureText: _obscure,
                          onSubmitted: (_) => _submit(),
                          decoration: InputDecoration(
                            labelText: 'كلمة المرور',
                            suffixIcon: IconButton(
                              onPressed: () => setState(() => _obscure = !_obscure),
                              icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
                            ),
                          ),
                        ),
                        if (_validationError != null || app.errorMessage != null) ...[
                          const SizedBox(height: 12),
                          Text(
                            _validationError ?? app.errorMessage!,
                            style: const TextStyle(color: BrandColors.danger),
                          ),
                        ],
                        const SizedBox(height: 20),
                        FilledButton(
                          onPressed: loading ? null : _submit,
                          child: Text(loading ? 'جاري الدخول...' : 'تسجيل الدخول'),
                        ),
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: loading
                              ? null
                              : () async {
                                  await HapticFeedback.selectionClick();
                                  if (context.mounted) context.go('/portal');
                                },
                          child: const Text('بوابة المستأجر (portal_token)'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
