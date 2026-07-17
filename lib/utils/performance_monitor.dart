import 'dart:developer' as developer;

class PerformanceMonitor {
  static final _instance = PerformanceMonitor._();

  factory PerformanceMonitor() => _instance;
  PerformanceMonitor._();

  final Map<String, DateTime> _starts = {};
  final Map<String, Duration> _timings = {};

  void startTimer(String label) {
    _starts[label] = DateTime.now();
    developer.log('⏱️  Starting: $label', name: 'PerformanceMonitor');
  }

  void endTimer(String label) {
    final start = _starts.remove(label);
    if (start == null) return;
    final duration = DateTime.now().difference(start);
    _timings[label] = duration;
    developer.log(
      '✅ $label took ${duration.inMilliseconds}ms',
      name: 'PerformanceMonitor',
    );
  }

  void logMetric(String name, int value, String unit) {
    developer.log('📊 $name: $value $unit', name: 'PerformanceMonitor');
  }

  Map<String, dynamic> getMetrics() => {
        'startup_time': _timings['startup']?.inMilliseconds,
        'dashboard_load': _timings['dashboard']?.inMilliseconds,
        'api_call': _timings['api']?.inMilliseconds,
      };
}
