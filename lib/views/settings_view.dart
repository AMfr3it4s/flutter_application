import 'package:flutter/material.dart';
import 'package:flutter_application/utils/db_helper.dart';

class SettingsView extends StatelessWidget {
  final void Function(bool) toggleThemeMode;
  final bool isDarkMode;
  const SettingsView({super.key, required this.isDarkMode, required this.toggleThemeMode});  
  
  @override
  Widget build(BuildContext context) {
  final db =  DatabaseHelper();
    return  Scaffold(
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
            child: ElevatedButton(onPressed: (){
               db.deleteAllData() ;
            }, style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromRGBO(47, 62, 70, 1)
            ),
            child: Text("DELETE All DATA", style: TextStyle(
              color: Colors.white
            ),)),
          ),
          
          
        ],
      ),
      
    );
  }
}