import 'package:flutter/material.dart';


class Steps extends StatelessWidget {
  final String steps;
  const Steps({
    super.key, required this.steps 
    });

  @override
  Widget build(BuildContext context) {

      return Padding(
      padding: const  EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
           Text(
            steps, 
            style: const TextStyle(
            fontSize: 33,
            fontWeight: FontWeight.w900
          ),),
          const Text("Total Steps", style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            height: 2,
          ),),
        ],
      ),
    );
  }
}