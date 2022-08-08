import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:planning/src/animations/loading_animation.dart';
import 'package:planning/src/blocs/planners/planners_bloc.dart';
import 'package:planning/src/models/plannerModel/planner_model.dart';
import 'package:planning/src/ui/widgets/snackbar_widget/snackbar_widget.dart';

class DetallesPlanner extends StatefulWidget {
  final int idPlanner;
  const DetallesPlanner({Key key, @required this.idPlanner}) : super(key: key);

  @override
  State<DetallesPlanner> createState() => _DetallesPlannerState();
}

class _DetallesPlannerState extends State<DetallesPlanner> {
  PlannersBloc plannersBloc;
  PlannerModel planner;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    plannersBloc = BlocProvider.of<PlannersBloc>(context);
    if (widget.idPlanner != 0) {
      plannersBloc.add(ObtenerDetallePlannerEvent(widget.idPlanner));
    } else {
      planner = PlannerModel();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
            widget.idPlanner != 0 ? 'Detalles del planner' : 'Agregar Planner'),
      ),
      body: BlocListener<PlannersBloc, PlannersState>(
        listener: (context, state) {
          if (state is ErrorListaPlannersState) {}
          if (state is PlannerEditSuccessState) {
            MostrarAlerta(
              mensaje: 'Se ha editado correctamente el planner',
              tipoMensaje: TipoMensaje.correcto,
            );
            Navigator.of(context, rootNavigator: true).pop();
          }

          if (state is PlannerEditErrorState) {
            MostrarAlerta(
              mensaje: 'Ocurrió un error al intentar editar el planner',
              tipoMensaje: TipoMensaje.error,
            );
          }

          if (state is PlannerCreatedSuccessState) {
            MostrarAlerta(
              mensaje: 'Se ha creado correctamente el planner',
              tipoMensaje: TipoMensaje.correcto,
            );
            Navigator.of(context, rootNavigator: true).pop();
          }

          if (state is PlannerCreatedErrorState) {
            MostrarAlerta(
              mensaje: 'Ocurrió un error al intentar crear el planner',
              tipoMensaje: TipoMensaje.error,
            );
          }
        },
        child: widget.idPlanner != 0
            ? BlocBuilder<PlannersBloc, PlannersState>(
                builder: (context, state) {
                  if (state is DetallesPlannerState) {
                    planner = state.planner;
                    return detallesPlanner(size);
                  }
                  return const Center(child: LoadingCustom());
                },
              )
            : detallesPlanner(size),
      ),
    );
  }

  Widget detallesPlanner(Size size) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        child: Align(
          alignment: Alignment.center,
          child: SizedBox(
            width: size.width * 0.6,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: const InputDecoration(
                          disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                          focusColor: Colors.grey,
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)),
                          border: OutlineInputBorder(),
                          hintText: 'Nombre completo',
                          labelText: 'Nombre completo',
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: FaIcon(
                              FontAwesomeIcons.user,
                              color: Colors.grey,
                            ),
                          )),
                      initialValue: planner.nombreCompleto,
                      onChanged: (String value) {
                        planner.nombreCompleto = value;
                      },
                      validator: (value) {
                        if (value.isNotEmpty && value != null) {
                          return null;
                        }
                        return 'El nombre es requerido';
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: const InputDecoration(
                          disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                          focusColor: Colors.grey,
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)),
                          border: OutlineInputBorder(),
                          hintText: 'Teléfono',
                          labelText: 'Teléfono',
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: FaIcon(
                              FontAwesomeIcons.phoneFlip,
                              color: Colors.grey,
                            ),
                          )),
                      initialValue: planner.telefono,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (String value) {
                        planner.telefono = value;
                      },
                      validator: (value) {
                        if (value.isNotEmpty && value != null) {
                          return null;
                        }
                        return 'El teléfono es requerido';
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: const InputDecoration(
                          disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                          focusColor: Colors.grey,
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)),
                          border: OutlineInputBorder(),
                          hintText: 'Correo',
                          labelText: 'Correo',
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: FaIcon(
                              FontAwesomeIcons.envelope,
                              color: Colors.grey,
                            ),
                          )),
                      initialValue: planner.correo,
                      onChanged: (String value) {
                        planner.correo = value;
                      },
                      validator: (value) {
                        if (value.isNotEmpty && value != null) {
                          RegExp exp = RegExp(
                              r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?$");

                          if (exp.hasMatch(value)) {
                            return null;
                          }
                          return 'Ingrese un correo eléctronico válido';
                        }
                        return 'El correo es requerido';
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: const InputDecoration(
                          disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                          focusColor: Colors.grey,
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)),
                          border: OutlineInputBorder(),
                          hintText: 'Nombre de la empresa',
                          labelText: 'Nombre de la empresa',
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: FaIcon(
                              FontAwesomeIcons.building,
                              color: Colors.grey,
                            ),
                          )),
                      initialValue: planner.nombreEmpresa,
                      onChanged: (String value) {
                        planner.nombreEmpresa = value;
                      },
                      validator: (value) {
                        if (value.isNotEmpty && value != null) {
                          return null;
                        }
                        return 'El nombre del empresa es requerido';
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: const InputDecoration(
                          disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                          focusColor: Colors.grey,
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)),
                          border: OutlineInputBorder(),
                          hintText: 'Dirección',
                          labelText: 'Dirección',
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: FaIcon(
                              FontAwesomeIcons.addressCard,
                              color: Colors.grey,
                            ),
                          )),
                      initialValue: planner.direccion,
                      onChanged: (String value) {
                        planner.direccion = value;
                      },
                      validator: (value) {
                        if (value.isNotEmpty && value != null) {
                          return null;
                        }
                        return 'La dirección es requerida';
                      },
                    ),
                  ),
                  if (widget.idPlanner != 0)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: size.width * 0.587,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 0.5,
                            color: Colors.grey[700],
                          ),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: SwitchListTile(
                          value: planner.estatus == 'A',
                          onChanged: (value) {
                            if (value) {
                              planner.estatus = 'A';
                            } else {
                              planner.estatus = 'I';
                            }
                            setState(() {});
                          },
                          title: Text(
                              'Estatus: ${planner.estatus == "A" ? "Activo" : "Inactivo"}'),
                          secondary: FaIcon(planner.estatus == 'A'
                              ? FontAwesomeIcons.circleCheck
                              : FontAwesomeIcons.userSlash),
                        ),
                      ),
                    ),
                  const SizedBox(height: 10.0),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        if (widget.idPlanner != 0) {
                          plannersBloc.add(EditPlannerEvent(planner));
                        } else {
                          plannersBloc.add(AddPlannerEvent(planner));
                        }
                      } else {
                        MostrarAlerta(
                            mensaje: 'Compruebe los campos',
                            tipoMensaje: TipoMensaje.advertencia);
                      }
                    },
                    child: Text(widget.idPlanner != 0 ? 'Guardar' : 'Crear'),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
