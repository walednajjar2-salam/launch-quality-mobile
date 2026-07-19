import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'learning/bank_home_demo_screen.dart';

/// نقطة تشغيل الديمو التعليمي لواجهة البنك التجريبية.
///
/// التشغيل:
///   flutter run -t lib/main_bank_demo.dart
///
/// لتغيير الرصيد أو الاسم أو الحساب:
///   عدّل الملف: lib/learning/bank_home_demo_data.dart
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: Color(0xFF0A1A30),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const BankHomeDemoApp());
}

class BankHomeDemoApp extends StatelessWidget {
  const BankHomeDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bank Home Demo (Learning)',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      home: const BankHomeDemoScreen(),
    );
  }
}
