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
    @required this.child,
    this.direction = AxisDirection.left,
    this.transicionRouter = TypeTransicionRouter.slideRouterTransition,
  }) : super(
            transitionDuration: Duration(milliseconds: 900),
            reverseTransitionDuration: Duration(milliseconds: 900),
            pageBuilder: (context, animation, secondaryAnimation) => child);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return getRouterTransition();
  }

  getRouterTransition() {
    final curvedAnimation =
        CurvedAnimation(parent: animation, curve: Curves.easeInOut);

    switch (transicionRouter) {
      case TypeTransicionRouter.fadeRouterTransition:
        return fadeTransition(curvedAnimation);
        break;
      case TypeTransicionRouter.scaleRouterTransition:
        return scaleTransition(curvedAnimation);
        break;
      default:
        return slideTransition(curvedAnimation);

        break;
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
        return Offset(0, 1);
        break;
      case AxisDirection.down:
        return Offset(0, -1);
        break;
      case AxisDirection.right:
        return Offset(-1, 0);
        break;
      default:
        return Offset(1, 0);
        break;
    }
  }
}
