import 'package:flutter/material.dart';

class AgregarInvitados extends StatelessWidget {
  static Route<dynamic> route() => MaterialPageRoute(
        builder: (context) => AgregarInvitados(),
      );
final _formKey = GlobalKey<FormState>();
Color hexToColor(String code) {
      return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
    }
_borderTextForm(){
  return OutlineInputBorder(
    borderRadius: new BorderRadius.circular(25.0),
    borderSide: new BorderSide(
    ),
  );
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("WeddingPlannet"),
        backgroundColor: Colors.blue[300],
      ),
      body:
      SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SafeArea(
              child: 
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 150.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      //mainAxisAlignment: MainAxisAlignment.center,
                      //crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(padding: EdgeInsets.only(top: 140.0)),
                        Text('Registro de invitado',style: new TextStyle(color: hexToColor("#8FCACB"), fontSize: 25.0),),
                        Padding(padding: EdgeInsets.only(top: 50.0)),
                        Column(
                          children: <Widget>[
                            TextFormField(
                              decoration: new InputDecoration(
                                labelText: "Ingresa el nombre",
                                fillColor: Colors.white,
                                border: _borderTextForm(),
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Falta nombre';
                                }
                              },
                            ),
                            Padding(padding: EdgeInsets.only(top: 20.0)),
                            TextFormField(
                              decoration: new InputDecoration(
                                labelText: "ingrese los apellidos",
                                fillColor: Colors.white,
                                border: _borderTextForm(),
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Faltan los apellidos';
                                }
                              },
                            ),
                            Padding(padding: EdgeInsets.only(top: 20.0)),
                            TextFormField(
                              decoration: new InputDecoration(
                                labelText: "ingrese el email",
                                fillColor: Colors.white,
                                border: _borderTextForm(),
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Falta email';
                                }
                              },
                            ),
                            Padding(padding: EdgeInsets.only(top: 20.0)),
                            TextFormField(
                              decoration: new InputDecoration(
                                labelText: "ingrese número telefónico",
                                fillColor: Colors.white,
                                border: _borderTextForm(),
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Falta número telefónico';
                                }
                              },
                            ),
                            Padding(padding: EdgeInsets.only(top: 20.0)),
                            TextFormField(
                              decoration: new InputDecoration(
                                labelText: "ingrese número telefónico",
                                fillColor: Colors.white,
                                border: _borderTextForm(),
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Falta número telefónico';
                                }
                              },
                            ),
                            Padding(padding: EdgeInsets.only(top: 20.0)),
                            TextFormField(
                              decoration: new InputDecoration(
                                labelText: "ingrese número telefónico",
                                fillColor: Colors.white,
                                border: _borderTextForm(),
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Falta número telefónico';
                                }
                              },
                            ),
                            Padding(padding: EdgeInsets.only(top: 20.0)),
                            TextFormField(
                              decoration: new InputDecoration(
                                labelText: "ingrese número telefónico",
                                fillColor: Colors.white,
                                border: _borderTextForm(),
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Falta número telefónico';
                                }
                              },
                            ),
                            Padding(padding: EdgeInsets.only(top: 20.0)),
                            TextFormField(
                              decoration: new InputDecoration(
                                labelText: "ingrese número telefónico",
                                fillColor: Colors.white,
                                border: _borderTextForm(),
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Falta número telefónico';
                                }
                              },
                            ),
                            Padding(padding: EdgeInsets.only(top: 20.0)),
                            TextFormField(
                              decoration: new InputDecoration(
                                labelText: "ingrese número telefónico",
                                fillColor: Colors.white,
                                border: _borderTextForm(),
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Falta número telefónico';
                                }
                              },
                            ),
                            Padding(padding: EdgeInsets.only(top: 20.0)),
                            TextFormField(
                              decoration: new InputDecoration(
                                labelText: "ingrese número telefónico",
                                fillColor: Colors.white,
                                border: _borderTextForm(),
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Falta número telefónico';
                                }
                              },
                            ),
                            Padding(padding: EdgeInsets.only(top: 20.0)),
                            TextFormField(
                              decoration: new InputDecoration(
                                labelText: "ingrese número telefónico",
                                fillColor: Colors.white,
                                border: _borderTextForm(),
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Falta número telefónico';
                                }
                              },
                            ),
                            Padding(padding: EdgeInsets.only(top: 20.0)),
                            TextFormField(
                              decoration: new InputDecoration(
                                labelText: "ingrese número telefónico",
                                fillColor: Colors.white,
                                border: _borderTextForm(),
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Falta número telefónico';
                                }
                              },
                            ),
                            Padding(padding: EdgeInsets.only(top: 20.0)),
                            TextFormField(
                              decoration: new InputDecoration(
                                labelText: "ingrese número telefónico",
                                fillColor: Colors.white,
                                border: _borderTextForm(),
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Falta número telefónico';
                                }
                              },
                            ),
                            Padding(padding: EdgeInsets.only(top: 20.0)),
                            TextFormField(
                              decoration: new InputDecoration(
                                labelText: "ingrese número telefónico",
                                fillColor: Colors.white,
                                border: _borderTextForm(),
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Falta número telefónico';
                                }
                              },
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: RaisedButton(
                            onPressed: () {
                              // devolverá true si el formulario es válido, o falso si
                              // el formulario no es válido.
                              if (_formKey.currentState.validate()) {
                                // Si el formulario es válido, queremos mostrar un Snackbar
                                Scaffold.of(context)
                                    .showSnackBar(SnackBar(content: Text('Processing Data')));
                              }
                            },
                            child: Text('Submit'),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
            )
          ],
        ),
      ) 
    );
  }
}