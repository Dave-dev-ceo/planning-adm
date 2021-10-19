import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weddingplanner/src/blocs/Mesas/mesas_bloc.dart';
import 'package:weddingplanner/src/blocs/invitadosMesa/invitadosmesas_bloc.dart';
import 'package:weddingplanner/src/logic/mesas_asignadas_logic/mesas_asignadas_services.dart';
import 'package:weddingplanner/src/models/MesasAsignadas/mesas_asignadas_model.dart';
import 'package:weddingplanner/src/models/invitadosConfirmadosModel/invitado_mesa_Model.dart';
import 'package:weddingplanner/src/models/mesa/mesas_model.dart';
import 'package:weddingplanner/src/ui/contratos/new_contrato.dart';

class MesasPage extends StatefulWidget {
  @override
  State<MesasPage> createState() => _MesasPageState();
}

class _MesasPageState extends State<MesasPage> {
  final mesasAsignadasService = MesasAsignadasService();
  final asignarMesasService = MesasAsignadasService();
  InvitadosMesasBloc invitadosBloc;
  List<MesasAsignadasModel> listaMesasAsignadas = [];
  List<MesasAsignadasModel> listAsigandosToDelete = [];
  List<MesasAsignadasModel> listToAsignarForAdd = [];
  List<bool> checkedsInvitados = [];
  List<bool> checkedsAsignados = [];
  List<int> listPosicionDisponible = [];
  MesaModel mesaModelData;
  Size size;
  bool isEdit = true;
  bool _isVisible = false;
  int indexNavBar = 0;
  int lastNumMesa;

  @override
  void initState() {
    invitadosBloc = BlocProvider.of<InvitadosMesasBloc>(context);
    mesasAsignadasService.getMesasAsignadas();
    BlocProvider.of<MesasBloc>(context).add(MostrarMesasEvent());
    BlocProvider.of<InvitadosMesasBloc>(context)
        .add(MostrarInvitadosMesasEvent());
    super.initState();
  }

  // @override
  // void dispose() {
  //   mesasAsignadasService.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    setState(() {});
    final listWidget = [resumenMesasPage(), asignarInvitadosMesasPage()];
    size = MediaQuery.of(context).size;
    return Scaffold(
      bottomNavigationBar: _bottomNavigatorBarCustom(),
      body: StreamBuilder(
        stream: mesasAsignadasService.mesasAsignadasStream,
        builder: (context, AsyncSnapshot<List<MesasAsignadasModel>> snapshot) {
          if (snapshot.hasData) {
            listaMesasAsignadas = snapshot.data;
            return listWidget[indexNavBar];
          } else {
            listaMesasAsignadas = [];
            return listWidget[indexNavBar];
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 3.0,
        onPressed: () {
          Navigator.of(context)
              .pushNamed('/asignarMesas',
                  arguments:
                      (lastNumMesa == null) ? lastNumMesa = 0 : lastNumMesa)
              .then((value) => {
                    print(value),
                    lastNumMesa = value,
                  });
        },
        child: Icon(Icons.add),
      ),
    );
  }

  BottomNavigationBar _bottomNavigatorBarCustom() {
    return BottomNavigationBar(
      currentIndex: indexNavBar,
      items: [
        BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_outlined),
            label: 'Mesas',
            tooltip: 'Resumen Mesas'),
        BottomNavigationBarItem(
            icon: Icon(Icons.post_add_sharp),
            label: 'Asignar',
            tooltip: 'Asignar Mesas')
      ],
      onTap: (int index) {
        setState(() {
          indexNavBar = index;
        });
      },
      selectedItemColor: Color(0xFFfdd89b),
    );
  }

  // ? Resumen de Mesas Asignadas

  Widget resumenMesasPage() {
    Widget WidgetBlocMesas = BlocBuilder<MesasBloc, MesasState>(
      builder: (context, state) {
        if (state is LoadingMesasState) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is MostrarMesasState) {
          if (state.listaMesas.isNotEmpty && state.listaMesas != null) {
            lastNumMesa = state.listaMesas.last.numDeMesa;
            return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: _gridMesasWidget(state.listaMesas));
          } else {
            return Align(
              alignment: Alignment.center,
              child: Text(
                'No se encontraron datos',
                style: Theme.of(context).textTheme.headline6,
              ),
            );
          }
        } else if (state is ErrorMesasState) {
          return Container(
            child: Center(child: Text(state.message)),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );

    return Column(
      children: [
        SizedBox(
          height: 20.0,
        ),
        Flexible(child: WidgetBlocMesas)
      ],
    );
  }

  Widget _gridMesasWidget(List<MesaModel> listaMesa) {
    Widget gridOfListaMesas = GridView.builder(
        itemCount: listaMesa.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1.5,
        ),
        itemBuilder: (BuildContext context, int index) {
          final listaAsignados = listaMesasAsignadas
              .where((m) => m.idMesa == listaMesa[index].idMesa);
          return ConstrainedBox(
            constraints: BoxConstraints(),
            child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                margin: EdgeInsets.all(6.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Center(child: Text(listaMesa[index].descripcion)),
                      SizedBox(
                        height: 10.0,
                      ),
                      Expanded(
                        child: ListView.builder(
                            itemCount: listaMesa[index].dimension,
                            itemBuilder: (BuildContext context, int i) {
                              String temp = '';
                              if (listaMesasAsignadas.isNotEmpty) {
                                final asigando = listaAsignados.firstWhere(
                                  (a) => a.posicion == i + 1,
                                  orElse: () => null,
                                );
                                if (asigando != null)
                                  asigando.idAcompanante != 0
                                      ? temp = asigando.acompanante
                                      : temp = asigando.invitado;
                              }
                              return TextFormField(
                                enabled: false,
                                decoration: InputDecoration(
                                    labelText: 'Silla ${i + 1}'),
                                initialValue: temp,
                              );
                            }),
                      )
                    ],
                  ),
                )),
          );
        });
    return gridOfListaMesas;
  }

  // ? Page Asignar Mesas a Invitados

  _mostraMensaje(String msj, Color color) {
    SnackBar snackBar = SnackBar(
      content: Text(msj),
      backgroundColor: color,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Widget asignarInvitadosMesasPage() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(
            height: 20.0,
          ),
          Expanded(
              child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                BlocBuilder<InvitadosMesasBloc, InvitadosMesasState>(
                  builder: (context, state) {
                    if (state is LoadingInvitadoMesasState) {
                      return Align(
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(),
                      );
                    } else if (state is MostraListaInvitadosMesaState) {
                      if (state.listaInvitadoMesa.isNotEmpty ||
                          state.listaInvitadoMesa != null) {
                        return Expanded(
                            child: buildListInvitadosConfirmador(
                                state.listaInvitadoMesa));
                      } else {
                        return Text('No Se Encontraron Datos');
                      }
                    } else if (state is ErrorInvitadoMesaState) {
                      return Center(
                        child: Text(state.message),
                      );
                    } else {
                      return Align(
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                )
              ],
            ),
          )),
          SizedBox(
            width: 8.0,
          ),
          Column(
            children: [
              ElevatedButton(
                onPressed: asignarMesas,
                child: Icon(Icons.arrow_forward),
              ),
              SizedBox(
                height: 10.0,
              ),
              ElevatedButton(
                  onPressed: _deleteAsignadoToMesa,
                  child: Icon(Icons.arrow_back))
            ],
          ),
          SizedBox(
            width: 8.0,
          ),
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              child: Column(
                children: [
                  BlocBuilder<MesasBloc, MesasState>(
                    builder: (context, state) {
                      if (state is LoadingMesasState) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (state is MostrarMesasState) {
                        if (state.listaMesas != null ||
                            state.listaMesas.isNotEmpty) {
                          return _buildListaMesas(state.listaMesas);
                        } else {
                          return Align(
                            alignment: Alignment.center,
                            child: Text(
                              'No se encontraron datos',
                              style: Theme.of(context).textTheme.headline6,
                            ),
                          );
                        }
                      } else if (state is ErrorMesasState) {
                        return Container(
                          child: Center(child: Text(state.message)),
                        );
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                  Divider(),
                  SizedBox(
                    height: 10.0,
                  ),
                  if (mesaModelData != null) Expanded(child: formTableByMesa())
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  _deleteAsignadoToMesa() async {
    if (mesaModelData != null) {
      if (listAsigandosToDelete.isEmpty) {
        _mostraMensaje(
          'Seleccione alguna opcion de la lista',
          Colors.red,
        );
      } else {
        final data = await mesasAsignadasService
            .deleteAsignadoFromMesa(listAsigandosToDelete);
        if (data == 'Ok') {
          _mostraMensaje('Se agrego correctamente', Colors.green);
          await invitadosBloc.add(MostrarInvitadosMesasEvent());

          await BlocProvider.of<MesasBloc>(context).add(MostrarMesasEvent());

          mesasAsignadasService
              .getMesasAsignadas()
              .then((value) => setState(() {
                    listaMesasAsignadas = value;
                  }));

          setState(() {
            checkedsAsignados = [];
            checkedsInvitados = [];

            listAsigandosToDelete.clear();
          });
        } else {
          setState(() {});
          _mostraMensaje('Ocurrio un error', Colors.red);
        }
      }
    } else {
      _mostraMensaje('Seleccione un mesa', Colors.red);
    }
    setState(() {});
  }

  asignarMesas() async {
    int lastPosicion = 0;
    List<int> listTemp = [];
    if (listaMesasAsignadas.length > 0 && mesaModelData != null) {
      final datosMesaAsginada = listaMesasAsignadas
          .where((mesaAsignada) => mesaAsignada.idMesa == mesaModelData.idMesa);
      datosMesaAsginada.forEach((element) {
        listPosicionDisponible.remove(element.posicion);
      });
      print('disponible');

      listPosicionDisponible.forEach((element) {
        print(element);
      });

      if (datosMesaAsginada.length > 0) {
        lastPosicion = datosMesaAsginada.last.posicion;
        datosMesaAsginada.forEach((asignado) {
          listTemp.add(asignado.posicion);
        });
      }

      print('Ocupados');
      listTemp.forEach((element) {
        print(element);
      });
    }
    print(listToAsignarForAdd.length);

    print(listPosicionDisponible.length <=
        (mesaModelData.dimension - listTemp.length));

    if (mesaModelData == null || listToAsignarForAdd.isEmpty) {
      _mostraMensaje('Selección una mesa y un invitado', Colors.red);
    } else {
      if (mesaModelData.dimension - lastPosicion < listToAsignarForAdd.length) {
        _mostraMensaje(
            'El número de invitados es mayor al numero de sillas', Colors.red);
      } else {
        var conLastPosicion = lastPosicion;
        listToAsignarForAdd.forEach((element) {
          element.posicion = ++conLastPosicion;
        });

        final data =
            await asignarMesasService.asignarPersonasMesas(listToAsignarForAdd);
        mesaModelData.dimension;
        if (data == 'Ok') {
          await invitadosBloc.add(MostrarInvitadosMesasEvent());

          mesasAsignadasService.getMesasAsignadas().then((value) {
            setState(() {
              listToAsignarForAdd.clear();
              listaMesasAsignadas = value;
              checkedsInvitados = [];
            });
          });

          _mostraMensaje('Se agrego correctamente', Colors.green);
          setState(() {});
        } else {
          _mostraMensaje(data, Colors.red);
        }
      }
    }
  }

  List<Text> _buildListAcompanantes(
      List<AcompanantesConfirmadosModel> listAcompanante) {
    List<Text> listaAcompanantes = [];
    if (listAcompanante.length > 0) {
      for (var i = 0; i < listAcompanante.length; i++) {
        listaAcompanantes.add(Text(listAcompanante[i].nombre));
      }
    }
    return listaAcompanantes;
  }

  _buildListaMesas(List<MesaModel> listaDeMesas) {
    Widget dropMenuSelectMesas = Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: DropdownButtonFormField(
          decoration: InputDecoration(
              labelText: 'Mesas',
              border: OutlineInputBorder(),
              constraints: BoxConstraints(maxWidth: size.width * 0.4)),
          items: listaDeMesas
              .map((mesa) =>
                  DropdownMenuItem(value: mesa, child: Text(mesa.descripcion)))
              .toList(),
          onChanged: (value) {
            setState(() {
              listPosicionDisponible.clear();
              checkedsAsignados = [];
              mesaModelData = value;
              mesaModelData.numDeMesa;
              listPosicionDisponible =
                  List.generate(mesaModelData.dimension, (index) => index + 1);

              isEdit = false;
              _isVisible = true;
            });
          },
        ));

    return dropMenuSelectMesas;
  }

  Widget buildListInvitadosConfirmador(
      List<InvitadosConfirmadosModel> listaInvitados) {
    if (checkedsInvitados.isEmpty) {
      for (var i = 0; i < listaInvitados.length; i++) {
        bool checked = false;
        checkedsInvitados.add(checked);
      }
    }
    return ListView.builder(
      shrinkWrap: true,
      itemCount: listaInvitados.length,
      itemBuilder: (BuildContext context, int index) {
        MesasAsignadasModel asignadotemp = MesasAsignadasModel();

        if (listaInvitados[index].idAcompanante != 0) {
          asignadotemp.idAcompanante = listaInvitados[index].idAcompanante;
        }
        asignadotemp.idEvento = listaInvitados[index].idEvento;
        asignadotemp.idInvitado = listaInvitados[index].idInvitado;
        asignadotemp.alergias = listaInvitados[index].alergias;
        asignadotemp.alimentacion = listaInvitados[index].alimentacion;
        asignadotemp.asistenciaEspecial =
            listaInvitados[index].asistenciaEspecial;
        if (mesaModelData != null) {
          asignadotemp.idMesa = mesaModelData.idMesa;
        }

        if (listaInvitados[index].idAcompanante != 0) {
          asignadotemp.acompanante = listaInvitados[index].nombre;
        } else {
          asignadotemp.invitado = listaInvitados[index].nombre;
        }

        return ListTile(
          leading: Padding(
            padding: EdgeInsets.only(
                left: (listaInvitados[index].idAcompanante != 0) ? 15 : 0),
            child: AbsorbPointer(
              absorbing: isEdit,
              child: Visibility(
                visible: _isVisible,
                child: Checkbox(
                    value: checkedsInvitados[index],
                    onChanged: (value) {
                      setState(() {
                        !checkedsInvitados[index]
                            ? checkedsInvitados[index] = true
                            : checkedsInvitados[index] = false;
                      });

                      if (checkedsInvitados[index]) {
                        listToAsignarForAdd.add(asignadotemp);
                      } else if (!checkedsInvitados[index]) {
                        listToAsignarForAdd.removeWhere((element) =>
                            element.idAcompanante ==
                                asignadotemp.idAcompanante &&
                            element.idInvitado == asignadotemp.idInvitado);
                      }
                      // listDisponiblesToAdd
                    }),
              ),
            ),
          ),
          title: Text(
            listaInvitados[index].nombre,
            style: TextStyle(color: Colors.black),
          ),
          // children: widgetAcompanantes,
        );
      },
    );
  }

  Widget formTableByMesa() {
    final listaAsignados =
        listaMesasAsignadas.where((m) => m.idMesa == mesaModelData.idMesa);
    return Form(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: mesaModelData.dimension,
        itemBuilder: (BuildContext context, int i) {
          // * Asignar personas a sillas
          String temp = '';
          MesasAsignadasModel asignadotemp;

          if (listaMesasAsignadas.isNotEmpty) {
            final asigando = listaAsignados.firstWhere(
              (a) => a.posicion == i + 1,
              orElse: () => null,
            );
            if (asigando != null) {
              asignadotemp = asigando;
              asigando.idAcompanante != 0
                  ? temp = asigando.acompanante
                  : temp = asigando.invitado;
            }
          }
          // * Asignar values to checkeds a Checkbox

          bool checked = false;

          checkedsAsignados.add(checked);

          return Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: temp == ''
                    ? null
                    : Checkbox(
                        value: checkedsAsignados[i],
                        onChanged: (value) {
                          setState(() {
                            checkedsAsignados[i] = value;
                          });

                          if (checkedsAsignados[i] && mesaModelData != null) {
                            listAsigandosToDelete.add(asignadotemp);
                          } else if (!checkedsAsignados[i]) {
                            listAsigandosToDelete.remove(asignadotemp);
                          }
                        },
                      ),
                title: Padding(
                  padding: EdgeInsets.only(left: temp == '' ? 14 : 0),
                  child: Text(temp),
                ),
                subtitle: Text('Silla ${i + 1}:'),
              ),
            ),
          );
        },
      ),
    );
  }
}
