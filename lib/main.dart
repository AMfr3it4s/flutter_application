import 'package:flutter/material.dart';
import 'package:flutter_application/views/activity_view.dart';
import 'package:flutter_application/views/explore_view.dart';
import 'package:flutter_application/views/heart.dart';
import 'package:flutter_application/views/nutrition_view.dart';
import 'package:flutter_application/views/home_view.dart';
import 'package:flutter_application/views/settings_view.dart';

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
        resumeRoute: (context) => ResumeView(
              toggleThemeMode: toggleThemeMode,
              isDarkMode: _themeMode == ThemeMode.dark,
            ),
        homeRoute: (context) => HomePage(
              toggleThemeMode: toggleThemeMode,
              isDarkMode: _themeMode == ThemeMode.dark,
            ),
        activityRoute: (context) => const ActivityView(),
        heartRoute: (context) =>  const HeartPage(),
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
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor:  const Color.fromRGBO(239, 235, 206, 1),
      //   actions: [
      //     IconButton(
      //       icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
      //       onPressed: () => toggleThemeMode(!isDarkMode),
      //     ),
      //   ],
      // ),
      body: ResumeView(toggleThemeMode: toggleThemeMode,
  isDarkMode: !isDarkMode,) 
    );
  }
}
