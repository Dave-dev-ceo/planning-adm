import 'package:flutter/material.dart';

enum TypeTransicionRouter {
  slideRouterTransition,
  scaleRouterTransition,
  fadeRouterTransition,
}

class CustomPageRouter extends PageRouteBuilder {
  final Widget child;
  final AxisDirection direction;
  final TypeTransicionRouter transicionRouter;

  CustomPageRouter({
    required this.child,
    this.direction = AxisDirection.left,
    this.transicionRouter = TypeTransicionRouter.slideRouterTransition,
  }) : super(
            transitionDuration: const Duration(milliseconds: 900),
            reverseTransitionDuration: const Duration(milliseconds: 900),
            pageBuilder: (context, animation, secondaryAnimation) => child);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return getRouterTransition();
  }

  getRouterTransition() {
    final curvedAnimation =
        CurvedAnimation(parent: animation!, curve: Curves.easeInOut);

    switch (transicionRouter) {
      case TypeTransicionRouter.fadeRouterTransition:
        return fadeTransition(curvedAnimation);
      case TypeTransicionRouter.scaleRouterTransition:
        return scaleTransition(curvedAnimation);
      default:
        return slideTransition(curvedAnimation);
    }
  }

  FadeTransition fadeTransition(CurvedAnimation curvedAnimation) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0.0, end: 1.0).animate(curvedAnimation),
      child: child,
    );
  }

  SlideTransition slideTransition(CurvedAnimation curvedAnimation) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: getBeginOffset(),
        end: Offset.zero,
      ).animate(curvedAnimation),
      child: child,
    );
  }

  ScaleTransition scaleTransition(CurvedAnimation curvedAnimation) {
    return ScaleTransition(
      scale: Tween<double>(begin: 0.0, end: 1.0).animate(curvedAnimation),
      child: child,
    );
  }

  Offset getBeginOffset() {
    switch (direction) {
      case AxisDirection.up:
        return const Offset(0, 1);
      case AxisDirection.down:
        return const Offset(0, -1);
      case AxisDirection.right:
        return const Offset(-1, 0);
      default:
        return const Offset(1, 0);
    }
  }
}
