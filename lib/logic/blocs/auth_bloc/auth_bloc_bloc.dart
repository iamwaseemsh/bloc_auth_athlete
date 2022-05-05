import 'package:athlete_app_bloc/data/modals/user_modal.dart';
import 'package:athlete_app_bloc/logic/repositories/auth_repo.dart';
import 'package:athlete_app_bloc/logic/services/network_info.dart';
import 'package:athlete_app_bloc/logic/services/secure_storage.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'auth_bloc_event.dart';
part 'auth_bloc_state.dart';

class AuthBloc extends Bloc<AuthBlocEvent, AuthBlocState> {
  final AuthRepository authRepository;
  final SecureStorageService secureStorage;
  final NetworkInfo networkInfo;
  AuthBloc(
      {required this.authRepository,
      required this.secureStorage,
      required this.networkInfo})
      : super(Uninitialized()) {
    on<AppStarted>(_onAppStartedEvent);
    on<NewLoggedIn>(_newLoggedInEvent);
    on<LogOut>(_logoutEvent);
  }
  Future<void> _onAppStartedEvent(
      AppStarted appStarted, Emitter<AuthBlocState> emit) async {
    if (await networkInfo.isConnected) {
      final ifLoggedIn = await authRepository.checkIfLogin();
      print(ifLoggedIn);
      if (ifLoggedIn) {
        final user = await authRepository.getCurrentUser();
        if (user.athlete.firstName.isEmpty ||
            user.athlete.profileImageUrl.isEmpty) {
          return emit(ShowOnBoardingScreen());
        }
        return emit(Authenticated(userModal: user));
      } else {
        return emit(Unauthenticated());
      }
    } else {
      print('not connected');
      emit(const AuthError(msg: 'Not connected to Internet'));
    }
  }

  Future<void> _newLoggedInEvent(
      NewLoggedIn event, Emitter<AuthBlocState> emit) async {

    if (event.user.athlete.firstName.isEmpty ||
        event.user.athlete.profileImageUrl.isEmpty) {
      return emit(ShowOnBoardingScreen());
    }
    emit(Authenticated(userModal: event.user));

  }  Future<void> _logoutEvent(
      LogOut event, Emitter<AuthBlocState> emit) async {
   await authRepository.removeUser();
   emit(Unauthenticated());
  }
}
