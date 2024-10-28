import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/utils/db_helper.dart';

class SettingsView extends StatelessWidget {
  final void Function(bool) toggleThemeMode;
  final bool isDarkMode;
  const SettingsView({
    super.key,
    required this.isDarkMode,
    required this.toggleThemeMode,
  });

  @override
  Widget build(BuildContext context) {
    final db = DatabaseHelper();
    
    return Scaffold(
      backgroundColor: const Color.fromRGBO(239, 235, 206, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(239, 235, 206, 1),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => toggleThemeMode(!isDarkMode),
          ),
          SizedBox(height: 40),
          Center(
            child: ElevatedButton(
              onPressed: () {
                _showDeleteConfirmationDialog(context, db);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(47, 62, 70, 1),
              ),
              child: Text(
                "DELETE All DATA",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "WARNING: ",
                style: TextStyle(color: Colors.red, fontSize: 10),
              ),
              Text(
                "Deleting all data will remove all your data from the app.",
                style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

 
  void _showDeleteConfirmationDialog(BuildContext context, DatabaseHelper db) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromRGBO(47, 62, 70, 1),
          title: Text("Confirm Deletion", style: TextStyle(color: Colors.white)),
          content: Text("Do you really want to delete all data?", style: TextStyle(color: Colors.white)),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: const Color.fromRGBO(47, 62, 70, 1)
              ),
              onPressed: () {
                  Navigator.of(context).pop();
              },
              child: Text("No", style: TextStyle(color: Colors.white),),
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.red
              ),
              onPressed: () {
                db.deleteAllData();
                Navigator.of(context).pop(); 
                final snackBar = SnackBar(
                elevation: 0,
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.transparent,
                duration: Duration(seconds: 2),
                content: AwesomeSnackbarContent(
                title: 'Success',
                message: 'All DATA has been removed successefuly',
                contentType: ContentType.success,
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
              child: Text("Yes", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}
