part of 'login_bloc.dart';

@immutable
abstract class LoginState extends Equatable {
  @override
  
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoggedIn extends LoginState {
  final UserModal user;
  LoggedIn({required this.user});
  @override

  List<Object?> get props => [user];
}

class LoginError extends LoginState{
  final String msg;
  LoginError({required this.msg});
  @override
  // TODO: implement props
  List<Object?> get props => [msg];
}
