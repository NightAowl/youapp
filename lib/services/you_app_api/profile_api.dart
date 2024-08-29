import 'dart:convert';
import 'package:http/http.dart' as http;
import 'you_app_api.dart';

class ProfileApi {
  final http.Client _client;

  ProfileApi({http.Client? client}) : _client = client ?? http.Client();
  Future<http.Response?> createProfile(
    String token,
    Map<String, dynamic> profileData,
  ) async {
    try {
      final response = await _client.post(
        Uri.parse(YouAppApi.createProfile),
        headers: _buildHeaders(token),
        body: jsonEncode(profileData),
      );

      return response;
    } catch (_) {
      rethrow;
    }
  }

  Future<http.Response?> getProfile(String token) async {
    try {
      final response = await _client.get(
        Uri.parse(YouAppApi.getProfile),
        headers: _buildHeaders(token),
      );

      return response;
    } catch (_) {
      rethrow;
    }
  }

  Future<http.Response?> updateProfile({
    required String token,
    String name = '',
    String birthday = '',
    int height = -1,
    int weight = -1,
    List<String> interests = const [],
  }) async {
    try {
      final response = await _client.put(
        Uri.parse(YouAppApi.updateProfile),
        headers: _buildHeaders(token),
        body: jsonEncode(
          {
            if (name.isNotEmpty) 'name': name,
            if (birthday.isNotEmpty) 'birthday': birthday,
            if (height != -1) 'height': height,
            if (weight != -1) 'weight': weight,
            if (interests.isNotEmpty) 'interests': interests,
          },
        ),
      );

      return response;
    } catch (_) {
      rethrow;
    }
  }

  Map<String, String> _buildHeaders(String token) {
    return {
      'Content-Type': 'application/json',
      'x-access-token': token,
    };
  }
}
