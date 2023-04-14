import 'dart:math';

import 'package:flutter_login_mobx_multi_user/user_entity.dart';
import 'package:flutter_login_mobx_multi_user/user_model.dart';

import 'authentication_exception.dart';
import 'authentication_repository.dart';

class AuthenticationRepositoryDefault implements AuthenticationRepository {
  @override
  Future<UserEntity> signIn(String email, String password) async {
    await Future.delayed(const Duration(seconds: 2));
    if (email != 'test@gmail.com' || password != '1234567890') throw const WrongCredentialsAuthenticationException('E-mail ou senha incorretos.');
    return UserEntity(
      uuid: Random().nextInt(1000).toString(),
      updatedAt: DateTime.now(),
      createdAt: DateTime.now(),
      user: UserModel(
        email: email,
        password: '',
      ),
    );
  }
}
