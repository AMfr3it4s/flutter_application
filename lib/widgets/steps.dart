import 'package:flutter/material.dart';
import 'package:flutter_application/views/helpers.dart';

class Steps extends StatelessWidget {
  const Steps({super.key});

  @override
  Widget build(BuildContext context) {

    // Insted of Random need to be Fetch Data From DB 
    String steps = formatnumber( randBetween(3000, 6000));

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