import 'package:flutter/material.dart';
import 'package:flutter_application/widgets/activity.dart';

class OverallView extends StatefulWidget {
  const OverallView({super.key});

  @override
  State<OverallView> createState() => _OverallViewState();
}

class _OverallViewState extends State<OverallView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  const Color.fromRGBO(239, 235, 206, 1),
      appBar: AppBar(
        backgroundColor:  const Color.fromRGBO(239, 235, 206, 1),
      ),
      body: Column(
        children: [
          Activity()
        ],
      ),
      
    );
  }
}