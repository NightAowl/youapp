import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:youapp/services/you_app_api/auth_api.dart';
import 'package:youapp/services/you_app_api/you_app_api.dart';

void main() {
  late AuthApi authApi;
  late MockClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockClient((request) async {
      return http.Response('Not Found', 404);
    });
    authApi = AuthApi(client: mockHttpClient);
  });

  group(
    'AuthApi',
    () {
      test(
        'register makes correct http request and returns success',
        () async {
          mockHttpClient = MockClient(
            (request) async {
              if (request.url.toString() == YouAppApi.register &&
                  request.method == 'POST') {
                return http.Response('{"access_token": "mock_token"}', 201);
              }
              return http.Response('Not Found', 404);
            },
          );

          authApi = AuthApi(client: mockHttpClient);

          final response = await authApi.register(
            'test@email.com',
            'username',
            'password',
          );

          expect(response?.statusCode, 201);
          expect(
            jsonDecode(response!.body),
            {'access_token': 'mock_token'},
          );
        },
      );

      test(
        'register returns user exists error',
        () async {
          mockHttpClient = MockClient(
            (request) async {
              if (request.url.toString() == YouAppApi.register &&
                  request.method == 'POST') {
                return http.Response('{"error": "User already exists"}', 400);
              }
              return http.Response('Not Found', 404);
            },
          );

          authApi = AuthApi(client: mockHttpClient);

          final response = await authApi.register(
            'test@email.com',
            'username',
            'password',
          );

          expect(response?.statusCode, 400);
          expect(
            jsonDecode(response!.body),
            {'error': 'User already exists'},
          );
        },
      );

      test(
        'register throws exception on network error',
        () async {
          mockHttpClient = MockClient((request) async {
            throw Exception('Network error');
          });

          authApi = AuthApi(client: mockHttpClient);

          expect(
            () => authApi.register('test@email.com', 'username', 'password'),
            throwsException,
          );
        },
      );

      test(
        'login makes correct http request and returns success',
        () async {
          mockHttpClient = MockClient(
            (request) async {
              if (request.url.toString() == YouAppApi.login &&
                  request.method == 'POST') {
                return http.Response('{"access_token": "mock_token"}', 200);
              }
              return http.Response('Not Found', 404);
            },
          );

          authApi = AuthApi(client: mockHttpClient);

          final response = await authApi.login('test@email.com', 'password');

          expect(response?.statusCode, 200);
          expect(
            jsonDecode(response!.body),
            {'access_token': 'mock_token'},
          );
        },
      );

      test(
        'login returns user not found error',
        () async {
          mockHttpClient = MockClient(
            (request) async {
              if (request.url.toString() == YouAppApi.login &&
                  request.method == 'POST') {
                return http.Response('{"error": "User not found"}', 404);
              }
              return http.Response('Not Found', 404);
            },
          );

          authApi = AuthApi(client: mockHttpClient);

          final response = await authApi.login('test@email.com', 'password');

          expect(response?.statusCode, 404);
          expect(
            jsonDecode(response!.body),
            {'error': 'User not found'},
          );
        },
      );

      test(
        'login throws exception on network error',
        () async {
          mockHttpClient = MockClient(
            (request) async {
              throw Exception('Network error');
            },
          );

          authApi = AuthApi(client: mockHttpClient);

          expect(
            () => authApi.login('test@email.com', 'password'),
            throwsException,
          );
        },
      );
    },
  );
}
