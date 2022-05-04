part of 'login_bloc.dart';

@immutable
abstract class LoginEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}



class FormSubmitted extends LoginEvent {
  final String email;
  final String password;
  FormSubmitted({required this.email, required this.password});
  @override
  // TODO: implement props
  List<Object?> get props => [email, password];
}
class LogOut extends LoginEvent{
  
}
