import 'package:flutter/material.dart';

class DistanceWidget extends StatelessWidget {
  final double? distance;
  const DistanceWidget({required this.distance,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 120,
      left: 30,
      child: SizedBox(
        width: 150,
        height: 30,
        child: (distance!=null)?Text("Distance: ${distance!.toInt()}km"):const Text(""),
      ),
    );
  }
}