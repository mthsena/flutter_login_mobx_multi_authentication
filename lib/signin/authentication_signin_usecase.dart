import 'authentication_signin_input.dart';
import 'authentication_signin_output.dart';

abstract class AuthenticationSigninUsecase {
  Future<AuthenticationSigninOutput> execute(AuthenticationSigninInput input);
}
