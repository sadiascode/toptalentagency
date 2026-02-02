import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:logger/logger.dart';
import 'package:mime/mime.dart';
import '../token_storage_service.dart';

import 'network_response.dart';

class NetworkClient {
  final Logger _logger = Logger();
  final String _defaultErrorMessage = 'Something went wrong';

  final VoidCallback onUnAuthorize;
  final Map<String, String> Function() commonHeaders;

  NetworkClient({required this.onUnAuthorize, required this.commonHeaders});

  // Get auth token using TokenStorageService
  Future<String?> _getAuthToken() async {
    return await TokenStorageService.getStoredToken();
  }

  // Get headers with auth token
  Future<Map<String, String>> _getHeadersWithAuth() async {
    final headers = Map<String, String>.from(commonHeaders());
    final token = await _getAuthToken();
    
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
      headers['token'] = token;
      headers['x-auth-token'] = token; // Additional header format
      print('🔐 Added auth headers: Authorization (Bearer), token, x-auth-token');
    } else {
      print('⚠️ No auth token available - request may fail');
    }
    
    print('📤 Final headers: ${headers.keys.toList()}');
    return headers;
  }

  /// Multipart request for file upload
  Future<NetworkResponse> multipartRequest(
      String url, {
        required Map<String, String> fields,
        Map<String, File>? files,
        String method = 'POST',
      }) async {
    try {
      Uri uri = Uri.parse(url);

      final headers = await _getHeadersWithAuth();
      headers.remove('Content-Type'); // Let multipart set its own content type

      _logRequest(url, headers: headers, body: fields);

      final request = MultipartRequest(method, uri);
      request.headers.addAll(headers);

      // Add text fields
      request.fields.addAll(fields);

      // Add files if provided
      if (files != null && files.isNotEmpty) {
        for (final entry in files.entries) {
          final file = entry.value;
          final mimeType = lookupMimeType(file.path) ?? 'application/octet-stream';
          final parts = mimeType.split('/');
          final multipartFile = await MultipartFile.fromPath(
            entry.key,
            file.path,
            filename: file.path.split('/').last,
            contentType: MediaType(parts[0], parts[1]),
          );
          request.files.add(multipartFile);
        }
      }

      final streamedResponse = await request.send();
      final response = await Response.fromStream(streamedResponse);

      _logResponse(response);

      return _parseResponse(response);
    } catch (e) {
      return NetworkResponse(
        isSuccess: false,
        statusCode: -1,
        errorMessage: e.toString(),
      );
    }
  }

  Future<NetworkResponse> getRequest(String url) async {
    try {
      Uri uri = Uri.parse(url);
      final headers = await _getHeadersWithAuth();
      _logRequest(url, headers: headers);

      final Response response = await get(uri, headers: headers);

      _logResponse(response);

      return _parseResponse(response);
    } catch (e) {
      return NetworkResponse(
        isSuccess: false,
        statusCode: -1,
        errorMessage: e.toString(),
      );
    }
  }

  Future<NetworkResponse> postRequest(String url, {Map<String, dynamic>? body}) async {
    try {
      Uri uri = Uri.parse(url);
      final headers = await _getHeadersWithAuth();
      _logRequest(url, headers: headers, body: body);

      final Response response = await post(
        uri,
        headers: headers,
        body: jsonEncode(body ?? {}),
      );

      _logResponse(response);

      return _parseResponse(response);
    } catch (e) {
      return NetworkResponse(
        isSuccess: false,
        statusCode: -1,
        errorMessage: e.toString(),
      );
    }
  }

  Future<NetworkResponse> putRequest(String url, {Map<String, dynamic>? body}) async {
    try {
      Uri uri = Uri.parse(url);
      final headers = await _getHeadersWithAuth();
      _logRequest(url, headers: headers, body: body);

      final Response response = await put(
        uri,
        headers: headers,
        body: jsonEncode(body ?? {}),
      );

      _logResponse(response);

      return _parseResponse(response);
    } catch (e) {
      return NetworkResponse(
        isSuccess: false,
        statusCode: -1,
        errorMessage: e.toString(),
      );
    }
  }

  Future<NetworkResponse> patchRequest(String url, {Map<String, dynamic>? body}) async {
    try {
      Uri uri = Uri.parse(url);
      final headers = await _getHeadersWithAuth();
      _logRequest(url, headers: headers, body: body);

      final Response response = await patch(
        uri,
        headers: headers,
        body: jsonEncode(body ?? {}),
      );

      _logResponse(response);

      return _parseResponse(response);
    } catch (e) {
      return NetworkResponse(
        isSuccess: false,
        statusCode: -1,
        errorMessage: e.toString(),
      );
    }
  }

  Future<NetworkResponse> deleteRequest(String url, {Map<String, dynamic>? body}) async {
    try {
      Uri uri = Uri.parse(url);
      final headers = await _getHeadersWithAuth();
      _logRequest(url, headers: headers, body: body);

      final Response response = await delete(
        uri,
        headers: headers,
        body: jsonEncode(body ?? {}),
      );

      _logResponse(response);

      return _parseResponse(response);
    } catch (e) {
      return NetworkResponse(
        isSuccess: false,
        statusCode: -1,
        errorMessage: e.toString(),
      );
    }
  }

  NetworkResponse _parseResponse(Response response) {
    Map<String, dynamic>? responseBody;
    try {
      responseBody = jsonDecode(response.body);
    } catch (_) {
      responseBody = null;
    }

    if (response.statusCode == 200 || response.statusCode == 201) {
      return NetworkResponse(
        isSuccess: true,
        statusCode: response.statusCode,
        responseData: responseBody,
      );
    } else if (response.statusCode == 401) {
      onUnAuthorize();
      return NetworkResponse(
        isSuccess: false,
        statusCode: response.statusCode,
        errorMessage: "Un-authorized",
      );
    } else {
      return NetworkResponse(
        isSuccess: false,
        statusCode: response.statusCode,
        errorMessage: responseBody?['message'] ?? _defaultErrorMessage,
      );
    }
  }

  void _logRequest(String url, {Map<String, String>? headers, Map<String, dynamic>? body}) {
    _logger.i('''
💡 REQUEST
URL -> $url
HEADERS -> $headers
BODY -> ${jsonEncode(body ?? {})}
''');
  }

  void _logResponse(Response response) {
    _logger.i('''
💡 RESPONSE
URL -> ${response.request?.url}
STATUS CODE -> ${response.statusCode}
HEADERS -> ${response.request?.headers}
BODY -> ${response.body}
''');
  }
}
