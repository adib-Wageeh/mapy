import 'package:flutter/material.dart';

class FloatingSaveWidget extends StatelessWidget {

  final String text;
  final Function()? onTap;
  const FloatingSaveWidget({
    super.key,
    required this.text,
    required this.onTap
  });



  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 20,
      bottom: 20,
      child: Container(
        height: 55,
        width: 120,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16),color: Colors.deepPurpleAccent),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: onTap,
            child: Center(child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Text(text,style: const TextStyle(color: Colors.white),),
            )),
          ),
        ),
      ),
    );
  }
}