import 'package:athlete_app_bloc/logic/blocs/auth_bloc/auth_bloc_bloc.dart';
import 'package:athlete_app_bloc/presentation/auth/login_screen/login_screen.dart';
import 'package:athlete_app_bloc/presentation/auth/on_boarding_screen/on_boarding_screen.dart';
import 'package:athlete_app_bloc/presentation/home/home_screen.dart';
import 'package:athlete_app_bloc/presentation/splash_screen/splash_screen.dart';
import 'package:athlete_app_bloc/utils/appServices.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InitialScreenBuilder extends StatelessWidget {
  const InitialScreenBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthBlocState>(
      listener: (context, state) {
       if(state is AuthError){
         AppServices.showSnackBar(context, state.msg);
       }
      },
      builder: (context, state) {
        if (state is Authenticated) {
          return const HomeScreen();
        } else if (state is ShowOnBoardingScreen) {
          return  OnBoardingScreen();
        } else if (state is Unauthenticated) {
          return LoginScreen();
        } else {
          return const SplashScreen();
        }
      },
    );
  }
}
