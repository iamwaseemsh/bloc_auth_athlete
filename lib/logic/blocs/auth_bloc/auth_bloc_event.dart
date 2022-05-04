part of 'auth_bloc_bloc.dart';

abstract class AuthBlocEvent extends Equatable {
  const AuthBlocEvent();

  @override
  List<Object> get props => [];
}

class AppStarted extends AuthBlocEvent {}
class NewLoggedIn extends AuthBlocEvent{
  final UserModal user;
  const NewLoggedIn({required this.user});
  @override
  
  List<Object> get props => [user];
}
