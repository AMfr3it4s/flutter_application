import 'package:flutter/material.dart';
import 'package:flutter_application/constants/routes.dart';
import 'package:flutter_application/widgets/custom_card.dart';


class ExploreView extends StatelessWidget {
  const ExploreView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Center(
        child: Column(
          children: [
            const SizedBox(height: 50),
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
            CustomCard(route: activityRoute, title: "Activity", icon: Icons.local_fire_department),
            const SizedBox(height: 20), 
            // Heart Rate Card
            CustomCard(route: heartRoute, title: "Heart Rate", icon: Icons.heart_broken_rounded),
            const SizedBox(height: 20),
            // Nutrition Card
            CustomCard(route: nutritionRoute, title: "Water", icon: Icons.water_drop_rounded),
            const SizedBox(height: 20),
            // Settings Card
            CustomCard(route: settingsRoute, title: "Settings", icon: Icons.settings),
            const SizedBox(height: 20),
                        
          ],
        ),
      ),
    );
  }
}
