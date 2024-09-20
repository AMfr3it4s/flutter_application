import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/firebase_options.dart';
import 'package:flutter_application/views/login_view.dart';
import 'package:flutter_application/views/register_view.dart';
import 'package:flutter_application/views/verify_email_view.dart';

import 'constants/routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void toggleThemeMode(bool isDarkMode) {
    setState(() {
      _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 1, 3, 48),
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark(),
      themeMode: _themeMode,
      home: HomePage(
        toggleThemeMode: toggleThemeMode,
        isDarkMode: _themeMode == ThemeMode.dark,
      ),
      routes: {
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        notesRoute: (context) => NotesView(
              toggleThemeMode: toggleThemeMode,
              isDarkMode: _themeMode == ThemeMode.dark,
            ),
        verifyRoute: (context) => const VerifyEmailView(),
        homeRoute: (context) => HomePage(
              toggleThemeMode: toggleThemeMode,
              isDarkMode: _themeMode == ThemeMode.dark,
            ),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  final void Function(bool) toggleThemeMode;
  final bool isDarkMode;

  const HomePage({
    super.key,
    required this.toggleThemeMode,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              if (user.emailVerified) {
                return NotesView(
                  toggleThemeMode: toggleThemeMode,
                  isDarkMode: isDarkMode,
                );
              } else {
                return const VerifyEmailView();
              }
            } else {
              return const LoginView();
            }
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}

enum MenuAction { logout, darkMode }

class NotesView extends StatefulWidget {
  final void Function(bool) toggleThemeMode;
  final bool isDarkMode;

  const NotesView({
    super.key,
    required this.toggleThemeMode,
    required this.isDarkMode,
  });

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Main UI"),
        actions: [
          PopupMenuButton<MenuAction>(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogOutDialog(context);
                  if (shouldLogout) {
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil(loginRoute, (_) => false);
                  }
                  break;
                case MenuAction.darkMode:
                  widget.toggleThemeMode(!widget.isDarkMode);
                  Navigator.pop(context);
                  break;
              }
            },
            itemBuilder: (context) {
              return [
                const PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text("LogOut"),
                ),
                PopupMenuItem<MenuAction>(
                  value: MenuAction.darkMode,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Dark Mode"),
                      Switch(
                        value: widget.isDarkMode,
                        onChanged: (value) {
                          widget.toggleThemeMode(value);
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
              ];
            },
          ),
        ],
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      body: const Center(
        child: Text("Hello World"),
      ),
    );
  }
}

Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('SignOut'),
        content: const Text("Are you sure you want to sign out?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text("LogOut"),
          )
        ],
      );
    },
  ).then((value) => value ?? false);
}
