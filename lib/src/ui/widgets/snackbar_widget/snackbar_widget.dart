// ignore_for_file: non_constant_identifier_names

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:planning/src/app.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum TipoMensaje { correcto, error, advertencia }

void MostrarAlerta(
    {@required String mensaje,
    @required TipoMensaje tipoMensaje,
    Function() onVisible}) {
  Color color;
  Widget icon;
  TextStyle style = const TextStyle(
    color: Colors.white,
  );
  switch (tipoMensaje) {
    case TipoMensaje.correcto:
      color = Colors.green;
      icon = const FaIcon(
        FontAwesomeIcons.checkCircle,
        color: Colors.white,
      );
      break;
    case TipoMensaje.advertencia:
      color = Colors.amber[900];
      icon = const FaIcon(
        FontAwesomeIcons.exclamationTriangle,
        color: Colors.white,
      );

      break;
    default:
      color = Colors.red;
      icon = const Icon(
        Icons.cancel,
        color: Colors.white,
      );

      break;
  }
  try {
    scaffoldMessegerKey.currentState.clearSnackBars();

    scaffoldMessegerKey.currentState.showSnackBar(
      SnackBar(
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            icon,
            const SizedBox(
              width: 8.0,
            ),
            Expanded(
              child: Text(
                mensaje,
                style: style,
              ),
            ),
          ],
        ),
        backgroundColor: color,
        elevation: 3.0,
        duration: const Duration(milliseconds: 2000),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
        ),
        onVisible: onVisible,
      ),
    );
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
  }
}
