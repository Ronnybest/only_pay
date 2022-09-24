import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:only_pay/models/mongodbmodels.dart';

import '../user_repository.dart';

part 'registration_state.dart';

class RegistrationCubit extends Cubit<RegistrationState> {
  final UserRepository _userRepository;
  RegistrationCubit(this._userRepository) : super(const RegistrationInitial());

  Future<void> connection(String userName, String login, String password,
      String collectionName, BuildContext context) async {
    try {
      emit(const RegistrationLoading());
      final MongoDbModel userData = await _userRepository.connect(
          userName, login, password, context, collectionName);
      emit(RegistrationLoaded(userData));
    } on RegException {
      emit(const RegistrationError('Ошибка при создании профиля'));
    }
  }
}
