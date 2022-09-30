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
  final Map<String, dynamic> mongoDbModel;
  const RegistrationLoaded(this.mongoDbModel);
}

class RegistrationError extends RegistrationState {
  final String message;
  const RegistrationError(this.message);
}
