part of 'addpost_cubit.dart';

@immutable
abstract class AddpostState {
  const AddpostState();
}

class AddpostInitial extends AddpostState {
  const AddpostInitial();
}

class AddpostLoading extends AddpostState {
  const AddpostLoading();
}

class AddpostLoaded extends AddpostState {
  const AddpostLoaded();
}

class AddpostError extends AddpostState {
  final String message;
  const AddpostError(this.message);
}
