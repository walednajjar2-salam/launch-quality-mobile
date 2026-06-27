import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'config/web_app_config.dart';

class LaunchQualityWebApp extends StatelessWidget {
  const LaunchQualityWebApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'جودة الانطلاقة',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0D9488)),
        useMaterial3: true,
      ),
      home: const WebShellScreen(),
    );
  }
}

class WebShellScreen extends StatefulWidget {
  const WebShellScreen({super.key});

  @override
  State<WebShellScreen> createState() => _WebShellScreenState();
}

class _WebShellScreenState extends State<WebShellScreen> {
  final GlobalKey webViewKey = GlobalKey();
  InAppWebViewController? _controller;
  double _progress = 0;
  String? _error;

  Future<bool> _onWillPop() async {
    final controller = _controller;
    if (controller != null && await controller.canGoBack()) {
      await controller.goBack();
      return false;
    }
    return true;
  }

  Future<void> _reload() async {
    setState(() => _error = null);
    await _controller?.loadUrl(
      urlRequest: URLRequest(url: WebUri(WebAppConfig.appUrl)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldPop = await _onWillPop();
        if (shouldPop && context.mounted) {
          await SystemNavigator.pop();
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              InAppWebView(
                key: webViewKey,
                initialUrlRequest: URLRequest(
                  url: WebUri(WebAppConfig.appUrl),
                ),
                initialSettings: InAppWebViewSettings(
                  javaScriptEnabled: true,
                  domStorageEnabled: true,
                  databaseEnabled: true,
                  supportZoom: true,
                  builtInZoomControls: true,
                  displayZoomControls: false,
                  useWideViewPort: true,
                  allowsInlineMediaPlayback: true,
                  mediaPlaybackRequiresUserGesture: false,
                  transparentBackground: true,
                ),
                onWebViewCreated: (controller) => _controller = controller,
                onLoadStart: (_, __) {
                  if (!mounted) return;
                  setState(() {
                    _error = null;
                    _progress = 0;
                  });
                },
                onProgressChanged: (_, progress) {
                  if (!mounted) return;
                  setState(() => _progress = progress / 100);
                },
                onLoadStop: (_, __) {
                  if (!mounted) return;
                  setState(() => _progress = 1);
                },
                onReceivedError: (controller, request, error) {
                  if (!mounted || request.isForMainFrame != true) return;
                  setState(() {
                    _error = error.description;
                    _progress = 1;
                  });
                },
                onReceivedHttpError: (controller, request, response) {
                  if (!mounted || request.isForMainFrame != true) return;
                  final status = response.statusCode;
                  if (status != null && status >= 400) {
                    setState(() {
                      _error = 'HTTP $status';
                      _progress = 1;
                    });
                  }
                },
              ),
              if (_progress < 1)
                LinearProgressIndicator(
                  value: _progress > 0 ? _progress : null,
                  minHeight: 3,
                ),
              if (_error != null)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.cloud_off, size: 48),
                        const SizedBox(height: 12),
                        Text(
                          'تعذر تحميل النظام',
                          style: Theme.of(context).textTheme.titleMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _error!,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        FilledButton.icon(
                          onPressed: _reload,
                          icon: const Icon(Icons.refresh),
                          label: const Text('إعادة المحاولة'),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
