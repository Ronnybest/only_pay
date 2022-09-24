// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'registration_cubit.dart';

@immutable
abstract class RegistrationState {
  const RegistrationState();
}

class RegistrationInitial extends RegistrationState {
  const RegistrationInitial();
}

class RegistrationLoading extends RegistrationState {
  const RegistrationLoading();
}

class RegistrationLoaded extends RegistrationState {
  final MongoDbModel mongoDbModel;
  const RegistrationLoaded(this.mongoDbModel);

  // @override
  // bool operator ==(covariant RegistrationLoaded other) {
  //   if (identical(this, other)) return true;

  //   return other.mongoDbModel == mongoDbModel;
  // }

  // @override
  // int get hashCode => mongoDbModel.hashCode;
}

class RegistrationError extends RegistrationState {
  final String message;
  const RegistrationError(this.message);

  // @override
  // bool operator ==(covariant RegistrationError other) {
  //   if (identical(this, other)) return true;

  //   return other.message == message;
  // }

  // @override
  // int get hashCode => message.hashCode;
}
