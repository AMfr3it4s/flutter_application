import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/main.dart';

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
                  await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: email, password: password);
                  if (mounted) {
                    scaffoldMessengerState.showSnackBar(
                      const SnackBar(
                        content: Text("Login Success"),
                        backgroundColor: Colors.green,
                      ),
                    );
                    await Future.delayed(const Duration(milliseconds: 500));

                    Navigator.of(context)
                        .pushNamedAndRemoveUntil('/notes/', (route) => false);
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
                      backgroundColor:
                          Colors.red, // Optional: to change background color
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
                Navigator.of(context)
                    .pushNamedAndRemoveUntil("/register/", (route) => false);
              },
              child: const Text("Not registered yet? Register here! "))
        ],
      ),
    );
  }
}
