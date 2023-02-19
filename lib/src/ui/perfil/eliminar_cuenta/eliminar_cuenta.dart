import 'package:flutter/material.dart';
import 'package:planning/src/logic/eliminar_cuenta_logic.dart';
import 'package:planning/src/ui/widgets/snackbar_widget/snackbar_widget.dart';
import 'package:planning/src/ui/widgets/text_form_filed/password_wplanner.dart';

import '../../../models/item_model_preferences.dart';

class EliminarCuentaDialog extends StatefulWidget {
  const EliminarCuentaDialog({Key? key}) : super(key: key);

  @override
  State<EliminarCuentaDialog> createState() => _EliminarCuentaDialogState();
}

class _EliminarCuentaDialogState extends State<EliminarCuentaDialog> {
  TextEditingController passwordUser = TextEditingController(text: '');
  bool _espera = false;

  @override
  void initState() {
    super.initState();
  }

  int paso = 1;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: SizedBox(
        width: 350,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.warning, color: Colors.red.shade700),
            const Text(
              ' Eliminar cuenta ',
              textAlign: TextAlign.center,
            ),
            Icon(Icons.warning, color: Colors.red.shade700),
          ],
        ),
      ),
      content: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 350, maxHeight: 220),
        child: paso == 1
            ? Text(
                'Paso 1 de 2:'
                '\nAl realizar esta acción se borrará toda la información de '
                'su cuenta, incluyendo los eventos con sus invitados, los usuarios '
                'asociados al Planner y los documentos. También se cancelará '
                'automáticamente su suscripción de Paypal para evitar futuros '
                'cargos.'
                '\nNo podrá deshacer estos cambios en cuanto complete el paso 2.'
                '\n\n¿Desea continuar?',
                textAlign: TextAlign.justify,
              )
            : Column(
                children: [
                  SizedBox(
                    width: 350,
                    child: Text(
                      'Paso 2 de 2:\n'
                      'Ingrese su contraseña para confirmar la eliminación de su cuenta.',
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  PasswordWplanner(
                    onChanged: (str) {
                      setState(() {});
                    },
                    floatingText: 'Contraseña',
                    controller: passwordUser,
                    inputStyle: const TextStyle(color: Colors.black),
                    hintStyle: const TextStyle(color: Colors.grey),
                    autoFocus: false,
                    hasFloatingPlaceholder: true,
                    prefixIcon: const Icon(Icons.password),
                    suffixIcon: const Icon(
                      Icons.remove_red_eye,
                      color: Colors.grey,
                    ),
                    color: Colors.black,
                    iconColor: Colors.grey,
                    iconColorSelect: Colors.black,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: const BorderSide(color: Colors.black)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: const BorderSide(color: Colors.black)),
                  ),
                  SizedBox(
                    width: 350,
                    child: Text(
                      '\n\n\n'
                      '¡Muchas gracias por utilizar los servicios de Planning!',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancelar'),
          onPressed: () => Navigator.pop(context),
        ),
        paso == 1
            ? TextButton(
                child: const Text('Aceptar'),
                onPressed: () {
                  setState(() {
                    paso = 2;
                  });
                },
              )
            : TextButton(
                child: const Text('Finalizar'),
                onPressed: passwordUser.text.trim() == '' && !_espera
                    ? null
                    : () {
                        peticionEliminarCuenta();
                        _espera = true;
                      },
              ),
      ],
    );
  }

  void peticionEliminarCuenta() async {
    dynamic eliminado = await BackendEliminarCuentaLogic()
        .eliminarCuenta(passwordUser.text.trim());
    if (eliminado == 'true') {
      await SharedPreferencesT().clear();
      Navigator.pushReplacementNamed(context, '../');
    } else if (eliminado == 'false') {
      MostrarAlerta(
        mensaje: 'Su contraseña no es correcta.',
        tipoMensaje: TipoMensaje.advertencia,
      );
    } else {
      MostrarAlerta(
        mensaje: 'Ocurrió un error. Intente de nuevo más tarde.',
        tipoMensaje: TipoMensaje.error,
      );
      _espera = false;
    }
  }
}
