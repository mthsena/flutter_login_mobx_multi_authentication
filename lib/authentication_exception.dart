import 'package:flutter_login_mobx_multi_common/common_exception.dart';

abstract class AuthenticationException extends CommonException {
  const AuthenticationException(super.message);
}

class EmptyEmailAuthenticationException extends AuthenticationException {
  const EmptyEmailAuthenticationException(super.message);
}

class EmptyPasswordAuthenticationException extends AuthenticationException {
  const EmptyPasswordAuthenticationException(super.message);
}

class WrongCredentialsAuthenticationException extends AuthenticationException {
  const WrongCredentialsAuthenticationException(super.message);
}
