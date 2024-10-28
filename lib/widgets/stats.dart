import 'package:flutter/material.dart';

class Stats extends StatelessWidget {
  final double time;
  final  double distance;
  final int calories;

  const Stats({super.key, required this.calories, required this.distance, required this.time});

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        Row(
          children: [
            Text("Workout Stats",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800
            ),),
            SizedBox(width: 8),
            Icon(Icons.pie_chart_rounded, size: 15,
            color: Color.fromRGBO(47, 62, 70, 1))
          ],
        ),
        SizedBox(height: 15),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
                  SizedBox(width: 25),
                  InfoStat(
                  icon: Icons.timelapse_rounded,
                  iconColor: Color(0xff535bed),
                  iconBackground: Color(0xffe4e7ff),
                  label: "Time",
                  value: formatTime(time)),
                  SizedBox(width: 15),
                  InfoStat(
                  icon: Icons.favorite_outline_rounded,
                  iconColor: Color(0xff535bed),
                  iconBackground: Color(0xffe4e7ff),
                  label: "Distance",
                  value: formatDistance(distance)),
                  SizedBox(width: 15),
                  InfoStat(
                  icon: Icons.bolt,
                  iconColor: Color(0xff535bed),
                  iconBackground: Color(0xffe4e7ff),
                  label: "Energy",
                  value: "$calories Kcal"),
                  SizedBox(width: 30),
            ],
          ),
        )

      ],
    );
  }
}

class InfoStat extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBackground;
  final String label;
  final String value;

  const InfoStat({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
    required this.label,
    required this.value
    });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      width: 110,
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(47, 62, 70, 1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: const Color.fromRGBO(47, 62, 70, 1)
        ),
        boxShadow: const [BoxShadow(
          color:  Color.fromRGBO(47, 62, 70, 1),
          offset: Offset(3, 3),
          blurRadius: 3
        )]
      ),
      child: Stack(
        children: [
          StatIcon(icon: icon, iconColor: iconColor, iconbackgroundColor:iconBackground),
          Align(
            alignment: Alignment.bottomLeft,
            child: Column(       
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(
                  fontSize: 10,
                  color: Colors.white
                ),),
                Text(value, style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Colors.white
                ),),
              ],
            ),
          )
          
        ],
      ),
    );
  }
}

class Change extends StatelessWidget {
  const Change({
    super.key,
    required this.time,
  });

  final String time;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(500)
        ),
        child: Text(time, style: const TextStyle(
          fontSize: 10,
          color: Colors.white
        ),),
        )
        );
  }
}


class StatIcon extends StatelessWidget {
  const StatIcon({
    super.key,
    required this.icon,
    required this.iconColor, 
    required this.iconbackgroundColor,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconbackgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: iconbackgroundColor,
        borderRadius: BorderRadius.circular(9)
      ),
      child: Icon(icon, size: 15, color: iconColor));
  }
}

//Format time to hours and minutes insted of just  seconds or minutes
String formatTime(double timeInMinutes) {
  int hours = timeInMinutes ~/ 60; 
  int minutes = (timeInMinutes % 60).round(); 

  if (hours > 0) {
    return "$hours h $minutes min"; 
  } else {
    return "$minutes min"; 
  }
}

//Fromat distance to Km insted of only meters
String formatDistance(double distanceInMeters) {
  if (distanceInMeters >= 1000) {
    double distanceInKilometers = distanceInMeters / 1000;
    return "${distanceInKilometers.toStringAsFixed(2)} km"; 
  } else {
    return "${distanceInMeters.toStringAsFixed(2)} m"; 
  }
}
