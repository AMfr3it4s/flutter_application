import 'package:flutter/material.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter_application/constants/routes.dart';
import 'package:flutter_application/services/auth/auth_exceptions.dart';
import 'package:getwidget/getwidget.dart';
import 'package:flutter_application/services/auth/auth.service.dart';

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
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(300.0),
        child: ClipPath(
          clipper: WavyBottomClipper(),
          child: Container(
            height: 200,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/bg2.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: AppBar(
              title: const Text(
                "Login",
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
          const SizedBox(height: 4),
          _buildTextField(_email, "Enter your email!", false),
          const SizedBox(height: 15),
          _buildTextField(_password, "Enter your Password!", true),
          const SizedBox(height: 4),
          _buildActionButtons(context),
          _buildRegisterPrompt(context),
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
            await _loginUser(context);
          },
          shape: GFButtonShape.pills,
          type: GFButtonType.solid,
          size: GFSize.MEDIUM,
          color: GFColors.LIGHT,
          child: const Text(
            "Login",
            style: TextStyle(color: Colors.black),
          ),
        ),
        const SizedBox(width: 20),
        GFButton(
          onPressed: () {},
          color: GFColors.LIGHT,
          icon: const Icon(
            Icons.g_mobiledata_rounded,
            color: Colors.black,
          ),
          shape: GFButtonShape.pills,
          child: const Text("Google", style: TextStyle(color: Colors.black)),
        ),
      ],
    );
  }

  Future<void> _loginUser(BuildContext context) async {
    final email = _email.text;
    final password = _password.text;
    final scaffoldMessengerState = ScaffoldMessenger.of(context);

    try {
      await AuthService.firebase().logIn(email: email, password: password);
      final user = AuthService.firebase().currentUser;

      if (mounted) {
        if (user != null) {
          if (user.isEmailVerified) {
            Navigator.of(context)
                .pushNamedAndRemoveUntil(resumeRoute, (_) => false);
            _showSnackbar(scaffoldMessengerState, 'LogIn Successful!',
                ContentType.success);
          } else {
            Navigator.of(context)
                .pushNamedAndRemoveUntil(verifyRoute, (_) => false);
            _showSnackbar(scaffoldMessengerState, 'Please Verify Email!',
                ContentType.warning);
          }
        }
      }
    } on UserNotFoundAuthException {
      _showSnackBar(context, 'No user Found');
    } on WrongPasswordAuthException {
      _showSnackBar(context, 'Wrong Password');
    } on InvalidEmailAuthException {
      _showSnackBar(context, 'Invalid Email');
    } on GenericAuthException {
      _showSnackBar(context, 'Something unusual happened, try again');
    }
  }

  //Widgets Functions

  Widget _buildRegisterPrompt(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't you have an account?"),
        const SizedBox(width: 2),
        GestureDetector(
          onTap: () {
            Navigator.of(context)
                .pushNamedAndRemoveUntil(registerRoute, (route) => false);
          },
          child: const Text(
            "Register here!",
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Privacy & Security"),
          content: const Text(
            "We value your privacy and are committed to ensuring the security of your data. We have implemented strict measures to protect your personal information and handle it with the utmost care. Our team uses advanced technologies and best practices to maintain the confidentiality and integrity of your data at all stages of the process. Your trust is our priority, and we are always dedicated to continuously improving the security of our solutions.",
          ),
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

  //SnackBar Functions
  void _showSnackbar(ScaffoldMessengerState scaffoldMessengerState,
      String message, ContentType contentType) {
    scaffoldMessengerState.showSnackBar(
      SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Success!',
          message: message,
          contentType: contentType,
        ),
        duration: const Duration(milliseconds: 1500),
      ),
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
          title: 'LogIn Failed!',
          message: message,
          contentType: ContentType.failure,
        ),
        duration: const Duration(milliseconds: 1500),
      ),
    );
  }
}

// Class Image Format
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
