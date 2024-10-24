import 'package:flutter/material.dart';
import 'package:flutter_application/views/helpers.dart';

class Dates extends StatelessWidget {
  const Dates({super.key});

  @override
  Widget build(BuildContext context) {

    List<DateBox> dateBoxes = [];

    //DateTime date = DateTime.parse('2024-10-24');
    DateTime date = DateTime.now().subtract(const Duration(days: 3));

    for (int i = 0; i<6; i++){
      dateBoxes.add(DateBox(date: date, active: i == 3,));
      date = date.add(const Duration(days:1));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: dateBoxes,
      ),
    );
  }
}

class DateBox extends StatelessWidget {
  final bool active;
  final DateTime date;
  const DateBox({
    super.key,
    this.active = false,
    required this.date
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 70,
      decoration: BoxDecoration(
        gradient:  active?const  LinearGradient(
          colors: [
            Color.fromRGBO(249, 110, 70, 1),
              Color.fromRGBO(249, 110, 70, 0.7),
          ] ,
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter, 
          ): const LinearGradient(colors: [
            Color.fromRGBO(47, 62, 70, 1),
            Color.fromRGBO(47, 62, 70, 1),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          ),     
        borderRadius: BorderRadius.circular(10) ,
        border: Border.all(color:const Color.fromRGBO(47, 62, 70, 0.2)
        ),
      ),
      child: DefaultTextStyle.merge(
        style: active ? const TextStyle
        (color:  Color.fromRGBO(47, 62, 70, 1))
         : const TextStyle
        (color:  Color.fromRGBO(255, 255, 255, 1)),
        child: Column(
          children: [
            Text(daysofWeek[date.weekday]!, style: 
            const TextStyle(
              fontSize:  10,
              fontWeight: FontWeight.bold),)
            , const SizedBox(height: 8),
            Text(date.day.toString().padLeft(2, '0'), 
            style: 
            const  TextStyle(
              fontSize:  27,
              fontWeight: FontWeight.w500
             ),)
          ],
        ),
      ) ,
    );
  }
}