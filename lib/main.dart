import 'package:flutter/material.dart';
import 'package:flutter_application/views/activity_view.dart';
import 'package:flutter_application/views/explore_view.dart';
import 'package:flutter_application/views/heart_view.dart';
import 'package:flutter_application/views/login_view.dart';
import 'package:flutter_application/views/nutrition_view.dart';
import 'package:flutter_application/views/resume_view.dart';
import 'package:flutter_application/views/register_view.dart';
import 'package:flutter_application/views/settings_view.dart';
import 'package:flutter_application/views/verify_email_view.dart';
import 'package:flutter_application/services/auth/auth.service.dart';

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
      title: 'Health',
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
        resumeRoute: (context) => ResumeView(
              toggleThemeMode: toggleThemeMode,
              isDarkMode: _themeMode == ThemeMode.dark,
            ),
        verifyRoute: (context) => const VerifyEmailView(),
        homeRoute: (context) => HomePage(
              toggleThemeMode: toggleThemeMode,
              isDarkMode: _themeMode == ThemeMode.dark,
            ),
        activityRoute: (context) => const ActivityView(),
        heartRoute: (context) =>  const HeartView(),
        exploreRoute: (context) => const ExploreView(),
        nutritionRoute:(context) => const  NutritionView(),
        settingsRoute:(context) => const  SettingsView(),



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
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            if (user != null) {
              if (user.isEmailVerified) {
                return ResumeView(
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
