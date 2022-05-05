import 'dart:io';

import 'package:athlete_app_bloc/data/modals/user_modal.dart';
import 'package:athlete_app_bloc/logic/repositories/auth_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  AuthRepository authRepository;
  LoginBloc({required this.authRepository}) : super(LoginInitial()) {
    on<FormSubmitted>(_formSubmittedEvent);
    on<OnBoardingFormSubmitted>(_onBoardingFormSubmitted);
  }

  _formSubmittedEvent(FormSubmitted event, Emitter<LoginState> emit) async {
    emit(LoginLoading());
    final loginEither = await authRepository.loginUser(
        email: event.email, password: event.password);
    loginEither.fold((failure) => emit(LoginError(msg: failure.msg)),
        (UserModal user) async {
      emit(LoggedIn(user: user));
    });
  }

  _onBoardingFormSubmitted(OnBoardingFormSubmitted event, Emitter<LoginState> emit) async {
    emit(OnBoardingLoading());
    Map<String,dynamic> data={
      "firstName":event.firstName,
      "lastName":event.lastName,
      "birthDate":event.dob,
      "gender":event.gender
    };
    final updateEither=await authRepository.updateUser(
        data, event.profileImage!);
    updateEither.fold((failure) => emit(OnBoardingError(msg: failure.msg)),
            (UserModal user) async {
          emit(OnBoardingSuccess(user: user));
        });

  }
}
