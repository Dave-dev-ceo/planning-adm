// ignore_for_file: unused_field

import 'dart:typed_data';
import 'dart:convert';

import 'package:planning/src/animations/loading_animation.dart';
import 'package:planning/src/blocs/mesasAsignadas/mesasasignadas_bloc.dart';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:native_pdf_view/native_pdf_view.dart';
import 'package:planning/src/ui/widgets/snackbar_widget/snackbar_widget.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'package:planning/src/blocs/invitadosMesa/invitadosmesas_bloc.dart';
import 'package:planning/src/blocs/Mesas/mesas_bloc.dart';

import 'package:planning/src/logic/mesas_asignadas_logic/mesas_asignadas_services.dart';
import 'package:planning/src/logic/mesas_logic/mesa_logic.dart';
import 'package:planning/src/models/item_model_preferences.dart';
import 'package:planning/src/models/mesa/layout_mesa_model.dart';
import 'package:planning/src/models/mesa/mesas_model.dart';
import 'package:planning/src/models/MesasAsignadas/mesas_asignadas_model.dart';
import 'package:planning/src/models/invitadosConfirmadosModel/invitado_mesa_model.dart';
import 'package:planning/src/utils/utils.dart';

class MesasPage extends StatefulWidget {
  const MesasPage({Key key, this.nameEvento}) : super(key: key);

  final String nameEvento;

  @override
  State<MesasPage> createState() => _MesasPageState();
}

class _MesasPageState extends State<MesasPage> {
  // * Se crea la variable donde se guardara
  Uint8List capturedImage;

  final mesasAsignadasService = MesasAsignadasService();
  final mesasLogic = ServiceMesasLogic();
  GlobalKey previewContainer = GlobalKey();

  List<bool> checkedsAsignados = [];
  List<bool> checkedsInvitados = [];
  List<bool> editTitleMesa = [];

  List<InvitadosConfirmadosModel> _listaInvitadoDisponibles = [];
  List<MesasAsignadasModel> listAsigandosToDelete = [];
  List<MesasAsignadasModel> listToAsignarForAdd = [];
  List<MesasAsignadasModel> listaMesasAsignadas = [];
  List<int> listPosicionDisponible = [];
  List<MesaModel> listaMesaFromDB = [];

  PdfViewerController _pdfViewerController;

  InvitadosMesasBloc invitadosBloc;
  MesaModel mesaModelData;
  Size size;
  bool isEdit = true;
  bool _enable;
  bool _isVisible = false;
  int indexNavBar = 0;
  int lastNumMesa = 0;
  Future<LayoutMesaModel> layoutMesaFuture;

  // Variable involucrado
  bool isInvolucrado = false;

  @override
  void initState() {
    layoutMesaFuture = mesasAsignadasService.getLayoutMesa();
    getIdInvolucrado();
    invitadosBloc = BlocProvider.of<InvitadosMesasBloc>(context);
    BlocProvider.of<MesasBloc>(context).add(MostrarMesasEvent());
    BlocProvider.of<MesasAsignadasBloc>(context).add(GetMesasAsignadasEvent());
    BlocProvider.of<InvitadosMesasBloc>(context)
        .add(MostrarInvitadosMesasEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {});
    final listWidget = [
      asignarInvitadosMesasPage(),
      resumenMesasPage(),
      layoutMesa()
    ];
    size = MediaQuery.of(context).size;
    return Scaffold(
      bottomNavigationBar: _bottomNavigatorBarCustom(),
      body: BlocBuilder<MesasAsignadasBloc, MesasAsignadasState>(
        builder: (context, state) {
          if (state is LoadingMesasAsignadasState) {
            return const Center(
              child: LoadingCustom(),
            );
          } else if (state is MostrarMesasAsignadasState) {
            if (state.listaMesasAsignadas != null &&
                state.listaMesasAsignadas.isNotEmpty) {
              listaMesasAsignadas = state.listaMesasAsignadas;
            } else {
              listaMesasAsignadas = [];
            }
            return listWidget[indexNavBar];
          } else {
            listaMesasAsignadas = [];
            return listWidget[indexNavBar];
          }
        },
      ),
      floatingActionButton: buttonByPage(),
    );
  }

  void getIdInvolucrado() async {
    final _idInvolucrado = await SharedPreferencesT().getIdInvolucrado();

    if (_idInvolucrado != null) {
      isInvolucrado = true;
    }
  }

  Widget buttonByPage() {
    switch (indexNavBar) {
      case 0:
        //if (!isInvolucrado) {
        return _buttonAddMesas();
        //} else {
        //  return FloatingActionButton(onPressed: () {}, heroTag: UniqueKey());
        //}
        break;
      case 1:
        return _expandableButtonOptions();
        break;
      default:
        return _buttonUpdateLayout();
        break;
    }
  }

  Widget _buttonUpdateLayout() {
    return FloatingActionButton(
      onPressed: () async {
        const extensiones = ['jpg', 'png', 'jpeg', 'pdf'];

        FilePickerResult pickedFile = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          withData: true,
          allowedExtensions: extensiones,
          allowMultiple: false,
        );

        if (pickedFile != null) {
          final bytes = pickedFile.files.first.bytes;
          String _extension = pickedFile.files.first.extension;

          String file64 = base64Encode(bytes);

          mesasLogic.createLayout(file64, _extension).then((value) => {
                if (value == 'Ok')
                  {
                    MostrarAlerta(
                        mensaje: 'Se subió correctamente el layout',
                        tipoMensaje: TipoMensaje.correcto)
                  }
                else
                  {
                    MostrarAlerta(
                        mensaje: value, tipoMensaje: TipoMensaje.error)
                  },
                setState(() {
                  layoutMesaFuture = mesasAsignadasService.getLayoutMesa();
                }),
              });
        } else {}
      },
      child: const Icon(Icons.upload),
      tooltip: 'Subir archivo',
    );

    // return SpeedDial(
    //   activeForegroundColor: Colors.blueGrey,
    //   icon: Icons.more_vert,
    //   activeIcon: Icons.close,
    //   activeLabel: const Text('Cerrar'),
    //   animatedIconTheme: const IconThemeData(size: 22.0),
    //   curve: Curves.bounceIn,
    //   tooltip: 'Opciones',
    //   elevation: 8.0,
    //   shape: const CircleBorder(),
    //   children: [
    //     SpeedDialChild(
    //       child: const Icon(Icons.upload),
    //       label: 'Subir archivo',
    //       onTap: () async {
    //         const extensiones = ['jpg', 'png', 'jpeg', 'pdf'];

    //         FilePickerResult pickedFile = await FilePicker.platform.pickFiles(
    //           type: FileType.custom,
    //           withData: true,
    //           allowedExtensions: extensiones,
    //           allowMultiple: false,
    //         );

    //         if (pickedFile != null) {
    //           final bytes = pickedFile.files.first.bytes;
    //           String _extension = pickedFile.files.first.extension;

    //           String file64 = base64Encode(bytes);

    //           mesasLogic.createLayout(file64, _extension).then((value) => {
    //                 if (value == 'Ok')
    //                   {
    //                     MostrarAlerta(
    //                         mensaje: 'Se subio correctamente el layout',
    //                         tipoMensaje: TipoMensaje.correcto)
    //                   }
    //                 else
    //                   {
    //                     MostrarAlerta(
    //                         mensaje: value, tipoMensaje: TipoMensaje.error)
    //                   },
    //                 setState(() {
    //                   layoutMesaFuture = mesasAsignadasService.getLayoutMesa();
    //                 }),
    //               });
    //         } else {}
    //       },
    //     ),
    //   ],
    // );
  }

  Widget _expandableButtonOptions() {
    return SpeedDial(
      activeForegroundColor: Colors.blueGrey,
      icon: Icons.more_vert,
      activeIcon: Icons.close,
      activeLabel: const Text('Cerrar'),
      animatedIconTheme: const IconThemeData(size: 22.0),
      curve: Curves.bounceIn,
      tooltip: 'Opciones',
      elevation: 8.0,
      shape: const CircleBorder(),
      children: [
        SpeedDialChild(
          child: const Icon(Icons.add),
          label: 'Añadir mesa',
          onTap: () {
            Navigator.of(context)
                .pushNamed('/asignarMesas', arguments: lastNumMesa ?? 0)
                .then((value) => {
                      lastNumMesa = value ?? 0,
                    });
          },
        ),
        SpeedDialChild(
          child: const Icon(Icons.download),
          label: 'Descargar PDF',
          onTap: () async {
            if (listaMesaFromDB != null && listaMesaFromDB.isNotEmpty) {
              // * Descargar PDF
              // await _createPdfToMesa();
              final datosMesas =
                  await mesasAsignadasService.getPDFMesasAsiganadas();
              if (datosMesas != null) {
                downloadFile(datosMesas, 'Mesas Asignadas');
              }
            } else {
              MostrarAlerta(
                  mensaje: 'No se encontraron datos',
                  tipoMensaje: TipoMensaje.advertencia);
            }
          },
        ),
      ],
    );
  }

  Widget _buttonAddMesas() {
    return FloatingActionButton(
      heroTag: UniqueKey(),
      tooltip: 'Agregar mesa',
      child: const Icon(Icons.add),
      onPressed: () {
        Navigator.of(context)
            .pushNamed('/asignarMesas', arguments: lastNumMesa ?? 0)
            .then((value) => {
                  lastNumMesa = value ?? lastNumMesa,
                });
      },
    );
  }

  BottomNavigationBar _bottomNavigatorBarCustom() {
    return BottomNavigationBar(
      currentIndex: indexNavBar,
      items: const [
        BottomNavigationBarItem(
            icon: Icon(Icons.post_add_sharp),
            label: 'Asignar',
            tooltip: 'Asignar mesas'),
        BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_outlined),
            label: 'Mesas',
            tooltip: 'Resumen mesas'),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.layers_outlined,
            ),
            label: 'Layout',
            tooltip: 'Layout mesa')
      ],
      onTap: (int index) {
        setState(() {
          indexNavBar = index;
        });
      },
    );
  }

  // ? Resumen de Mesas Asignadas

  Widget resumenMesasPage() {
    setState(() {});
    Widget widgetBlocMesas = BlocBuilder<MesasBloc, MesasState>(
      builder: (context, state) {
        if (state is LoadingMesasState) {
          return const Center(
            child: LoadingCustom(),
          );
        } else if (state is MostrarMesasState) {
          if (state.listaMesas.isNotEmpty && state.listaMesas != null) {
            lastNumMesa = state.listaMesas.last.numDeMesa ?? 0;
            listaMesaFromDB = state.listaMesas;
            return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: _gridMesasWidget(state.listaMesas));
          } else {
            lastNumMesa = 0;
            return Align(
              alignment: Alignment.center,
              child: Text(
                'No se encontraron datos',
                style: Theme.of(context).textTheme.headline6,
              ),
            );
          }
        } else if (state is ErrorMesasState) {
          lastNumMesa = 0;

          return Center(child: Text(state.message));
        } else {
          lastNumMesa = 0;

          return const Center(child: LoadingCustom());
        }
      },
    );

    return Column(
      children: [
        const SizedBox(
          height: 20.0,
        ),
        Flexible(child: widgetBlocMesas)
      ],
    );
  }

  Widget _gridMesasWidget(List<MesaModel> listaMesa) {
    return RefreshIndicator(
      color: Colors.blue,
      onRefresh: () async {
        BlocProvider.of<MesasAsignadasBloc>(context)
            .add(GetMesasAsignadasEvent());
        BlocProvider.of<MesasBloc>(context).add(MostrarMesasEvent());
        BlocProvider.of<InvitadosMesasBloc>(context)
            .add(MostrarInvitadosMesasEvent());
      },
      child: GridView.builder(
        key: previewContainer,
        itemCount: listaMesa.length,
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 500,
          mainAxisExtent: 300,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
        itemBuilder: (BuildContext context, int index) {
          editTitleMesa.add(false);
          final listaAsignados = listaMesasAsignadas
              .where((m) => m.idMesa == listaMesa[index].idMesa);
          return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              margin: const EdgeInsets.all(6.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Center(
                      child: ListTile(
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            PreferredSize(
                              preferredSize: const Size.fromWidth(15),
                              child: IconButton(
                                onPressed: () async {
                                  showDialog(
                                    context: context,
                                    builder: (context) => EditMesaDialog(
                                      mesaModel: listaMesa[index],
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.edit),
                              ),
                            ),
                            PreferredSize(
                              preferredSize: const Size.fromWidth(12),
                              child: IconButton(
                                onPressed: () async {
                                  _showAlertDialogDeleteMesa(
                                      listaMesa[index].idMesa, listaAsignados);
                                  setState(() {});
                                },
                                icon: const Icon(Icons.delete),
                              ),
                            ),
                          ],
                        ),
                        title: Text(listaMesa[index].descripcion),
                        // TextFormField(
                        //   enabled: editTitleMesa[index],
                        //   decoration: InputDecoration(
                        //     border: InputBorder.none,
                        //   ),
                        //   initialValue: listaMesa[index].descripcion,
                        //   onChanged: (value) {
                        //     nameCurrentMesa = value;
                        //   },
                        // ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 4),
                        subtitle: Text(listaMesa[index].tipoMesa),
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Expanded(
                      child: ListView.builder(
                          itemExtent: 35.0,
                          itemCount: listaMesa[index].dimension,
                          itemBuilder: (BuildContext context, int i) {
                            String temp = '';
                            if (listaMesasAsignadas.isNotEmpty) {
                              final asigando = listaAsignados.firstWhere(
                                (a) => a.posicion == i + 1,
                                orElse: () => null,
                              );
                              if (asigando != null) {
                                asigando.idAcompanante != 0
                                    ? temp = asigando.acompanante
                                    : temp = asigando.invitado;
                              }
                            }
                            return ListTile(
                              title: Text('Silla ${i + 1}: $temp'),
                            );
                          }),
                    )
                  ],
                ),
              ));
        },
      ),
    );
  }

  void _showAlertDialogDeleteMesa(
      int idMesa, Iterable<MesasAsignadasModel> listaAsignados) async {
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Eliminar mesa'),
              content: const Text('¿Estás seguro de eliminar la mesa?'),
              actions: [
                TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancelar'),
                ),
                TextButton(
                    onPressed: () async {
                      final data = await mesasLogic.deleteMesa(idMesa);
                      if (data == 'Ok') {
                        BlocProvider.of<MesasBloc>(context)
                            .add(MostrarMesasEvent());

                        BlocProvider.of<MesasAsignadasBloc>(context)
                            .add(GetMesasAsignadasEvent());
                        BlocProvider.of<InvitadosMesasBloc>(context)
                            .add(MostrarInvitadosMesasEvent());

                        MostrarAlerta(
                            mensaje: 'La mesa se eliminó correctamente',
                            tipoMensaje: TipoMensaje.correcto);
                        Navigator.of(context).pop();
                      } else {
                        MostrarAlerta(
                            mensaje:
                                'Ocurrió un error al intentar eliminar la mesa',
                            tipoMensaje: TipoMensaje.error);
                      }
                    },
                    child: const Text('Aceptar'))
              ],
            ));
  }

  Widget asignarInvitadosMesasPage() {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          return buildAsignarMesaDesktop();
        } else {
          return buildAsignarMesaMovil();
        }
      },
    );
  }

  Widget buildAsignarMesaMovil() {
    return SingleChildScrollView(
      child: RefreshIndicator(
        color: Colors.blue,
        onRefresh: () async {
          BlocProvider.of<MesasAsignadasBloc>(context)
              .add(GetMesasAsignadasEvent());
          BlocProvider.of<MesasBloc>(context).add(MostrarMesasEvent());
          BlocProvider.of<InvitadosMesasBloc>(context)
              .add(MostrarInvitadosMesasEvent());
        },
        child: Column(
          children: [
            const SizedBox(
              height: 15.0,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
              child: _buildInvitados(),
            ),
            const SizedBox(
              height: 8.0,
            ),
            Row(
              children: [
                const SizedBox(
                  width: 10.0,
                ),
                ElevatedButton(
                  onPressed: asignarMesas,
                  child: const Icon(Icons.arrow_downward),
                ),
                const SizedBox(
                  width: 5.0,
                ),
                ElevatedButton(
                  onPressed: _deleteAsignadoToMesa,
                  child: const Icon(Icons.arrow_upward),
                ),
                const Spacer(),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 5.0,
                  ),
                  onPressed: _asignarAutoMesas,
                  child: const Text('Asignar auto.'),
                ),
                const SizedBox(
                  width: 10.0,
                )
              ],
            ),
            const SizedBox(
              height: 8.0,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
              child: _mesasBuild(),
            ),
          ],
        ),
      ),
    );
  }

  Card _buildInvitados([bool esDesktop = false]) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Column(
        children: [
          BlocBuilder<InvitadosMesasBloc, InvitadosMesasState>(
            builder: (context, state) {
              if (state is LoadingInvitadoMesasState) {
                return const Align(
                  alignment: Alignment.center,
                  child: LoadingCustom(),
                );
              } else if (state is MostraListaInvitadosMesaState) {
                state.listaInvitadoMesa.isNotEmpty
                    ? _enable = true
                    : _enable = false;
                if (state.listaInvitadoMesa.isNotEmpty ||
                    state.listaInvitadoMesa != null) {
                  _listaInvitadoDisponibles = state.listaInvitadoMesa;
                  //
                  return esDesktop
                      ? Expanded(
                          child: buildListInvitadosConfirmador(
                              state.listaInvitadoMesa),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: buildListInvitadosConfirmador(
                              state.listaInvitadoMesa),
                        );
                } else {
                  return const Text('No se encontraron datos');
                }
              } else if (state is ErrorInvitadoMesaState) {
                return Center(
                  child: Text(state.message),
                );
              } else {
                return const Align(
                  alignment: Alignment.center,
                  child: LoadingCustom(),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Card _mesasBuild() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Column(
        children: [
          BlocBuilder<MesasBloc, MesasState>(
            builder: (context, state) {
              if (state is LoadingMesasState) {
                return const Center(
                  child: LoadingCustom(),
                );
              } else if (state is MostrarMesasState) {
                if (state.listaMesas != null) {
                  if (state.listaMesas.isNotEmpty) {
                    lastNumMesa = state.listaMesas.last.numDeMesa ?? 0;
                    listaMesaFromDB = state.listaMesas;
                    return _buildListaMesas(state.listaMesas);
                  } else {
                    lastNumMesa = 0;
                    return Align(
                      alignment: Alignment.center,
                      child: Text(
                        'No se encontraron datos',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    );
                  }
                } else {
                  lastNumMesa = 0;
                  return Align(
                    alignment: Alignment.center,
                    child: Text(
                      'No se encontraron datos',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  );
                }
              } else if (state is ErrorMesasState) {
                lastNumMesa = 0;

                return Center(child: Text(state.message));
              } else {
                lastNumMesa = 0;

                return Align(
                  alignment: Alignment.center,
                  child: Text(
                    'No se encontraron datos',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                );
              }
            },
          ),
          if (mesaModelData != null) const Divider(),
          if (mesaModelData != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 14.0),
              child: formTableByMesa(),
            )
        ],
      ),
    );
  }

  Widget buildAsignarMesaDesktop() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: [
          const SizedBox(
            height: 20.0,
          ),
          Expanded(
            child: _mesasBuild(),
          ),
          const SizedBox(
            width: 8.0,
          ),
          Column(
            children: [
              const SizedBox(
                height: 10.0,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 5.0,
                  minimumSize: const Size(10.0, 8.0),
                ),
                onPressed: asignarMesas,
                // child: Text('Regresar'),
                child: const Icon(Icons.arrow_back),
              ),
              const SizedBox(
                height: 10.0,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 5.0,
                  minimumSize: const Size(10.0, 8.0),
                ),
                onPressed: _deleteAsignadoToMesa,
                // child: Text('Asignar'),
                child: const Icon(Icons.arrow_forward),
              ),
              const Spacer(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 5.0,
                ),
                onPressed: _asignarAutoMesas,
                child: const Text('Asignar auto.'),
              ),
            ],
          ),
          const SizedBox(
            width: 10.0,
          ),
          Expanded(
            child: _buildInvitados(true),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteAsignadoToMesa() async {
    if (mesaModelData != null) {
      if (listAsigandosToDelete.isEmpty) {
        MostrarAlerta(
          mensaje: 'Seleccione alguna opción de la lista',
          tipoMensaje: TipoMensaje.advertencia,
        );
      } else {
        final data = await mesasAsignadasService
            .deleteAsignadoFromMesa(listAsigandosToDelete);
        if (data == 'Ok') {
          MostrarAlerta(
              mensaje: 'Se han eliminado correctamente',
              tipoMensaje: TipoMensaje.correcto);
          invitadosBloc.add(MostrarInvitadosMesasEvent());

          BlocProvider.of<MesasBloc>(context).add(MostrarMesasEvent());
          BlocProvider.of<MesasAsignadasBloc>(context)
              .add(GetMesasAsignadasEvent());

          mesasAsignadasService
              .getMesasAsignadas()
              .then((value) => setState(() {
                    listaMesasAsignadas = value;
                    checkedsAsignados = [];
                    checkedsInvitados = [];

                    for (var i = 0; i < listAsigandosToDelete.length; i++) {
                      if (listPosicionDisponible
                          .contains(listAsigandosToDelete[i].posicion)) {
                      } else {
                        listPosicionDisponible
                            .add(listAsigandosToDelete[i].posicion);
                      }
                    }

                    listPosicionDisponible.sort();

                    listAsigandosToDelete.clear();
                  }));
        } else {
          MostrarAlerta(
              mensaje: 'Ocurrió un error al intentar eliminar al invitado',
              tipoMensaje: TipoMensaje.error);
        }
      }
    } else {
      MostrarAlerta(
          mensaje: 'Seleccione una mesa', tipoMensaje: TipoMensaje.advertencia);
    }
  }

  Future<void> asignarMesas() async {
    List<int> listTemp = [];
    if (listaMesasAsignadas.isNotEmpty && mesaModelData != null) {
      final datosMesaAsginada = listaMesasAsignadas
          .where((mesaAsignada) => mesaAsignada.idMesa == mesaModelData.idMesa);
      for (var element in datosMesaAsginada) {
        listPosicionDisponible.remove(element.posicion);
      }

      if (datosMesaAsginada.isNotEmpty) {
        for (var asignado in datosMesaAsginada) {
          listTemp.add(asignado.posicion);
        }
      }
    }

    if (mesaModelData == null || listToAsignarForAdd.isEmpty) {
      MostrarAlerta(
          mensaje: 'Seleccione la mesa y los invitados a asignar',
          tipoMensaje: TipoMensaje.advertencia);
    } else {
      if (listToAsignarForAdd.length >
          (mesaModelData.dimension - listTemp.length)) {
        MostrarAlerta(
            mensaje:
                'El número de invitados es mayor al número de sillas disponibles',
            tipoMensaje: TipoMensaje.advertencia);
      } else {
        for (var i = 0; i < listToAsignarForAdd.length; i++) {
          listToAsignarForAdd[i].posicion = listPosicionDisponible[i];
        }

        final data = await mesasAsignadasService
            .asignarPersonasMesas(listToAsignarForAdd);
        mesaModelData.dimension;
        if (data == 'Ok') {
          invitadosBloc.add(MostrarInvitadosMesasEvent());

          BlocProvider.of<MesasBloc>(context).add(MostrarMesasEvent());
          BlocProvider.of<MesasAsignadasBloc>(context)
              .add(GetMesasAsignadasEvent());
          mesasAsignadasService.getMesasAsignadas().then((value) {
            setState(() {
              for (var element in listAsigandosToDelete) {
                listPosicionDisponible.remove(element.posicion);
              }
              listToAsignarForAdd.clear();
              checkedsInvitados = [];
            });
            setState(() {
              listaMesasAsignadas = value;
            });
          });
          invitadosBloc.add(MostrarInvitadosMesasEvent());

          MostrarAlerta(
              mensaje: 'Se han asignado correctamente',
              tipoMensaje: TipoMensaje.correcto);
          setState(() {
            listToAsignarForAdd.clear();
          });
        } else {
          MostrarAlerta(mensaje: data, tipoMensaje: TipoMensaje.error);
        }
      }
    }
  }

  _buildListaMesas(List<MesaModel> listaDeMesas) {
    Widget dropMenuSelectMesas = Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: DropdownButtonFormField(
          style: const TextStyle(
            color: Colors.black,
            overflow: TextOverflow.ellipsis,
          ),
          decoration: InputDecoration(
              labelText: 'Mesas',
              border: const OutlineInputBorder(),
              constraints: BoxConstraints(maxWidth: size.width * 0.4)),
          items: listaDeMesas
              .map((mesa) =>
                  DropdownMenuItem(value: mesa, child: Text(mesa.descripcion)))
              .toList(),
          value: listaDeMesas.firstWhere(
            (element) => element.idMesa == mesaModelData?.idMesa,
            orElse: () => null,
          ),
          onChanged: (value) {
            setState(() {
              listPosicionDisponible.clear();
              checkedsAsignados = [];
              mesaModelData = value;
              mesaModelData.numDeMesa;
              listPosicionDisponible =
                  List.generate(mesaModelData.dimension, (index) => index + 1);

              checkedsInvitados = [];
              listToAsignarForAdd.clear();

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
      itemExtent: 35.0,
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
            style: const TextStyle(color: Colors.black),
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
        itemExtent: 35.0,
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
                child: Text('Silla ${i + 1}: ' + temp),
              ),
            ),
          );
        },
      ),
    );
  }

  _asignarAutoMesas() async {
    listToAsignarForAdd.clear();
    List<MesasAsignadasModel> _listaMesasAsignadas = [...listaMesasAsignadas];
    if (listaMesaFromDB.isNotEmpty && _listaInvitadoDisponibles.isNotEmpty) {
      for (var invitado in _listaInvitadoDisponibles) {
        final mesaDisponible = listaMesaFromDB.firstWhere((mesa) {
          final listaAsignado = _listaMesasAsignadas
              .where((asignado) => asignado.idMesa == mesa.idMesa);
          if (listaAsignado.length < mesa.dimension) {
            return true;
          } else {
            return false;
          }
        }, orElse: () => null);
        if (mesaDisponible != null) {
          final listaAsignado = _listaMesasAsignadas
              .where((asignado) => asignado.idMesa == mesaDisponible.idMesa);
          for (var i = 1; i <= mesaDisponible.dimension; i++) {
            if (!listaAsignado.any((a) => a.posicion == i)) {
              MesasAsignadasModel mesaAsigandoTemp = MesasAsignadasModel();
              mesaAsigandoTemp.idMesa = mesaDisponible.idMesa;
              mesaAsigandoTemp.idEvento = mesaDisponible.idEvento;
              // * Compruebo que si es acompañante o invitado
              mesaAsigandoTemp.idInvitado = invitado.idInvitado;
              if (invitado.idAcompanante != 0) {
                mesaAsigandoTemp.idAcompanante = invitado.idAcompanante;
              }

              mesaAsigandoTemp.idPlanner =
                  await SharedPreferencesT().getIdPlanner();

              mesaAsigandoTemp.posicion = i;
              listToAsignarForAdd.add(mesaAsigandoTemp);
              _listaMesasAsignadas.add(mesaAsigandoTemp);
              break;
            }
          }
        } else {
          break;
        }
      }
      if (listToAsignarForAdd.isNotEmpty) {
        final data = await mesasAsignadasService
            .asignarPersonasMesas(listToAsignarForAdd);
        if (data == 'Ok') {
          invitadosBloc.add(MostrarInvitadosMesasEvent());
          BlocProvider.of<MesasBloc>(context).add(MostrarMesasEvent());
          BlocProvider.of<MesasAsignadasBloc>(context)
              .add(GetMesasAsignadasEvent());

          mesasAsignadasService.getMesasAsignadas().then((value) {
            setState(() {
              for (var element in listAsigandosToDelete) {
                listPosicionDisponible.remove(element.posicion);
              }
              listToAsignarForAdd.clear();
              listaMesasAsignadas = value;
              checkedsInvitados = [];
            });
          });

          MostrarAlerta(
              mensaje: 'Se agregó correctamente',
              tipoMensaje: TipoMensaje.correcto);
          setState(() {
            listToAsignarForAdd.clear();
          });
        } else {
          MostrarAlerta(mensaje: data, tipoMensaje: TipoMensaje.error);
        }
      }
    } else {
      MostrarAlerta(
          mensaje: 'No se encontraron mesas o invitados',
          tipoMensaje: TipoMensaje.error);
    }
  }

  // * Layout Mesas Page

  Widget layoutMesa() {
    return SingleChildScrollView(
      child: FutureBuilder(
        future: layoutMesaFuture,
        builder:
            (BuildContext context, AsyncSnapshot<LayoutMesaModel> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.file != null) {
              return Stack(
                children: [
                  _viewFile(snapshot.data),
                  Positioned(
                    top: 20.0,
                    right: 10.0,
                    child: Tooltip(
                      message: 'Eliminar',
                      child: IconButton(
                        onPressed: () async {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    title: const Text('Eliminar layout'),
                                    content: const Text(
                                        '¿Desea eliminar el layout?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Cancelar'),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          final resp =
                                              await mesasAsignadasService
                                                  .eliminarLayoutMesa();

                                          if (resp) {
                                            MostrarAlerta(
                                              mensaje: 'Layout eliminado',
                                              tipoMensaje: TipoMensaje.correcto,
                                            );

                                            setState(() {
                                              layoutMesaFuture =
                                                  mesasAsignadasService
                                                      .getLayoutMesa();
                                            });
                                          } else {
                                            MostrarAlerta(
                                                mensaje: 'Ocurrió un error',
                                                tipoMensaje: TipoMensaje.error);
                                          }
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Aceptar'),
                                      ),
                                    ],
                                  ));
                        },
                        icon: const Icon(Icons.delete),
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return Column(
                children: const [
                  SizedBox(
                    height: 20.0,
                  ),
                  Center(child: Text('No se encontraron datos')),
                ],
              );
            }
          } else {
            return Column(
              children: const [
                SizedBox(
                  height: 20.0,
                ),
                Center(child: Text('No se encontraron datos')),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _viewFile(LayoutMesaModel layoutMesa) {
    if (layoutMesa.mime == 'pdf') {
      final bytes = base64Decode(layoutMesa.file);
      return Center(
        child: SizedBox(
          width: 500.0,
          height: MediaQuery.of(context).size.height,
          child: SfPdfViewer.memory(
            bytes,
            controller: _pdfViewerController,
            canShowScrollStatus: true,
            interactionMode: PdfInteractionMode.pan,
          ),
        ),
      );
    } else {
      final bytes = base64Decode(layoutMesa.file);
      final image = MemoryImage(bytes);
      return Center(
        child: SizedBox(
          width: 500.0,
          height: MediaQuery.of(context).size.height,
          child: ClipRect(
            child: PhotoView(
              tightMode: true,
              backgroundDecoration: const BoxDecoration(color: Colors.white),
              imageProvider: image,
            ),
          ),
        ),
      );
    }
  }
}

class EditMesaDialog extends StatefulWidget {
  final MesaModel mesaModel;

  const EditMesaDialog({Key key, @required this.mesaModel}) : super(key: key);

  @override
  _EditMesaDialogState createState() => _EditMesaDialogState();
}

class _EditMesaDialogState extends State<EditMesaDialog> {
  final _keyForm = GlobalKey<FormState>();
  List<Map<String, dynamic>> listTipoDeMesa = [
    {'name': 'Cuadrada', 'value': 1},
    {'name': 'Redonda', 'value': 2},
    {'name': 'Rectangular', 'value': 3},
    {'name': 'Ovalada', 'value': 4},
    {'name': 'Imperial', 'value': 5},
    {'name': 'En forma U', 'value': 6},
  ];
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return AlertDialog(
      title: const Text('Editar datos de la mesa'),
      content: BlocListener<MesasBloc, MesasState>(
        listener: (context, state) {
          if (state is MesasEditedState) {
            if (state.wasEdited) {
              Navigator.of(context).pop();
              MostrarAlerta(
                  mensaje: 'Mesa editada', tipoMensaje: TipoMensaje.correcto);
            } else {
              MostrarAlerta(
                  mensaje: 'Ocurrió un error al intentar editar la mesa',
                  tipoMensaje: TipoMensaje.error);
            }
          }
        },
        child: Form(
          key: _keyForm,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                validator: (value) => (value != null || value != '')
                    ? null
                    : 'El campo es requerido',
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                initialValue: widget.mesaModel.descripcion,
                onChanged: (value) {
                  widget.mesaModel.descripcion = value;
                },
              ),
              const SizedBox(
                height: 8.0,
              ),
              DropdownButtonFormField(
                value: widget.mesaModel.idTipoDeMesa,
                decoration: InputDecoration(
                    constraints: BoxConstraints(maxWidth: size.width * 0.2),
                    prefixIcon: const Icon(Icons.table_chart),
                    hintText: 'Tipo de mesa'),
                items: listTipoDeMesa
                    .map((m) => DropdownMenuItem(
                          child: Text(m['name']),
                          value: m['value'],
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    widget.mesaModel.idTipoDeMesa = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'El tipo de mesa es necesario';
                  } else {
                    return null;
                  }
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancelar')),
        TextButton(
            onPressed: () {
              if (_keyForm.currentState.validate()) {
                BlocProvider.of<MesasBloc>(context)
                    .add(EditMesaEvent(widget.mesaModel));
              } else {
                MostrarAlerta(
                    mensaje: 'Los campos son necesarios',
                    tipoMensaje: TipoMensaje.advertencia);
              }
            },
            child: const Text('Aceptar'))
      ],
    );
  }
}
