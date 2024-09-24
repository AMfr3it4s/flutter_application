import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/constants/routes.dart';
import 'package:flutter_application/services/auth/auth.service.dart';
import 'package:flutter_application/services/auth/auth_exceptions.dart';
import 'package:getwidget/getwidget.dart';

// RegisterPage
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
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(300.0),
        child: ClipPath(
          clipper: WavyBottomClipper(),
          child: Container(
            height: 400,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/bg2.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: AppBar(
              title: const Text(
                "Registration",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
              ),
              centerTitle: false,
              elevation: 0,
              backgroundColor: const Color.fromARGB(90, 0, 0, 0),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 4),
          _buildTextField(_email, "Enter your email!", false),
          const SizedBox(height: 15),
          _buildTextField(_password, "Enter your Password!", true),
          const SizedBox(height: 4),
          _buildActionButtons(context),
          const SizedBox(height: 4),
          _buildLoginPrompt(context),
        ],
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, bool obscure) {
    return SizedBox(
      width: 300,
      height: 40,
      child: GFTextField(
        controller: controller,
        enableSuggestions: false,
        autocorrect: false,
        obscureText: obscure,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GFButton(
          onPressed: () async {
            await _registerUser(context);
          },
          shape: GFButtonShape.pills,
          type: GFButtonType.solid,
          size: GFSize.MEDIUM,
          color: GFColors.LIGHT,
          child: const Text(
            "Registration",
            style: TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }

  Future<void> _registerUser(BuildContext context) async {
    final email = _email.text;
    final password = _password.text;
    final scaffoldMessengerState = ScaffoldMessenger.of(context);

    try {
      await AuthService.firebase().createUser(email: email, password: password);
      await AuthService.firebase().sendEmailVerification();

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
          .pushNamedAndRemoveUntil(loginRoute, (route) => false);
    } on WeakPasswordAuthException {
      _showSnackBar(context, 'Please enter a Strong Password');
    } on EmailAlreadyInUserAuthException {
      _showSnackBar(context, 'Email already in use, Try again');
    } on InvalidEmailAuthException {
      _showSnackBar(context, 'Invalid Email');
    } on GenericAuthException {
      _showSnackBar(context, 'Please try again');
    }
  }

  Widget _buildLoginPrompt(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("You already registered?"),
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
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    scaffoldMessenger.showSnackBar(
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
