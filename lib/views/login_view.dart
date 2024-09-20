import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

// LoginPage

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        backgroundColor: colorScheme.secondary,
        foregroundColor: colorScheme.onSecondary,
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(hintText: "Enter Your Email"),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(hintText: "Enter Your Password"),
          ),
          TextButton(
              onPressed: () async {
                final email = _email.text;
                final password = _password.text;
                final scaffoldMessengerState = ScaffoldMessenger.of(context);

                try {
                  UserCredential userCredential = await FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                          email: email, password: password);

                  User? user = userCredential.user;

                  if (mounted) {
                    if (user != null) {
                      if (user.emailVerified) {
                        Navigator.of(context)
                            .pushNamedAndRemoveUntil('/notes/', (_) => false);
                        Future.delayed(Duration.zero, () {
                          scaffoldMessengerState.showSnackBar(
                            const SnackBar(
                              elevation: 0,
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.transparent,
                              content: AwesomeSnackbarContent(
                                title: 'Success!',
                                message: 'LogIn Successful!',
                                contentType: ContentType.success,
                              ),
                              duration: Duration(milliseconds: 1500),
                            ),
                          );
                        });
                      } else {
                        Navigator.of(context)
                            .pushNamedAndRemoveUntil('/verify/', (_) => false);
                        Future.delayed(Duration.zero, () {
                          scaffoldMessengerState.showSnackBar(
                            const SnackBar(
                              elevation: 0,
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.transparent,
                              content: AwesomeSnackbarContent(
                                title: 'Please Verify Email!',
                                message: 'LogIn Successful!',
                                contentType: ContentType.warning,
                              ),
                              duration: Duration(milliseconds: 1500),
                            ),
                          );
                        });
                      }
                    }
                  }
                } on FirebaseAuthException catch (e) {
                  String message = '';
                  if (e.code == 'invalid-email') {
                    message = 'No user found with this email.';
                  } else if (e.code == 'invalid-credential') {
                    message = 'Incorrect password.';
                  } else {
                    message = 'Login failed. Please try again.';
                  }

                  scaffoldMessengerState.showSnackBar(
                    SnackBar(
                      elevation: 0,
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.transparent,
                      content: AwesomeSnackbarContent(
                        title: 'LogIn Failed!',
                        message: message,
                        contentType: ContentType.failure,
                      ),
                      duration: const Duration(milliseconds: 1500),
                    ),
                  );
                } catch (e) {
                  scaffoldMessengerState.showSnackBar(
                    SnackBar(
                      elevation: 0,
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.transparent,
                      content: AwesomeSnackbarContent(
                        title: 'LogIn Failed!',
                        message: "Error: $e",
                        contentType: ContentType.failure,
                      ),
                      duration: const Duration(milliseconds: 1500),
                    ),
                  );
                }
              },
              child: const Text("Login")),
          TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil("/register/", (route) => false);
              },
              child: const Text("Not registered yet? Register here! "))
        ],
      ),
    );
  }
}
