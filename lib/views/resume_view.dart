import 'package:flutter/material.dart';
import 'package:flutter_application/services/auth/auth.service.dart';
import 'package:flutter_application/services/crud/notes_service.dart';
import 'package:flutter_application/views/activity_view.dart';
import 'package:flutter_application/views/explore_view.dart';
import 'package:flutter_application/views/heart_view.dart';

const Color bottonNavBgColor = Color.fromRGBO(47, 62, 70, 0.7);
class ResumeView extends StatefulWidget {
  final void Function(bool) toggleThemeMode;
  final bool isDarkMode;

  const ResumeView({
    super.key,
    required this.toggleThemeMode,
    required this.isDarkMode,
  });

  @override
  State<ResumeView> createState() => _NotesViewState();
}

class _NotesViewState extends State<ResumeView> {
  late final NotesService _notesService;
  String get userEmail => AuthService.firebase().currentUser!.email!;

  int _selectedIndex = 0;

  // Lista de views para alternar
  static const List<Widget> _pages = <Widget>[
    HeartView(),
    ActivityView(),
    ExploreView(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    _notesService = NotesService();
    super.initState();
  }

  @override
  void dispose() {
    _notesService.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(backgroundColor: const Color.fromRGBO(239, 235, 206, 1) ,
  body: Container(
    child: _selectedIndex == 0
        ? Center(
            child: FutureBuilder(
              future: _notesService.getOrCreateUser(email: userEmail),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.done:
                    return StreamBuilder(
                      stream: _notesService.allNotes,
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return const Text("Waiting for all Information...");
                          default:
                            return const Text("Hello");
                        }
                      },
                    );
                  default:
                    return const CircularProgressIndicator();
                }
              },
            ),
          )
        : _pages[_selectedIndex - 1],
  ),
bottomNavigationBar: SafeArea(
  child: Container(
    height: 60,
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
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.heart_broken_rounded),
          label: 'Heart',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.local_fire_department),
          label: 'Activity',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.grid_view_rounded),
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
