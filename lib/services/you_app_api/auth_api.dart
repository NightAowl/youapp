import 'dart:convert';
import 'package:http/http.dart' as http;
import 'you_app_api.dart';

class AuthApi {
  final http.Client _client;

  AuthApi({http.Client? client}) : _client = client ?? http.Client();

  Future<http.Response?> register(
    String email,
    String username,
    String password,
  ) async {
    try {
      final response = await _client.post(
        Uri.parse(YouAppApi.register),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(
          {
            'email': email,
            'username': username,
            'password': password,
          },
        ),
      );

      return response;
    } on Exception catch (_) {
      rethrow;
    }
  }

  Future<http.Response?> login(String email, String password) async {
    try {
      final response = await _client.post(
        Uri.parse(YouAppApi.login),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(
          {
            'email': email,
            'username': '',
            'password': password,
          },
        ),
      );

      return response;
    } on Exception catch (_) {
      rethrow;
    }
  }
}
