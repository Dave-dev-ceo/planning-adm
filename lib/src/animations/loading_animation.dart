import 'dart:math' as math;

import 'package:flutter/material.dart';

class LoadingCustom extends StatefulWidget {
  const LoadingCustom({Key key}) : super(key: key);

  @override
  _LoadingCustomState createState() => _LoadingCustomState();
}

class _LoadingCustomState extends State<LoadingCustom>
    with SingleTickerProviderStateMixin {
  AnimationController controller;

  Animation<double> opacidad;
  Animation<double> scale;
  Animation<Color> color;
  Animation<double> rotacion;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    opacidad = Tween<double>(
      begin: 1,
      end: 0.3,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    ));
    rotacion = Tween<double>(
      begin: 0.0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));

    scale = Tween<double>(
      begin: 0.0,
      end: 0.4,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));

    controller.addListener(() {
      if (controller.status == AnimationStatus.completed) {
        controller.reverse();
      } else if (controller.status == AnimationStatus.dismissed) {
        controller.forward();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    controller.forward();
    return AnimatedBuilder(
      animation: controller,
      child: const Image(
        width: 100,
        image: AssetImage('assets/new_logo.png'),
        color: Colors.black,
      ),
      builder: (context, child) {
        return Transform.scale(
          scale: scale.value,
          child: child,
        );
      },
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
