import 'dart:math';

final Map<int, String> daysofWeek = {
  1:  'Mon',
  2:  'Tue',
  3:  'Wed',
  4:  'Thu',
  5:  'Fri',
  6:  'Sat',
  7:  'Sun',
};
//min 5
//max 10
int randBetween(int min, int max){
  return Random().nextInt(max - min) + min;
}

String formatnumber(int number){
  return number.toString().replaceAllMapped( 
    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
     (Match m) => '${m[1]}.');
}