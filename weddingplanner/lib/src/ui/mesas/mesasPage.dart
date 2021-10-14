import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weddingplanner/src/blocs/Mesas/mesas_bloc.dart';
import 'package:weddingplanner/src/blocs/invitadosMesa/invitadosmesas_bloc.dart';
import 'package:weddingplanner/src/models/invitadosConfirmadosModel/invitado_mesa_Model.dart';
import 'package:weddingplanner/src/models/mesa/mesas_model.dart';

class MesasPage extends StatefulWidget {
  @override
  State<MesasPage> createState() => _MesasPageState();
}

class _MesasPageState extends State<MesasPage> {
  MesaModel mesaModelData;
  Size size;
  int indexNavBar = 0;
  int _isEnable = 1;
  bool _estado = false;
  List<bool> checkeds = [];

  @override
  void initState() {
    BlocProvider.of<MesasBloc>(context).add(MostrarMesasEvent());
    BlocProvider.of<InvitadosMesasBloc>(context)
        .add(MostrarInvitadosMesasEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final listWidget = [resumenMesasPage(), asignarInvitadosMesasPage()];
    size = MediaQuery.of(context).size;
    return Scaffold(
      bottomNavigationBar: _bottomNavigatorBarCustom(),
      body: listWidget[indexNavBar],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/asignarMesas');
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

  Widget resumenMesasPage() {
    Widget WidgetBlocMesas = BlocBuilder<MesasBloc, MesasState>(
      builder: (context, state) {
        if (state is LoadingMesasState) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is MostrarMesasState) {
          if (state.listaMesas.isNotEmpty && state.listaMesas != null) {
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
                    print(state);
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
                child: Text('Asignar'),
              ),
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

  Widget _gridMesasWidget(List<MesaModel> listaMesa) {
    Widget gridOfListaMesas = GridView.builder(
        itemCount: listaMesa.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1.5,
        ),
        itemBuilder: (BuildContext context, int index) {
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
                              return TextFormField(
                                enabled: false,
                                decoration:
                                    InputDecoration(labelText: 'Silla $i'),
                                initialValue: 'Disponible',
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

  // ! Implementar Widget para el paso 2

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
    if (checkeds.isEmpty) {
      for (var i = 0; i < listaInvitados.length; i++) {
        bool checked = false;
        checkeds.add(checked);
      }
    }
    return ListView.builder(
      shrinkWrap: true,
      itemCount: listaInvitados.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          enabled: true,
          leading: Checkbox(
              value: checkeds[index],
              onChanged: (value) {
                setState(() {
                  !checkeds[index]
                      ? checkeds[index] = true
                      : checkeds[index] = false;
                });

                _isEnable = 0;
                checkeds.forEach((element) {
                  print(element);
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
          title: Text(listaInvitados[index].nombre),
        );
      },
    );
  }

  Widget formTableByMesa() {
    return Form(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: mesaModelData.dimension,
        itemBuilder: (BuildContext context, int i) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Silla ${i + 1}',
                  border: OutlineInputBorder(),
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
