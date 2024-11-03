import 'package:flutter/material.dart';
import 'package:flutter_application/utils/db_helper.dart';
import 'package:flutter_application/utils/tracker_helper.dart';
import 'package:flutter_application/views/activity_view.dart';
import 'package:flutter_application/views/explore_view.dart';
import 'package:flutter_application/views/heart_view.dart';
import 'package:flutter_application/views/map_view.dart';
import 'package:flutter_application/views/nutrition_view.dart';
import 'package:flutter_application/views/home_view.dart';
import 'package:flutter_application/views/overall_view.dart';
import 'package:flutter_application/views/settings_view.dart';
import 'constants/routes.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDatabase();
  StepCounterService().initialize();
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
              articles: [],
            ),
        homeRoute: (context) => HomePage(
              toggleThemeMode: toggleThemeMode,
              isDarkMode: _themeMode == ThemeMode.dark,
            ),
        activityRoute: (context) => const ActivityView(),
        heartRoute: (context) =>  const HeartPage(),
        exploreRoute: (context) => const ExploreView(),
        nutritionRoute:(context) => const  NutritionView(),
        settingsRoute:(context) => SettingsView(toggleThemeMode: toggleThemeMode,
              isDarkMode: _themeMode == ThemeMode.dark),
        overallRoute: (context) => const OverallView(),
        mapRoute: (context) => const MapsView()
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
      body: ResumeView(toggleThemeMode: toggleThemeMode,
  isDarkMode: !isDarkMode, articles: [],) 
    );
  }
}

Future<void> initializeDatabase() async {
  final dbHelper = DatabaseHelper();
  await dbHelper.database;
}
