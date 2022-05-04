import 'package:athlete_app_bloc/logic/blocs/auth_bloc/auth_bloc_bloc.dart';
import 'package:athlete_app_bloc/logic/blocs/logIn_bloc/login_bloc.dart';
import 'package:athlete_app_bloc/presentation/initialScreenBuilder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'injection_container.dart' as di;
import 'injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
            create: (context) => sl<AuthBloc>()..add(AppStarted())),
        BlocProvider<LoginBloc>(
            create: (context) => sl<LoginBloc>()),
      ],
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const InitialScreenBuilder(),
      ),
    );
  }
}
