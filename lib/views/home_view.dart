import 'package:flutter/material.dart';
import 'package:flutter_application/views/activity_view.dart';
import 'package:flutter_application/views/explore_view.dart';
import 'package:flutter_application/widgets/activity.dart';
import 'package:flutter_application/widgets/current_programs.dart';
import 'package:flutter_application/widgets/header.dart';
import 'heart_view.dart';

const Color bottonNavBgColor = Color.fromRGBO(47, 62, 70, 0.7);
class ResumeView extends StatefulWidget {
  final void Function(bool) toggleThemeMode;
  final bool isDarkMode;
  final List articles;

  const ResumeView({
    super.key,
    required this.toggleThemeMode,
    required this.isDarkMode,
    required this.articles,
  });

  @override
  State<ResumeView> createState() => _NotesViewState();
}

class _NotesViewState extends State<ResumeView> {

  int _selectedIndex = 0;

  // Lista de views para alternar
  static const List<Widget> _pages = <Widget>[
    HeartPage(),
    ActivityView(),
    ExploreView(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(backgroundColor: const Color.fromRGBO(239, 235, 206, 1) ,
  body: Container(
    child: _selectedIndex == 0
        ? Column(
          children: [
            SizedBox(height: 50),
            Programs(),
            SizedBox(height: 10),
            Activity(),

          ],
        )
        : _pages[_selectedIndex - 1],
  ),
bottomNavigationBar: SafeArea(
  child: Container(
    height: 49,
    margin: const EdgeInsets.fromLTRB(24, 20, 24, 26),
    decoration: BoxDecoration(
      color: bottonNavBgColor.withOpacity(0.8),
      borderRadius: BorderRadius.circular(24),
      boxShadow: const [
        BoxShadow(
          color: bottonNavBgColor,
          offset: Offset(0, 15),
          blurRadius: 30,
        ),
      ],
    ),
    child: BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home, size: 15),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.heart_broken_rounded,size: 15),
          label: 'Heart',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.local_fire_department,size: 15),
          label: 'Activity',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.grid_view_rounded, size: 15),
          label: 'Explore',
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: const Color.fromRGBO(249, 110, 70, 1),
      unselectedItemColor: Colors.white,
      type: BottomNavigationBarType.fixed, // ou BottomNavigationBarType.shifting
      backgroundColor: Colors.transparent,
      onTap: _onItemTapped,
    ),
  ),
),


);

  }
}

