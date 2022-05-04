part of 'auth_bloc_bloc.dart';

abstract class AuthBlocState extends Equatable {
  const AuthBlocState();

  @override
  List<Object> get props => [];
}

class Uninitialized extends AuthBlocState {}

// ignore: must_be_immutable
class Authenticated extends AuthBlocState {
  UserModal userModal;
  Authenticated({required this.userModal});
  @override
  List<Object> get props => [userModal];
}

class ShowOnBoardingScreen extends AuthBlocState {}

class Unauthenticated extends AuthBlocState {}

class AuthError extends AuthBlocState {
  final String msg;
  const AuthError({required this.msg});
  @override
  List<Object> get props => [msg];
}
