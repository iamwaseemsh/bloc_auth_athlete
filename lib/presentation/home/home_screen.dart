import 'package:athlete_app_bloc/logic/blocs/auth_bloc/auth_bloc_bloc.dart';
import 'package:athlete_app_bloc/logic/blocs/logIn_bloc/login_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home Screen")),
      body: BlocBuilder<AuthBloc, AuthBlocState>(
        builder: (context, state) {
          if(state is Authenticated){
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(state.userModal.athlete.firstName),
                Center(
                  child: TextButton(child: Text("Logout"), onPressed: () {
                    context.read<AuthBloc>().add(LogOut());
                  },),
                ),
              ],
            );
          }
          return Center(child: CircularProgressIndicator(),);

        },
      ),
    );
  }
}
