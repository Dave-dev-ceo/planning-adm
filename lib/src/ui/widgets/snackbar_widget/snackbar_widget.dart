import 'package:flutter/material.dart';
import 'package:planning/src/app.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum TipoMensaje { correcto, error, advertencia }

void MostrarAlerta(
    {@required String mensaje, @required TipoMensaje tipoMensaje}) {
  Color color;
  Widget icon;
  TextStyle style = TextStyle(
    color: Colors.white,
  );
  switch (tipoMensaje) {
    case TipoMensaje.correcto:
      color = Colors.green;
      icon = FaIcon(
        FontAwesomeIcons.checkCircle,
        color: Colors.white,
      );
      break;
    case TipoMensaje.advertencia:
      color = Colors.amber[900];
      icon = FaIcon(
        FontAwesomeIcons.exclamationTriangle,
        color: Colors.white,
      );

      break;
    default:
      color = Colors.red;
      icon = Icon(
        Icons.cancel,
        color: Colors.white,
      );

      break;
  }

  scaffoldMessegerKey.currentState.showSnackBar(SnackBar(
    content: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        icon,
        SizedBox(
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
    duration: const Duration(milliseconds: 1500),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(4.0),
    ),
  ));
}
