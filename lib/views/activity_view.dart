import 'package:flutter/material.dart';

class ActivityView extends StatelessWidget {
  const ActivityView({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: const Color.fromRGBO(239, 235, 206, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(239, 235, 206, 1),
      ),
      body: const Center(
        child: Text("Activity"),
      ),
    );
  }
}