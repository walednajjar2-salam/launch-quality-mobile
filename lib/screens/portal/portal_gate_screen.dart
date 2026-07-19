import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../state/portal_state.dart';
import '../../widgets/common.dart';

class PortalGateScreen extends StatefulWidget {
  const PortalGateScreen({super.key, this.initialToken});

  final String? initialToken;

  @override
  State<PortalGateScreen> createState() => _PortalGateScreenState();
}

class _PortalGateScreenState extends State<PortalGateScreen> {
  final _tokenCtrl = TextEditingController();
  bool _booted = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialToken != null && widget.initialToken!.isNotEmpty) {
      _tokenCtrl.text = widget.initialToken!;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_booted) {
      _booted = true;
      final portal = context.read<PortalState>();
      if (widget.initialToken != null && widget.initialToken!.isNotEmpty) {
        portal.openWithToken(widget.initialToken!);
      }
    }
  }

  @override
  void dispose() {
    _tokenCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final portal = context.watch<PortalState>();

    if (portal.status == PortalStatus.ready) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) context.go('/portal/app');
      });
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 460),
                  child: AppCard(
                    accent: Theme.of(context).colorScheme.secondary,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                          child: Image.asset(
                            'assets/logo.png',
                            width: 88,
                            height: 88,
                            errorBuilder: (_, __, ___) => Icon(
                              Icons.home_work_outlined,
                              size: 64,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'بوابة المستأجر',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'أدخل portal_token من رابط البوابة',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: _tokenCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Portal Token',
                            hintText: 'الصق الرمز من الرابط',
                          ),
                        ),
                        if (portal.errorMessage != null) ...[
                          const SizedBox(height: 12),
                          Text(portal.errorMessage!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
                        ],
                        const SizedBox(height: 16),
                        FilledButton(
                          onPressed: portal.status == PortalStatus.loading
                              ? null
                              : () => portal.openWithToken(_tokenCtrl.text),
                          child: Text(
                            portal.status == PortalStatus.loading
                                ? 'جاري التحقق...'
                                : 'فتح البوابة',
                          ),
                        ),
                        TextButton(
                          onPressed: () => context.go('/'),
                          child: const Text('العودة لتسجيل الموظفين'),
                        ),
                      ],
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
