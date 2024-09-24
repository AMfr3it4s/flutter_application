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
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(300.0),
        child: ClipPath(
          clipper: WavyBottomClipper(),
          child: Container(
            height: 500,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/bg2.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: AppBar(
              title: const Text(
                "Email Verification",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
              ),
              centerTitle: false,
              elevation: 0,
              backgroundColor: const Color.fromARGB(90, 0, 0, 0),
              actions: [
                IconButton(
                  icon: const Icon(Icons.info),
                  onPressed: () {
                    _showInfoDialog(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
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
                color: GFColors.LIGHT,
                onPressed: () async {
                  final user = FirebaseAuth.instance.currentUser;
                  await user?.sendEmailVerification();
                },
                child: const Text(
                  "Send Email Verification",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              const Text("You already verified your email?"),
              const SizedBox(width: 2),
              GestureDetector(
                onTap: () {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(loginRoute, (route) => false);
                },
                child: const Text(
                  "LogIn here!",
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          )
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

class WavyBottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 30);
    path.quadraticBezierTo(
      size.width / 4,
      size.height,
      size.width / 2,
      size.height - 50,
    );
    path.quadraticBezierTo(
      (size.width * 3) / 4,
      size.height - 100,
      size.width,
      size.height - 30,
    );
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
