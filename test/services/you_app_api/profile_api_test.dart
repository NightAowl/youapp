import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:youapp/services/you_app_api/profile_api.dart';
import 'package:youapp/services/you_app_api/you_app_api.dart';

void main() {
  late ProfileApi profileApi;
  late MockClient mockHttpClient;
  const testToken = 'test_token';

  setUp(() {
    mockHttpClient = MockClient((request) async {
      return http.Response('Not Found', 404);
    });
    profileApi = ProfileApi(client: mockHttpClient);
  });

  group(
    'ProfileApi',
    () {
      test(
        'createProfile makes correct http request and returns success',
        () async {
          mockHttpClient = MockClient(
            (request) async {
              if (request.url.toString() == YouAppApi.createProfile &&
                  request.method == 'POST') {
                return http.Response(
                  '{"message": "Profile created successfully"}',
                  201,
                );
              }
              return http.Response('Not Found', 404);
            },
          );

          profileApi = ProfileApi(client: mockHttpClient);

          final response = await profileApi.createProfile(
            testToken,
            {
              'name': 'John Doe',
              'birthday': '2000-01-01',
              'height': 180,
              'weight': 75,
              'interests': ['coding']
            },
          );

          expect(response?.statusCode, 201);
          expect(
            jsonDecode(response!.body),
            {'message': 'Profile created successfully'},
          );
        },
      );

      test(
        'getProfile makes correct http request and returns profile data',
        () async {
          mockHttpClient = MockClient(
            (request) async {
              if (request.url.toString() == YouAppApi.getProfile &&
                  request.method == 'GET') {
                return http.Response(
                  '{"name": "John Doe", "birthday": "2000-01-01", "height": 180, "weight": 75, "interests": ["coding"]}',
                  200,
                );
              }
              return http.Response('Not Found', 404);
            },
          );

          profileApi = ProfileApi(client: mockHttpClient);

          final response = await profileApi.getProfile(testToken);

          expect(response?.statusCode, 200);
          expect(
            jsonDecode(response!.body),
            {
              'name': 'John Doe',
              'birthday': '2000-01-01',
              'height': 180,
              'weight': 75,
              'interests': ['coding']
            },
          );
        },
      );

      test(
        'getProfile returns error on unauthorized access',
        () async {
          mockHttpClient = MockClient(
            (request) async {
              if (request.url.toString() == YouAppApi.getProfile &&
                  request.method == 'GET') {
                return http.Response(
                  '{"error": "Unauthorized access"}',
                  401,
                );
              }
              return http.Response('Not Found', 404);
            },
          );

          profileApi = ProfileApi(client: mockHttpClient);

          final response = await profileApi.getProfile(testToken);

          expect(response?.statusCode, 401);
          expect(
            jsonDecode(response!.body),
            {'error': 'Unauthorized access'},
          );
        },
      );

      test(
        'updateProfile makes correct http request and returns success',
        () async {
          mockHttpClient = MockClient(
            (request) async {
              if (request.url.toString() == YouAppApi.updateProfile &&
                  request.method == 'PUT') {
                return http.Response(
                  '{"message": "Profile updated successfully"}',
                  200,
                );
              }
              return http.Response('Not Found', 404);
            },
          );

          profileApi = ProfileApi(client: mockHttpClient);

          final response = await profileApi.updateProfile(
            token: testToken,
            name: 'Jane Doe',
            birthday: '2001-02-02',
            height: 170,
            weight: 60,
            interests: ['reading'],
          );

          expect(response?.statusCode, 200);
          expect(
            jsonDecode(response!.body),
            {'message': 'Profile updated successfully'},
          );
        },
      );

      test(
        'updateProfile throws exception on network error',
        () async {
          mockHttpClient = MockClient(
            (request) async {
              throw Exception('Network error');
            },
          );

          profileApi = ProfileApi(client: mockHttpClient);

          expect(
            () => profileApi.updateProfile(token: testToken),
            throwsException,
          );
        },
      );
    },
  );
}
