import 'package:flutter/material.dart';

import 'app.dart';
import 'utils/performance_monitor.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final monitor = PerformanceMonitor();
  monitor.startTimer('startup');
  runApp(LaunchQualityApp(onReady: () => monitor.endTimer('startup')));
}
