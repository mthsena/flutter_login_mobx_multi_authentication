import '../authentication_exception.dart';
import '../authentication_repository.dart';
import 'authentication_signin_input.dart';
import 'authentication_signin_output.dart';
import 'authentication_signin_usecase.dart';

class AuthenticationSigninUsecaseDefault implements AuthenticationSigninUsecase {
  const AuthenticationSigninUsecaseDefault(
    this.authenticationRepository,
  );

  final AuthenticationRepository authenticationRepository;

  @override
  Future<AuthenticationSigninOutput> execute(AuthenticationSigninInput input) async {
    if (input.email.isEmpty) throw const EmptyEmailAuthenticationException('E-mail está vazio.');
    if (input.password.isEmpty) throw const EmptyPasswordAuthenticationException('Senha está vazia.');
    final userEntity = await authenticationRepository.signIn(input.email, input.password);
    return AuthenticationSigninOutput(user: userEntity.user);
  }
}
