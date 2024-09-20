import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter_application/constants/routes.dart';
import 'package:getwidget/getwidget.dart';

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
      appBar: GFAppBar(
        title: const Text("Login"),
        centerTitle: false,
        elevation: 4,
        actions: [
          IconButton(
            icon: const Icon(Icons.info),
            onPressed: () {
              _showInfoDialog(context);
            },
          ),
        ],
        backgroundColor: colorScheme.primary,
      ),
      body: Column(
        children: [
          GFTextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: "Enter your email!",
            ),
          ), //GFTextField Email

          GFTextField(
            controller: _password,
            enableSuggestions: false,
            autocorrect: false,
            obscureText: true,
            decoration:
                const InputDecoration(labelText: "Enter your Password!"),
          ), //GFTextField Password

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GFButton(
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
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              notesRoute, (_) => false);
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
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              verifyRoute, (_) => false);
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
                shape: GFButtonShape.pills,
                type: GFButtonType.solid,
                size: GFSize.MEDIUM,
                color: GFColors.DARK,
                child: const Text("Login"),
              ),
              const SizedBox(width: 20),
              GFButton(
                onPressed: () {},
                color: GFColors.DARK,
                text: "Google",
                icon: const Icon(
                  Icons.g_mobiledata_rounded,
                  color: Colors.white,
                ),
                shape: GFButtonShape.pills,
              ),
            ],
          ),
          GFButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(registerRoute, (route) => false);
              },
              shape: GFButtonShape.pills,
              type: GFButtonType.solid,
              size: GFSize.MEDIUM,
              color: GFColors.DARK,
              child: const Text("Not registered yet? Register here! "))
        ],
      ),
    );
  }
}

void _showInfoDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Privacy & Security"),
        content: const Text(
            "We value your privacy and are committed to ensuring the security of your data. We have implemented strict measures to protect your personal information and handle it with the utmost care. Our team uses advanced technologies and best practices to maintain the confidentiality and integrity of your data at all stages of the process. Your trust is our priority, and we are always dedicated to continuously improving the security of our solutions."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Close"),
          ),
        ],
      );
    },
  );
}
