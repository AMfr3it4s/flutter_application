import 'package:flutter/material.dart';

class CustomCardHome extends StatelessWidget {
  final String title;
  final String unit;
  final IconData icon;
  final String value;

  const CustomCardHome({super.key, required this.title, required this.unit, required this.icon, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromRGBO(47, 62, 70, 1),
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40),
      ),
        child: SizedBox(
          width: 350,
          height: 150,
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Icon(
                  icon, 
                  color: Color.fromRGBO(249, 110, 70, 1),
                  size: 60,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title, 
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Text(
                        value.toString(),
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: Colors.white
                        ),
                        ),
                        SizedBox(width: 10),
                        Text(
                          unit,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.white
                          ),
                          )
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      );
  }
}