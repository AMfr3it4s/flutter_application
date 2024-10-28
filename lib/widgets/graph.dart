import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_application/utils/db_helper.dart';

class Graph extends StatelessWidget {
  const Graph({super.key});

  @override
  Widget build(BuildContext context) {
    return const Expanded(
      child: SizedBox(
        width: double.infinity,
        child: GraphArea(),
      ),
    );
  }
}

class GraphArea extends StatefulWidget {
  const GraphArea({super.key});

  @override
  State<GraphArea> createState() => _GraphAreaState();
}

class _GraphAreaState extends State<GraphArea> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  
  List<DataPoint> data = [];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    
    fetchData().then((_) {
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Fetch Data From DataBase,  and update the data list to the day of the steps where taken
  Future<void> fetchData() async {
  final db = DatabaseHelper(); 
  data = []; 

  DateTime today = DateTime.now();

 
  for (int i = 0; i < 8; i++) {
    DateTime date = today.subtract(Duration(days: 7 - i)); 

    
    List<Map<String, dynamic>> stepsData = await db.getStepsByDate(date);

   
    int steps = stepsData.isNotEmpty && stepsData[0]['stepCount'] != null
        ? stepsData[0]['stepCount']
        : 0; 

    
    data.add(DataPoint(day: 8 - i, steps: steps)); 
  }

  setState(() {
  }); 
}


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _animationController.forward(from: 0.0);
      },
      child: CustomPaint(
        painter: GraphPainter(_animationController.view, data: data),
      ),
    );
  }
}

class GraphPainter extends CustomPainter {
  final List<DataPoint> data;
  final Animation<double> _size;
  final Animation<double> _dotSize;

  GraphPainter(Animation<double> animation, {required this.data})
      : _size = Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(
            parent: animation,
            curve: const Interval(0.0, 0.75, curve: Curves.easeInOutCubicEmphasized),
          ),
        ),
        _dotSize = Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(
            parent: animation,
            curve: const Interval(0.3, 1, curve: Curves.easeInOutCubicEmphasized),
          ),
        ),
        super(repaint: animation);

  @override
void paint(Canvas canvas, Size size) {
  if (data.isEmpty) return; 

  var xSpacing = size.width / (data.isNotEmpty ? data.length : 1); 
  var maxSteps = data.fold<int>(0, (max, dp) => dp.steps > max ? dp.steps : max);
  var ySpacing = maxSteps > 0 ? size.height / maxSteps : 0; 


  List<Offset> offsets = [];
  var cX = 0.0;

  for (int i = 0; i < data.length; i++) {
    var cY = size.height - (data[i].steps * ySpacing * _size.value);
    if (cY < 0) cY = 0; 
    offsets.add(Offset(cX, cY));
    cX += xSpacing;
  }

    Paint linePaint = Paint()
      ..color = const Color.fromRGBO(47, 62, 70, 1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;

    Paint shadowPaint = Paint()
      ..color = const Color.fromRGBO(47, 62, 70, 0.6)
      ..style = PaintingStyle.stroke
      ..maskFilter = const ui.MaskFilter.blur(ui.BlurStyle.solid, 3)
      ..strokeWidth = 5;

    Paint fillPaint = Paint()
      ..shader = ui.Gradient.linear(
        Offset(size.width / 2, 0),
        Offset(size.width / 2, size.height),
        [
          const Color.fromRGBO(47, 62, 70, 1),
          const Color.fromRGBO(239, 235, 206, 1)
        ],
      )
      ..color = const Color.fromRGBO(47, 62, 70, 0.2)
      ..style = PaintingStyle.fill;

    Paint dotOutlinePaint = Paint()
      ..color = const Color.fromRGBO(239, 235, 206, 0.8)
      ..strokeWidth = 8;

    Paint dotCenterPaint = Paint()
      ..color = const Color.fromRGBO(249, 110, 70, 0.65)
      ..strokeWidth = 8;

    Path linePath = Path();

    if (offsets.isNotEmpty) {
      linePath.moveTo(offsets[0].dx, offsets[0].dy);
      for (int i = 1; i < offsets.length; i++) {
        var x = offsets[i].dx;
        var y = offsets[i].dy;
        var c1x = offsets[i - 1].dx + (xSpacing * 0.3);
        var c1y = offsets[i - 1].dy;
        var c2x = x - (xSpacing * 0.3);
        var c2y = y;

        linePath.cubicTo(c1x, c1y, c2x, c2y, x, y);
      }

      Path fillPath = Path.from(linePath);
      fillPath.lineTo(size.width, size.height);
      fillPath.lineTo(0, size.height);

      canvas.drawPath(fillPath, fillPaint);
      canvas.drawPath(linePath, shadowPaint);
      canvas.drawPath(linePath, linePaint);

      
      if (offsets.length > 4) {
        canvas.drawCircle(offsets[7], 10 * _dotSize.value, dotOutlinePaint);
        canvas.drawCircle(offsets[7], 5 * _dotSize.value, dotCenterPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant GraphPainter oldDelegate) {
    return data != oldDelegate.data;
  }
}

class DataPoint {
  final int day;
  final int steps;

  DataPoint({
    required this.day,
    required this.steps,
  });
   @override
  String toString() {
    return 'DataPoint(day: $day, steps: $steps)';
  }
}
