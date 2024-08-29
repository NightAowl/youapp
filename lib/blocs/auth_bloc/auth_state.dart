abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final dynamic data;
  final String token;

  AuthSuccess(this.data, this.token);
}

class AuthFailure extends AuthState {
  final String error;

  AuthFailure(this.error);
}
