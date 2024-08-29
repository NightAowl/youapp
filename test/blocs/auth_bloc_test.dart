import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:youapp/blocs/auth_bloc/auth_bloc.dart';
import 'package:youapp/blocs/auth_bloc/auth_event.dart';
import 'package:youapp/blocs/auth_bloc/auth_state.dart';
import 'package:youapp/services/you_app_api/auth_api.dart';
import 'package:http/http.dart' as http;

@GenerateMocks([AuthApi])
import 'auth_bloc_test.mocks.dart';

void main() {
  late AuthBloc authBloc;
  late MockAuthApi mockAuthApi;

  setUp(() {
    mockAuthApi = MockAuthApi();
    authBloc = AuthBloc(mockAuthApi);
  });

  tearDown(() {
    authBloc.close();
  });

  group(
    'AuthBloc',
    () {
      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthSuccess] when RegisterEvent is added and registration is successful',
        build: () {
          when(
            mockAuthApi.register(
              'test@email.com',
              'username',
              'Test@1234',
            ),
          ).thenAnswer(
            (_) async => http.Response(
              jsonEncode({'access_token': 'mock_token'}),
              200,
            ),
          );
          return authBloc;
        },
        act: (bloc) async {
          bloc.add(
            RegisterEvent(
              email: 'test@email.com',
              username: 'username',
              password: 'Test@1234',
            ),
          );
        },
        expect: () => [
          isA<AuthLoading>(),
          isA<AuthSuccess>(),
        ],
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthFailure] when RegisterEvent is added and registration fails',
        build: () {
          when(mockAuthApi.register(
            'test@email.com',
            'username',
            'Test@1234',
          )).thenAnswer(
            (_) async => http.Response(
              jsonEncode({'error': 'Registration failed'}),
              400,
            ),
          );
          return authBloc;
        },
        act: (bloc) => bloc.add(
          RegisterEvent(
            email: 'test@email.com',
            username: 'username',
            password: 'Test@1234',
          ),
        ),
        expect: () => [
          isA<AuthLoading>(),
          isA<AuthFailure>(),
        ],
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthSuccess] when LoginEvent is added and login is successful',
        build: () {
          when(mockAuthApi.login(
            'test@email.com',
            'password',
          )).thenAnswer(
            (_) async => http.Response(
              jsonEncode({'access_token': 'mock_token'}),
              200,
            ),
          );
          return authBloc;
        },
        act: (bloc) => bloc.add(
          LoginEvent(
            email: 'test@email.com',
            password: 'password',
          ),
        ),
        expect: () => [
          isA<AuthLoading>(),
          isA<AuthSuccess>(),
        ],
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthFailure] when LoginEvent is added and login fails',
        build: () {
          when(mockAuthApi.login(
            'test@email.com',
            'password',
          )).thenAnswer(
            (_) async => http.Response(
              jsonEncode({'error': 'Login failed'}),
              400,
            ),
          );
          return authBloc;
        },
        act: (bloc) => bloc.add(
          LoginEvent(
            email: 'test@email.com',
            password: 'password',
          ),
        ),
        expect: () => [
          isA<AuthLoading>(),
          isA<AuthFailure>(),
        ],
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthInitial] when LogoutEvent is added',
        build: () => authBloc,
        act: (bloc) => bloc.add(LogoutEvent()),
        expect: () => [isA<AuthInitial>()],
      );
    },
  );
}
