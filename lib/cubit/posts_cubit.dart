import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';

import '../user_main_page_functions.dart';

part 'posts_state.dart';

class PostsCubit extends Cubit<PostsState> {
  final MainPageFunctions _mainPageFunctions;
  PostsCubit(this._mainPageFunctions) : super(const PostsInitial());
  Future<void> getAllPosts(String collectionName) async {
    try {
      emit(PostsLoading());
      final List<dynamic> userPost =
          await _mainPageFunctions.displayAllPosts(collectionName);
      emit(PostsLoaded(userPost));
    } on PostException {
      emit(PostsError('Ошибка при загрузке постов'));
    }
  }
}
