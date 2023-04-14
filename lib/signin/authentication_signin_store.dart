import 'package:flutter_login_mobx_multi_common/common_state.dart';
import 'package:mobx/mobx.dart';

import '../authentication_exception.dart';
import 'authentication_signin_input.dart';
import 'authentication_signin_output.dart';
import 'authentication_signin_usecase.dart';

class AuthenticationSigninStore {
  AuthenticationSigninStore(
    this.authenticationSigninUsecase,
  ) {
    signIn = Action(_signIn);
  }

  final AuthenticationSigninUsecase authenticationSigninUsecase;

  final state = Observable(CommonState.initial(AuthenticationSigninOutput.empty()));

  late final Action signIn;

  void _signIn(AuthenticationSigninInput input) async {
    try {
      runInAction(() => state.value = CommonState.loading(AuthenticationSigninOutput.empty()));
      final signInOutput = await authenticationSigninUsecase.execute(input);
      runInAction(() => state.value = CommonState.success(signInOutput));
    } on AuthenticationException catch (e) {
      runInAction(() => state.value = CommonState.failure(AuthenticationSigninOutput.empty(), e.message));
    }
  }
}
