import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final String route;
  final String title;
  final IconData icon; 

  const CustomCard({
    super.key, 
    required this.route,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromRGBO(47, 62, 70, 1),
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40),
      ),
      child: InkWell(
        splashColor: const Color.fromRGBO(47, 62, 70, 0.8),
        onTap: () {
          Navigator.of(context).pushNamed(route);
        },
        child: SizedBox(
          width: 350,
          height: 60,
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Icon(
                  icon, 
                  color: Color.fromRGBO(249, 110, 70, 1),
                  size: 30,
                ),
              ),
              Text(
                title, 
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
