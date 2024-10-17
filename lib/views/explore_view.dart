import 'package:flutter/material.dart';
import 'package:flutter_application/constants/routes.dart';
import 'package:flutter_application/views/home_view.dart';

class ExploreView extends StatelessWidget {
  const ExploreView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 100),
          const Text(
            'Health Care Categories',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(47, 62, 70, 1),
            ),
          ),
          const SizedBox(height: 50),
          // Activity Card
          Card(
            color: const Color.fromRGBO(47, 62, 70, 1), 
            clipBehavior: Clip.hardEdge,
            shape:  RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40)
            ) ,
            child: InkWell(
              splashColor: const Color.fromRGBO(47, 62, 70, 0.8),
              onTap: () {
                Navigator.of(context).pushNamed(activityRoute);
              },
              child: const SizedBox(
                width: 450,
                height: 90,
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: 
                      Icon(
                        Icons.local_fire_department,
                        color: Color.fromRGBO(249, 110, 70, 1),
                        size: 50, 
                      ),
                    ),
                    Text(
                      'Activity',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, 
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20), 
          // Heart Rate Card
          Card(
            color: const Color.fromRGBO(47, 62, 70, 1), 
            clipBehavior: Clip.hardEdge,
            shape:  RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40)
            ) ,
            child: InkWell(
              splashColor: const Color.fromRGBO(47, 62, 70, 0.8),
              onTap: () {
                Navigator.of(context).pushNamed(heartRoute);
              },
              child: const SizedBox(
                width: 450,
                height: 90,
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Icon(
                        Icons.heart_broken_rounded,
                        color: Color.fromRGBO(249, 110, 70, 1),
                        size: 50, 
                      ),
                    ),
                    Text(
                      'Heart Rate',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, 
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Nutrition Card
          Card(
            color: const Color.fromRGBO(47, 62, 70, 1), 
            clipBehavior: Clip.hardEdge,
            shape:  RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40)
            ) ,
            child: InkWell(
              splashColor: const Color.fromRGBO(47, 62, 70, 0.8),
              onTap: () {
                Navigator.of(context).pushNamed(nutritionRoute); 
              },
              child: const SizedBox(
                width: 450,
                height: 90,
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Icon(
                        Icons.local_restaurant_rounded,
                        color: Color.fromRGBO(249, 110, 70, 1),
                        size: 50, 
                      ),
                    ),
                    Text(
                      'Nutrition',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, 
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Settings Card
          Card(
            color: const Color.fromRGBO(47, 62, 70, 1), 
            clipBehavior: Clip.hardEdge,
            shape:  RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40)
            ) ,
            child: InkWell(
              splashColor: const Color.fromRGBO(47, 62, 70, 0.8),
              onTap: () {
                Navigator.of(context).pushNamed(settingsRoute); 
              },
              child: const SizedBox(
                width: 450,
                height: 90,
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Icon(
                        Icons.settings,
                        color: Color.fromRGBO(249, 110, 70, 1),
                        size: 50, 
                      ),
                    ),
                    Text(
                      'Settings',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, 
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
