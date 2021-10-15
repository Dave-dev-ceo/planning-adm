import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weddingplanner/src/blocs/Mesas/mesas_bloc.dart';
import 'package:weddingplanner/src/blocs/invitadosMesa/invitadosmesas_bloc.dart';
import 'package:weddingplanner/src/logic/mesas_asignadas_logic/mesas_asignadas_services.dart';
import 'package:weddingplanner/src/models/MesasAsignadas/mesas_asignadas_model.dart';
import 'package:weddingplanner/src/models/invitadosConfirmadosModel/invitado_mesa_Model.dart';
import 'package:weddingplanner/src/models/mesa/mesas_model.dart';

class MesasPage extends StatefulWidget {
  @override
  State<MesasPage> createState() => _MesasPageState();
}

class _MesasPageState extends State<MesasPage> {
  final mesasAsignadasService = MesasAsignadasService();
  MesaModel mesaModelData;
  Size size;
  int indexNavBar = 0;
  int _isEnable = 1;
  bool _estado = true;
  List<MesasAsignadasModel> listaMesasAsignadas;
  List<bool> checkedsInvitados = [];
  List<bool> checkedsAsignados = [];
  List<MesasAsignadasModel> listAsigandosToDelete = [];
  int lastNumMesa;

  @override
  void initState() {
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
        onPressed: () {
          Navigator.of(context).pushNamed('/asignarMesas',
              arguments: (lastNumMesa == null) ? lastNumMesa = 0 : lastNumMesa);
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

  // ? Page Asiganer Mesas a Inivtados

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
                onPressed: (!_estado)
                    ? null
                    : () {
                        print('Asignando...');
                      },
                child: Icon(Icons.arrow_forward),
              ),
              SizedBox(
                height: 10.0,
              ),
              ElevatedButton(
                  onPressed: () {
                    print('Quitando...');

                    listAsigandosToDelete.forEach((asginado) {
                      print(asginado.toJson());
                    });
                  },
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

  // Widget _buildListInvitadosConfirmador(
  //     List<InvitadosConfirmadosModel> listaInvitados) {
  //   if (checkedsInvitados.isEmpty) {
  //     for (var i = 0; i < listaInvitados.length; i++) {
  //       bool checked = false;
  //       checkedsInvitados.add(checked);
  //     }
  //   }
  //   return ListView.builder(
  //       shrinkWrap: true,
  //       itemCount: listaInvitados.length,
  //       itemBuilder: (BuildContext context, int index) {
  //         return ParentChildCheckbox(
  //             parent: Text(
  //               listaInvitados[index].nombre,
  //               key: Key(listaInvitados[index].idInvitado.toString()),
  //             ),
  //             children:
  //                 _buildListAcompanantes(listaInvitados[index].acompanantes));
  //       });
  // }

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
              mesaModelData = value;
            });
          },
        ));

    return dropMenuSelectMesas;
  }

  Widget buildListInvitadosConfirmador(
      List<InvitadosConfirmadosModel> listaInvitados) {
    List<InvitadosConfirmadosModel> tempListaInvitados = [];
    print('Entro metodo ever');
    listaInvitados.forEach((elementInv) => {
          listaMesasAsignadas.forEach((elementMesaAsig) {
            if (elementInv.idInvitado != elementMesaAsig.idInvitado) {
              tempListaInvitados.add(elementInv);
            }
          })
        });

    listaInvitados = tempListaInvitados;

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
        List<Widget> widgetAcompanantes = [];

        final acompanantes = listaInvitados[index].acompanantes;

        for (var acompanante in acompanantes) {
          Widget widgetAcompanante = Padding(
              padding: EdgeInsets.only(left: 15.0),
              child: ListTile(
                leading: Checkbox(
                  value: false,
                  onChanged: (value) {},
                ),
                title: Text(
                  acompanante.nombre,
                  style: TextStyle(color: Colors.black),
                ),
              ));

          widgetAcompanantes.add(widgetAcompanante);
        }

        return ExpansionTile(
          initiallyExpanded: true,
          leading: Checkbox(
              value: checkedsInvitados[index],
              onChanged: (value) {
                setState(() {
                  !checkedsInvitados[index]
                      ? checkedsInvitados[index] = true
                      : checkedsInvitados[index] = false;
                });

                _isEnable = 0;
                checkedsInvitados.forEach((element) {
                  if (element) {
                    _isEnable++;
                  }
                });

                if (_isEnable == 0) {
                  setState(() {
                    _estado = false;
                  });
                } else {
                  setState(() {
                    _estado = true;
                  });
                }
              }),
          title: Text(
            listaInvitados[index].nombre,
            style: TextStyle(color: Colors.black),
          ),
          children: widgetAcompanantes,
        );
      },
    );
  }

  Widget formTableByMesa() {
    print('Select mesa');
    // listAsigandosToDelete.clear();
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
                leading: Checkbox(
                  value: checkedsAsignados[i],
                  onChanged: (value) {
                    setState(() {
                      checkedsAsignados[i] = value;
                    });

                    if (checkedsAsignados[i]) {
                      print(asignadotemp.posicion);
                      listAsigandosToDelete.add(asignadotemp);
                    } else if (!checkedsAsignados[i]) {
                      // ! Ever quitar elemento de la lista listAsigandosToDelete.
                      listAsigandosToDelete.remove(asignadotemp);
                    }
                  },
                ),
                title: TextFormField(
                  initialValue: temp,
                  decoration: InputDecoration(
                    labelText: 'Silla ${i + 1}',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // Widget _buildTableMesasAsignadas(List<MesasModel> listaMesas) {
  //   return Align(
  //     alignment: Alignment.topCenter,
  //     child: ConstrainedBox(
  //       constraints: BoxConstraints(
  //         maxWidth: size.width * 0.6,
  //       ),
  //       child: Card(
  //         child: ListView.builder(
  //             shrinkWrap: true,
  //             itemCount: listaMesas.length,
  //             itemBuilder: (BuildContext context, int i) {
  //               List<Asignados> asignados = listaMesas[i].asignados;

  //               List<Widget> listWidgetAsignados = [];

  //               for (var asignado in asignados) {
  //                 Widget asignadoWidgetTemp = Padding(
  //                   padding: const EdgeInsets.all(10.0),
  //                   child: ListTile(
  //                     title: Text(
  //                       '${asignado.posicion}: ${asignado.asignado}',
  //                       textAlign: TextAlign.left,
  //                     ),
  //                     trailing: Row(
  //                       mainAxisSize: MainAxisSize.min,
  //                       children: [
  //                         IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
  //                         IconButton(onPressed: () {}, icon: Icon(Icons.delete))
  //                       ],
  //                     ),
  //                   ),
  //                 );

  //                 listWidgetAsignados.add(asignadoWidgetTemp);
  //               }

  //               return ExpansionTile(
  //                 title: Padding(
  //                   padding: const EdgeInsets.symmetric(
  //                       horizontal: 5.0, vertical: 10.0),
  //                   child: Center(
  //                     child: Text(
  //                       '${listaMesas[i].nombre}',
  //                       style: TextStyle(
  //                         fontSize: 20,
  //                         color: Colors.black,
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //                 children: listWidgetAsignados,
  //               );
  //             }),
  //       ),
  //     ),
  //   );
  // }

}
