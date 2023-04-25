import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';

class FloatingActionWidget extends StatelessWidget {
  const FloatingActionWidget({
    super.key,
    required AnimationController animationController,
    required Animation<double> animation,
  }) : _animationController = animationController, _animation = animation;

  final AnimationController _animationController;
  final Animation<double> _animation;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 20,
      bottom: 20,
      child: Container(
        height: 55,
        width: 110,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16),color: Colors.deepPurpleAccent),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: (){},
            child: const Center(child: Text("Save Location",style: TextStyle(color: Colors.white),)),
          ),
        ),
      ),
    );
  }
}