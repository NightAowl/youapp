import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../services/you_app_api/auth_api.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthApi _authApi;

  AuthBloc(this._authApi) : super(AuthInitial()) {
    on<RegisterEvent>(_handleRegister);
    on<LoginEvent>(_handleLogin);
    on<LogoutEvent>(_handleLogout);
  }

  Future<void> _handleRegister(
    RegisterEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());
      final response = await _authApi.register(
        event.email,
        event.username,
        event.password,
      );

      if (response != null &&
          (response.statusCode == 200 || response.statusCode == 201)) {
        final data = jsonDecode(response.body);
        final token = data['access_token'];
        emit(AuthSuccess(data, token));
      } else {
        emit(AuthFailure('Registration failed'));
      }
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _handleLogin(
    LoginEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());
      final response = await _authApi.login(
        event.email,
        event.password,
      );

      if (response != null &&
          (response.statusCode == 200 || response.statusCode == 201)) {
        final data = jsonDecode(response.body);
        final token = data['access_token'];

        emit(AuthSuccess(data, token));
      } else {
        emit(AuthFailure('Login failed'));
      }
    } catch (_) {
      emit(AuthFailure('Login failed'));
    }
  }

  Future<void> _handleLogout(
    LogoutEvent event,
    Emitter<AuthState> emit,
  ) async {
    // logout logic
    emit(AuthInitial());
  }
}
