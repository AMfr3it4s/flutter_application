import 'package:flutter/material.dart';

class HeartView extends StatelessWidget {
  const HeartView({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: const Color.fromRGBO(239, 235, 206, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(239, 235, 206, 1),
      ),
      body: const Center(
        child: Text("Heart Rate"),
      ),
    );
  }
}