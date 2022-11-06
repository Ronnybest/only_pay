part of 'posts_cubit.dart';

@immutable
abstract class PostsState {
  const PostsState();
}

class PostsInitial extends PostsState {
  const PostsInitial();
}

class PostsLoading extends PostsState {
  const PostsLoading();
}

class PostsLoaded extends PostsState {
  const PostsLoaded(this.allPosts);
  final List<dynamic> allPosts;
}

class PostsError extends PostsState {
  const PostsError(this.message);
  final String message;
}
