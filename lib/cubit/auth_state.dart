part of 'auth_cubit.dart';

@immutable
abstract class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthLoaded extends AuthState {
  final Map<String, dynamic>? result;
  const AuthLoaded(this.result);
}

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
}
