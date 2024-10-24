import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

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

class _GraphAreaState extends State<GraphArea> with SingleTickerProviderStateMixin{

  late AnimationController _animationController;

  //Data Point that will come from data base, for now jsut an example
  List<DataPoint> data = [
    DataPoint(day: 1, steps: Random().nextInt(100)),
    DataPoint(day: 2, steps: Random().nextInt(100)),
    DataPoint(day: 3, steps: Random().nextInt(100)),
    DataPoint(day: 4, steps: Random().nextInt(100)),
    DataPoint(day: 5, steps: Random().nextInt(100)),
    DataPoint(day: 6, steps: Random().nextInt(100)),
    DataPoint(day: 7, steps: Random().nextInt(100)),
    DataPoint(day: 8, steps: Random().nextInt(100)),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();

  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        _animationController.forward(from: 0.0);
      },
      child: CustomPaint(
        painter: GraphPainter(_animationController.view, data: data),
      ),
    );
  }
}

class GraphPainter extends CustomPainter{
  final List<DataPoint> data;
  final Animation<double> _size;
  final Animation<double> _dotSize;

  GraphPainter( Animation<double> animation, {required this.data})
                : _size = Tween<double>(begin: 0 , end: 1).animate(CurvedAnimation(parent: animation, curve: const Interval(0.0, 0.75, curve: Curves.easeInOutCubicEmphasized)),

                ),
                 _dotSize = Tween<double>(begin: 0 , end: 1).animate(CurvedAnimation(parent: animation, curve: const Interval(0.3, 1, curve: Curves.easeInOutCubicEmphasized)),
                 
                 ),
                 super(repaint: animation);


  @override
  void paint(Canvas canvas, Size size) {
    var xSpacing = size.width / (data.length);
    var maxSteps = data.fold<DataPoint>(data[0], (p,c) =>  p.steps > c.steps ? p : c).steps;
    var ySpacing = size.height / maxSteps;
    var curveOffset = xSpacing * 0.3;


    List<Offset> offsets = [];

    var cX = 0.0;
    for (int i = 0; i < data.length; i++){

      var cY =  size.height - (data[i].steps * ySpacing * _size.value);
      offsets.add(Offset(cX, cY));
      cX+= xSpacing;

    }

    Paint linePaint = Paint()
    ..color = const Color.fromRGBO(47, 62, 70, 1)
    ..style = PaintingStyle.stroke
    ..strokeWidth =5;

    Paint shadowPaint = Paint()
    ..color = const Color.fromRGBO(47, 62, 70, 0.6)
    ..style = PaintingStyle.stroke
    ..maskFilter = const ui.MaskFilter.blur(ui.BlurStyle.solid, 3)
    ..strokeWidth =5;

    Paint fillPaint = Paint()
    ..shader = ui.Gradient.linear(
      Offset(size.width/ 2,0)
    , Offset(size.width / 2, size.height),
     [
      const Color.fromRGBO(47, 62, 70, 1),
      const Color.fromRGBO(239, 235, 206, 1)
     ]
     
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

    Offset currentOffset = offsets[0];

    linePath.moveTo(currentOffset.dx, currentOffset.dy);
    for(int i= 1;  i < offsets.length; i++){
      var x =  offsets[i].dx;
      var y =  offsets[i].dy;
      var c1x = currentOffset.dx + curveOffset;
      var c1y = currentOffset.dy;
      var c2x = x - curveOffset;
      var c2y = y;



      linePath.cubicTo(c1x, c1y, c2x,c2y, x, y);
      currentOffset = offsets[i];
    }

    Path fillPath = Path.from(linePath);
    fillPath.lineTo(size.width, size.height);
    fillPath.lineTo(0, size.height);


    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(linePath, shadowPaint);
    canvas.drawPath(linePath, linePaint);

    canvas.drawCircle(offsets[4], 10 * _dotSize.value, dotOutlinePaint);
    canvas.drawCircle(offsets[4], 5 * _dotSize.value, dotCenterPaint);

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
}