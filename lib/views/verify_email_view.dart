import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/constants/routes.dart';
import 'package:getwidget/getwidget.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: GFAppBar(
        title: const Text("Email Verification"),
        backgroundColor: colorScheme.primary,
        actions: [
          IconButton(
            icon: const Icon(Icons.info),
            onPressed: () {
              _showInfoDialog(context);
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 24),
          const GFTypography(
            text:
                "Before you can use the application, please verify your email.",
            type: GFTypographyType.typo1,
            icon: Icon(
              Icons.warning,
              color: Color.fromARGB(255, 255, 186, 82),
            ),
            showDivider: false,
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GFButton(
                shape: GFButtonShape.pills,
                type: GFButtonType.solid,
                color: GFColors.DARK,
                onPressed: () async {
                  final user = FirebaseAuth.instance.currentUser;
                  await user?.sendEmailVerification();
                },
                child: const Text("Send Email Verification"),
              ),
              const SizedBox(width: 15),
              GFButton(
                shape: GFButtonShape.pills,
                type: GFButtonType.solid,
                color: GFColors.DARK,
                onPressed: () async {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(loginRoute, (route) => false);
                },
                child: const Text("Email already verified?"),
              )
            ],
          ),
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
        title: const Text("Why Email Verification"),
        content: const Text(
            "Email verification is an essential step in the registration process. It ensures that the email address provided belongs to you, the user. By verifying your email, we can confirm your identity and protect your account from unauthorized access. This process helps maintain the security and integrity of our application, ensuring a safe experience for all users."),
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
