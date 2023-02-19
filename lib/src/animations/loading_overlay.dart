import 'package:flutter/material.dart';
import 'package:planning/src/animations/loading_animation.dart';

class ProgressBar {
  OverlayEntry? _progressOverlayEntry;

  void show(BuildContext context) {
    _progressOverlayEntry = _createdProgressEntry(context);
    Overlay.of(context).insert(_progressOverlayEntry!);
  }

  void hide() {
    if (_progressOverlayEntry != null) {
      _progressOverlayEntry!.remove();
      _progressOverlayEntry = null;
    }
  }

  OverlayEntry _createdProgressEntry(BuildContext context) => OverlayEntry(
      builder: (BuildContext context) => Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              children: <Widget>[
                Container(
                  color: Colors.grey.withOpacity(0.5),
                ),
                Positioned(
                  top: screenHeight(context) / 2,
                  left: screenWidth(context) / 2,
                  child: SizedBox(
                    height: 150.0,
                    width: 150.0,
                    child: Column(
                      children: [
                        LoadingCustom(),
                        Text('Cargando...'),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ));

  double screenHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  double screenWidth(BuildContext context) => MediaQuery.of(context).size.width;
}
