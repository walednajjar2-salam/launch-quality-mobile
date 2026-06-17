import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/api_config.dart';

class ApiException implements Exception {
  ApiException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => message;
}

class ApiClient {
  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;
  String? _token;

  void setToken(String? token) => _token = token;
  String? get token => _token;

  Uri _uri(String path) {
    final clean = path.startsWith('/') ? path.substring(1) : path;
    return Uri.parse('${ApiConfig.baseUrl}/$clean');
  }

  Map<String, String> _headers([Map<String, String>? extra]) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (_token != null && _token!.isNotEmpty) {
      headers['Authorization'] = 'Bearer $_token';
    }
    if (extra != null) headers.addAll(extra);
    return headers;
  }

  Future<Map<String, dynamic>> get(
    String path, {
    Duration? timeout,
  }) async {
    return _decode(await _client
        .get(_uri(path), headers: _headers())
        .timeout(timeout ?? ApiConfig.defaultTimeout));
  }

  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? body,
    Duration? timeout,
  }) async {
    return _decode(await _client
        .post(
          _uri(path),
          headers: _headers(),
          body: jsonEncode(body ?? {}),
        )
        .timeout(timeout ?? ApiConfig.defaultTimeout));
  }

  Future<Map<String, dynamic>> put(
    String path, {
    required Map<String, dynamic> body,
    Duration? timeout,
  }) async {
    return _decode(await _client
        .put(
          _uri(path),
          headers: _headers(),
          body: jsonEncode(body),
        )
        .timeout(timeout ?? ApiConfig.defaultTimeout));
  }

  Future<Map<String, dynamic>> delete(
    String path, {
    Duration? timeout,
  }) async {
    return _decode(await _client
        .delete(_uri(path), headers: _headers())
        .timeout(timeout ?? ApiConfig.defaultTimeout));
  }

  Map<String, dynamic> _decode(http.Response res) {
    Map<String, dynamic> data;
    try {
      data = res.body.isEmpty
          ? <String, dynamic>{}
          : jsonDecode(res.body) as Map<String, dynamic>;
    } catch (_) {
      throw ApiException(
        res.body.isEmpty ? 'Invalid response' : res.body,
        statusCode: res.statusCode,
      );
    }

    if (res.statusCode >= 400 || data['ok'] == false) {
      final err = data['error']?.toString() ??
          data['detail']?.toString() ??
          'Request failed';
      final message = err == 'Permission denied'
          ? 'لا تملك صلاحية تنفيذ هذا الإجراء'
          : err;
      throw ApiException(message, statusCode: res.statusCode);
    }
    return data;
  }

  void dispose() => _client.close();
}
