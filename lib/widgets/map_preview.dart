import 'package:flutter/material.dart';
import 'package:flutter_application/views/map_view.dart';



class MapPreview extends StatelessWidget {
  

  const MapPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 330, 
      width: double.infinity, 
      child: MapsView(), 
    );
  }
}
