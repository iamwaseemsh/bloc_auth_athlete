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

// event for uploading user info

class OnBoardingFormSubmitted extends LoginEvent{
  final String firstName;
  final String lastName;
  final String gender;
  final String dob;
  final File? profileImage;
  OnBoardingFormSubmitted({
   required this.profileImage,
    required this.lastName,
    required this.firstName,
    required this.dob,
    required this.gender
});
  @override
  List<Object?> get props => [profileImage,lastName,firstName,dob,gender];
}
