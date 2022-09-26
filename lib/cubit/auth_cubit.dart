import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:only_pay/user_repository.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final UserRepository _userRepository;
  AuthCubit(this._userRepository) : super(const AuthInitial());
  Future<void> registration(String login, String password, BuildContext context,
      String collectionName) async {
    try {
      emit(const AuthLoading());
      final List<Map<String, dynamic>> result =
          await _userRepository.auth(login, password, context, collectionName);
      emit(AuthLoaded(result));
    } on AuthException {
      emit(AuthError(''));
    }
  }
}
