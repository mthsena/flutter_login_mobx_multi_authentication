import 'package:flutter_login_mobx_multi_user/user_entity.dart';

abstract class AuthenticationRepository {
  Future<UserEntity> signIn(String email, String password);
}
