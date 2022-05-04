import 'package:athlete_app_bloc/logic/blocs/auth_bloc/auth_bloc_bloc.dart';
import 'package:athlete_app_bloc/logic/blocs/logIn_bloc/login_bloc.dart';
import 'package:athlete_app_bloc/logic/services/validators.dart';
import 'package:athlete_app_bloc/presentation/widgets/custom_text_field.dart';
import 'package:athlete_app_bloc/utils/appServices.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../widgets/custom_button.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);
  final formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: formKey,
          child: Column(children: [
            TextFieldWidgetType1(
              validator: Validators().validateEmail,
              hintText: 'Email',
              isEmail: true,
              onChanged: (value) {
                email = value!;
                return null;
              },
            ),
            TextFieldWidgetType1(
              validator: Validators().validatePassword,
              hintText: 'Password',
              isPassword: true,
              onChanged: (value) {
                password = value!;
                return null;
              },
            ),
            BlocConsumer<LoginBloc, LoginState>(
              listener: (context, state) {
                if (state is LoginError) {
                  AppServices.showSnackBar(context, state.msg);
                }
                if(state is LoggedIn){
                  context.read<AuthBloc>().add(NewLoggedIn(user: state.user));
                }
              },
              builder: (context, state) {
                if (state is LoginLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return CustomButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      
                      context
                          .read<LoginBloc>()
                          .add(FormSubmitted(email: email, password: password));
                    }
                  },
                  title: 'Login',
                );
              },
            ),
          ]),
        ),
      ),
    );
  }
}
