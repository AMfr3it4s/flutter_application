import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application/firebase_options.dart';

//RegisterPage
class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
        title: const Text('Register'),
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
                              .createUserWithEmailAndPassword(
                                  email: email, password: password);
                          scaffoldMessengerState.showSnackBar(
                            const SnackBar(
                              content: Text("Register Success"),
                              backgroundColor: Colors.green,
                            ),
                          );
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'weak-password') {
                            scaffoldMessengerState.showSnackBar(
                              const SnackBar(
                                content: Text('Weak-Password'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                          if (e.code == 'email-already-in-use') {
                            scaffoldMessengerState.showSnackBar(
                              const SnackBar(
                                content: Text('Email Already Registered'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }

                          if (e.code == 'invalid-email') {
                            scaffoldMessengerState.showSnackBar(
                              const SnackBar(
                                content: Text('Invalid Email'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          } else {
                            scaffoldMessengerState.showSnackBar(
                              const SnackBar(
                                content: Text('Failed to Register'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      },
                      child: const Text("Register")),
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
