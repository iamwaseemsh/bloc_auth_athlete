import 'package:athlete_app_bloc/logic/blocs/auth_bloc/auth_bloc_bloc.dart';
import 'package:athlete_app_bloc/logic/blocs/logIn_bloc/login_bloc.dart';
import 'package:athlete_app_bloc/logic/repositories/auth_repo.dart';
import 'package:athlete_app_bloc/logic/services/network_info.dart';
import 'package:athlete_app_bloc/logic/services/secure_storage.dart';
import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

final sl = GetIt.instance;
Future init() async {
  //bloc

  sl.registerFactory(() =>
      AuthBloc(authRepository: sl(), secureStorage: sl(), networkInfo: sl()));
  sl.registerFactory(() => LoginBloc(authRepository: sl()));

  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  sl.registerLazySingleton(() => AuthRepository());
  sl.registerLazySingleton(() => SecureStorageService());
  sl.registerLazySingleton(() => JwtDecoder());
  sl.registerLazySingleton(() => DataConnectionChecker());
}
