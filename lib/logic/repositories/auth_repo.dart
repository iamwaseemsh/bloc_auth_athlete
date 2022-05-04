import 'dart:convert';
import 'package:jwt_decoder/jwt_decoder.dart';

import 'package:athlete_app_bloc/data/constants/web.dart';
import 'package:athlete_app_bloc/data/modals/failure.dart';
import 'package:athlete_app_bloc/data/modals/user_modal.dart';
import 'package:athlete_app_bloc/injection_container.dart';
import 'package:athlete_app_bloc/logic/services/network_info.dart';
import 'package:athlete_app_bloc/logic/services/secure_storage.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class AuthRepository {
  final SecureStorageService secureStorageService = sl<SecureStorageService>();
  final NetworkInfo networkInfo = sl<NetworkInfo>();

  final JwtDecoder jwtDecoder = sl<JwtDecoder>();
  Future<bool> checkIfLogin() async {
    final result = await secureStorageService.read(key: 'token');
    print(result);

    if (result != null) {
      if (isExpired(result)) {
        final newToken = await refreshToken(result);
        await secureStorageService.write(key: 'token', value: newToken);
      }
      return true;
    } else {
      return false;
    }
  }

  Future<Either<Failure, UserModal>> loginUser(
      {required String email, required String password}) async {
    if (await networkInfo.isConnected) {
      final Dio _dio = Dio();
      try {
        var formData = FormData.fromMap({"email": email, "password": password});
        final result = await _dio.post(kBaseUrl + kLoginUrl, data: formData);
        final user = UserModal.fromJson(result.data);
        await storeUser(user.token);
        return Right(user);
      } on DioError catch (e) {
        if (e.response?.data != null) {
          return Left(Failure(e.response?.data['msg'] ?? 'Server Error'));
        }
        return Left(Failure(e.response?.statusMessage ?? 'Server Error'));
      }
    } else {
      return Left(Failure('Connect to the internet'));
    }
  }

  Future<UserModal> getCurrentUser() async {
    final token = await secureStorageService.read(key: 'token');

    final Dio _dio = Dio();
    _dio.options.headers['x-token'] = token;
    final result = await _dio.get(
      kBaseUrl + kGetProfile,
    );
    return UserModal.fromJson(result.data);
  }

  Future<void> storeUser(String token) async {
    await secureStorageService.write(key: 'token', value: token);
  }

  bool isExpired(String token) {
    return JwtDecoder.isExpired(token);
  }

  Future refreshToken(String oldToken) async {
    final Dio _dio = Dio();
    final result = await _dio.get(
      kBaseUrl + kRefreshTokenUrl,
    );
    return result.data['token'];
  }
}
