import 'package:flutter/material.dart';
import 'package:flutter_login_mobx_multi_theming/theming_store.dart';
import 'package:flutter_login_mobx_multi_user/user_page.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import 'signin/authentication_signin_input.dart';
import 'signin/authentication_signin_store.dart';

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage(
    this.authenticationSigninStore,
    this.themingStore, {
    super.key,
  });

  final AuthenticationSigninStore authenticationSigninStore;
  final ThemingStore themingStore;

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool rememberLogin = false;
  bool passwordHidden = true;
  bool emailIsOk = false;
  bool passwordIsOk = false;

  @override
  void initState() {
    super.initState();
    emailController.addListener(() {
      final validation = emailValidator(emailController.text);
      setState(() {
        emailIsOk = validation == null ? true : false;
      });
    });
    passwordController.addListener(() {
      final validation = passwordValidator(passwordController.text);
      setState(() {
        passwordIsOk = validation == null ? true : false;
      });
    });
    widget.authenticationSigninStore.state.observe((e) {
      if (e.newValue == null) return;
      if (e.newValue!.status.isFailure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.newValue!.message),
          ),
        );
      }
      if (e.newValue!.status.isSuccess) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => UserPage(
              widget.themingStore,
              user: e.newValue!.value.user,
            ),
          ),
        );
      }
    });
  }

  String? emailValidator(String? text) {
    final email = text ?? '';
    if (email.isEmpty) return 'E-mail cannot be empty.';
    if (!email.contains('@') || !email.contains('.com')) return 'You must enter a valid e-mail address.';
    return null;
  }

  String? passwordValidator(String? text) {
    final password = text ?? '';
    if (password.isEmpty) return 'Password cannot be empty.';
    if (password.length < 6) return 'You must enter at least a 6 characters password.';
    return null;
  }

  void togglePassword() {
    setState(() {
      passwordHidden = !passwordHidden;
    });
  }

  void checkRememberLogin(bool? value) {
    setState(() {
      rememberLogin = value ?? false;
    });
  }

  void signIn() async {
    widget.authenticationSigninStore.signIn(
      [
        AuthenticationSigninInput(
          email: emailController.text,
          password: passwordController.text,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Authentication'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'SIGNIN',
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: Theme.of(context).textTheme.titleLarge?.fontSize,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Welcome to Flutter Login Mobx MonoRepo.',
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.bodyLarge?.fontSize,
                  color: Colors.black26,
                ),
              ),
              const SizedBox(height: 40),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  label: Text('E-mail'),
                ),
                validator: emailValidator,
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(
                  label: const Text('Password'),
                  suffixIcon: InkWell(
                    onTap: togglePassword,
                    child: Icon(passwordHidden ? Icons.visibility_off : Icons.visibility),
                  ),
                ),
                obscureText: passwordHidden,
                validator: passwordValidator,
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Checkbox(
                    value: rememberLogin,
                    onChanged: checkRememberLogin,
                  ),
                  const Text('Remember me?')
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Observer(
                  builder: (context) {
                    return ElevatedButton(
                      onPressed: !widget.authenticationSigninStore.state.value.status.isLoading && emailIsOk && passwordIsOk ? signIn : null,
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all(const EdgeInsets.all(20)),
                      ),
                      child: widget.authenticationSigninStore.state.value.status.isLoading
                          ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator())
                          : const Text('SIGNIN'),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
