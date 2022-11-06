import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:only_pay/models/post_model.dart';
import 'package:only_pay/user_repository.dart';

part 'addpost_state.dart';

class AddpostCubit extends Cubit<AddpostState> {
  final UserRepository _userRepository;
  AddpostCubit(this._userRepository) : super(const AddpostInitial());
  Future<void> uploadPost(
      PostModel model, BuildContext context, String collectionName) async {
    try {
      emit(const AddpostLoading());
      await _userRepository.uploadPost(model, collectionName, context);
      emit(const AddpostLoaded());
    } on AddpostError {
      emit(const AddpostError('Ошибка загрузки поста'));
    }
  }
}
