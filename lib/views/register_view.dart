import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
        title: const Text("Register"),
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
                  await FirebaseAuth.instance.createUserWithEmailAndPassword(
                      email: email, password: password);
                  scaffoldMessengerState.showSnackBar(
                    const SnackBar(
                      elevation: 0,
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.transparent,
                      content: AwesomeSnackbarContent(
                        title: 'Success!',
                        message: 'Registration Successful!',
                        contentType: ContentType.success,
                      ),
                      duration: Duration(milliseconds: 1500),
                    ),
                  );
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil("/login/", (route) => false);
                } on FirebaseAuthException catch (e) {
                  String message = '';
                  if (e.code == 'weak-password') {
                    message = "Please enter a Strong Password";
                  }
                  if (e.code == 'email-already-in-use') {
                    message = "Email already in use, Try again";
                  }
                  if (e.code == 'invalid-email') {
                    message = "Invalid Email format";
                  } else {
                    message = "Please try again";
                  }
                  scaffoldMessengerState.showSnackBar(
                    SnackBar(
                      elevation: 0,
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.transparent,
                      content: AwesomeSnackbarContent(
                        title: 'Registration Failed!',
                        message: message,
                        contentType: ContentType.failure,
                      ),
                      duration: const Duration(milliseconds: 1500),
                    ),
                  );
                }
              },
              child: const Text("Register Now")),
          TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil("/login/", (route) => false);
              },
              child: const Text("Already registered? LogIn here!"))
        ],
      ),
    );
  }
}
