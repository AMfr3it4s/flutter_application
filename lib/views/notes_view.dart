import 'package:flutter/material.dart';
import 'package:flutter_application/constants/routes.dart';
import 'package:flutter_application/enums/menu_action.dart';
import 'package:flutter_application/services/auth/auth.service.dart';

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
                    await AuthService.firebase().logOut();
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
