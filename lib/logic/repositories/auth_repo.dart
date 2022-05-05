import 'dart:convert';
import 'dart:io';
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


      if (isExpired(result)==true) {
        print('this is expired');
        final newToken = await refreshToken(result);
        await secureStorageService.write(key: 'token', value: newToken);
      }
      return true;
    } else {
      return false;
    }
  }
  Future checkForToken()async{
    final token = await secureStorageService.read(key: 'token');
    if (isExpired(token!)==true) {
      print('this is expired');
      final newToken = await refreshToken(token);
      await secureStorageService.write(key: 'token', value: newToken);
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
    await checkForToken();
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
  Future removeUser()async{
    await secureStorageService.delete(key: 'token');

  }

  Future refreshToken(String oldToken) async {
    final Dio _dio = Dio();
    _dio.options.headers['x-token'] = oldToken;
    final result = await _dio.get(
      kBaseUrl + kRefreshTokenUrl,
    );
    return result.data['token'];
  }

  Future<Either<Failure, UserModal>> updateUser(Map<String,dynamic> data,File image)async{
    if (await networkInfo.isConnected) {
      await checkForToken();
      final Dio _dio = Dio();
      final token = await secureStorageService.read(key: 'token');
      _dio.options.headers['x-token']=token;
      try {
        String profileImageUrl=await uploadImage(image, token!);
        print(profileImageUrl);

        final result = await _dio.put(kBaseUrl + kUpdateProfile, data: data);

        final user = await getCurrentUser();

        return Right(user);
      } on DioError catch (e) {
        print(e.response?.data);
        if (e.response?.data != null) {
          return Left(Failure(e.response?.data['msg'] ?? 'Server Error'));
        }
        return Left(Failure(e.response?.statusMessage ?? 'Server Error'));
      }
    } else {
      return Left(Failure('Connect to the internet'));
    }

  }


  Future<String> uploadImage(File file,String token) async {

    String fileName = file.path.split('/').last;
    FormData formData = FormData.fromMap({
      "file":
      await MultipartFile.fromFile(file.path, filename:fileName),
    });
    final Dio _dio = Dio();
    _dio.options.headers['x-token']=token;
    final response = await _dio.put(kBaseUrl+kUpdateProfileImage, data: formData);
    return response.data['profileImageUrl'];
  }

}
