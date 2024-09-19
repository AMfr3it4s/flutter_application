import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/firebase_options.dart';
import 'package:flutter_application/views/register_view.dart';

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
        title: const Text('Login'),
        backgroundColor: colorScheme.secondary,
        foregroundColor: colorScheme.onPrimary,
      ),
      body: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return Column(
                children: [
                  TextField(
                    controller: _email,
                    enableSuggestions: false,
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    decoration:
                        const InputDecoration(hintText: "Enter Your Email"),
                  ),
                  TextField(
                    controller: _password,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration:
                        const InputDecoration(hintText: "Enter Your Password"),
                  ),
                  TextButton(
                      onPressed: () async {
                        final email = _email.text;
                        final password = _password.text;
                        final scaffoldMessengerState =
                            ScaffoldMessenger.of(context);
                        try {
                          await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                                  email: email, password: password);
                          if (mounted) {
                            scaffoldMessengerState.showSnackBar(
                              const SnackBar(
                                content: Text("Login Success"),
                                backgroundColor: Colors.green,
                              ),
                            );
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

                          // Show the message in a SnackBar
                          scaffoldMessengerState.showSnackBar(
                            SnackBar(
                              content: Text(message),
                              backgroundColor: Colors
                                  .red, // Optional: to change background color
                            ),
                          );
                        } catch (e) {
                          // General error message
                          scaffoldMessengerState.showSnackBar(
                            SnackBar(
                              content: Text('Error: $e'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      child: const Text("Login")),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RegisterView()));
                      },
                      child: const Text("Register Now"))
                ],
              );
            default:
              return const Text('Loading...');
          }
        },
      ),
    );
  }
}
