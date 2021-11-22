import 'dart:typed_data';
import 'dart:ui';
import 'dart:convert';

import 'package:intl/intl.dart';

// * Comentar cuando se Utilice en movil
import 'package:universal_html/html.dart' as html hide Text;

// * Descomentar en movil
// import 'package:path_provider/path_provider.dart';
// import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:native_pdf_view/native_pdf_view.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
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
import 'package:planning/src/models/invitadosConfirmadosModel/invitado_mesa_Model.dart';

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
  GlobalKey previewContainer = new GlobalKey();

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
  int lastNumMesa;

  @override
  void initState() {
    invitadosBloc = BlocProvider.of<InvitadosMesasBloc>(context);
    mesasAsignadasService.getMesasAsignadas();
    // mesasAsignadasService.getLayoutMesa();
    BlocProvider.of<MesasBloc>(context).add(MostrarMesasEvent());
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
      floatingActionButton: buttonByPage(),
    );
  }

  Widget buttonByPage() {
    switch (indexNavBar) {
      case 0:
        return _buttonAddMesas();
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
    return SpeedDial(
      activeForegroundColor: Colors.blueGrey,
      icon: Icons.add,
      activeIcon: Icons.close,
      activeLabel: Text('Cerrar'),
      animatedIconTheme: IconThemeData(size: 22.0),
      curve: Curves.bounceIn,
      animationSpeed: 200,
      tooltip: 'Ver mas..',
      elevation: 8.0,
      shape: CircleBorder(),
      children: [
        SpeedDialChild(
          child: Icon(Icons.add),
          label: 'Añadir mesa',
          onTap: () {
            Navigator.of(context)
                .pushNamed('/asignarMesas',
                    arguments:
                        (lastNumMesa == null) ? lastNumMesa = 0 : lastNumMesa)
                .then((value) => {
                      lastNumMesa = value,
                    });
          },
        ),
        SpeedDialChild(
          child: Icon(Icons.upload),
          label: 'Subir archivo',
          onTap: () async {
            const extensiones = ['jpg', 'png', 'jpeg', 'pdf'];

            FilePickerResult pickedFile = await FilePicker.platform.pickFiles(
              type: FileType.custom,
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
                        setState(() {
                          mesasAsignadasService.getLayoutMesa();
                        }),
                        _mostrarMensaje(
                            'Se subio correctamente el layout', Colors.green)
                      }
                    else
                      {_mostrarMensaje(value, Colors.red)}
                  });
            } else {}
          },
        ),
      ],
    );
  }

  Widget _expandableButtonOptions() {
    return SpeedDial(
      activeForegroundColor: Colors.blueGrey,
      icon: Icons.add,
      activeIcon: Icons.close,
      activeLabel: Text('Cerrar'),
      animatedIconTheme: IconThemeData(size: 22.0),
      curve: Curves.bounceIn,
      animationSpeed: 200,
      tooltip: 'Ver mas..',
      elevation: 8.0,
      shape: CircleBorder(),
      children: [
        SpeedDialChild(
          child: Icon(Icons.add),
          label: 'Añadir mesa',
          onTap: () {
            Navigator.of(context)
                .pushNamed('/asignarMesas',
                    arguments:
                        (lastNumMesa == null) ? lastNumMesa = 0 : lastNumMesa)
                .then((value) => {
                      lastNumMesa = value,
                    });
          },
        ),
        SpeedDialChild(
          child: Icon(Icons.download),
          label: 'Descargar PDF',
          onTap: () async {
            if (listaMesaFromDB != null && listaMesaFromDB.isNotEmpty) {
              // * Descargar PDF
              await _createPdfToMesa();
            } else {
              _mostrarMensaje('No se encontraron datos', Colors.red);
            }
          },
        ),
      ],
    );
  }

  Widget _buttonAddMesas() {
    return FloatingActionButton(
      tooltip: 'Agregar mesa',
      child: Icon(Icons.add),
      onPressed: () {
        Navigator.of(context)
            .pushNamed('/asignarMesas',
                arguments:
                    (lastNumMesa == null) ? lastNumMesa = 0 : lastNumMesa)
            .then((value) => {
                  lastNumMesa = value,
                });
      },
    );
  }

  BottomNavigationBar _bottomNavigatorBarCustom() {
    return BottomNavigationBar(
      currentIndex: indexNavBar,
      items: [
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
    Widget WidgetBlocMesas = BlocBuilder<MesasBloc, MesasState>(
      builder: (context, state) {
        if (state is LoadingMesasState) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is MostrarMesasState) {
          if (state.listaMesas.isNotEmpty && state.listaMesas != null) {
            lastNumMesa = state.listaMesas.last.numDeMesa;
            listaMesaFromDB = state.listaMesas;
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
      key: previewContainer,
      itemCount: listaMesa.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.5,
      ),
      itemBuilder: (BuildContext context, int index) {
        editTitleMesa.add(false);
        String nameCurrentMesa;
        int idCurrentMesa;
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
                    Center(
                      child: ListTile(
                        trailing: IconButton(
                          onPressed: () async {
                            setState(() {
                              editTitleMesa[index]
                                  ? editTitleMesa[index] = false
                                  : editTitleMesa[index] = true;

                              if (!editTitleMesa[index]) {
                                idCurrentMesa = listaMesa[index].idMesa;
                                if (nameCurrentMesa == null ||
                                    nameCurrentMesa == '') {
                                  nameCurrentMesa =
                                      listaMesa[index].descripcion;
                                }
                                ;
                                mesasLogic
                                    .updateMesa(nameCurrentMesa, idCurrentMesa)
                                    .then((value) {
                                  if (value == 'Ok') {
                                    BlocProvider.of<MesasBloc>(context)
                                        .add(MostrarMesasEvent());
                                    _mostrarMensaje(
                                        'La mesa se edito correctamente',
                                        Colors.green);
                                  } else {
                                    _mostrarMensaje(value, Colors.red);
                                  }
                                });
                              }
                            });
                          },
                          icon: Icon(
                              !editTitleMesa[index] ? Icons.edit : Icons.save),
                        ),
                        title: TextFormField(
                          enabled: editTitleMesa[index],
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                          initialValue: listaMesa[index].descripcion,
                          onChanged: (value) {
                            nameCurrentMesa = value;
                          },
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        subtitle: Text(listaMesa[index].tipoMesa),
                      ),
                    ),
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
                              decoration:
                                  InputDecoration(labelText: 'Silla ${i + 1}'),
                              initialValue: temp,
                            );
                          }),
                    )
                  ],
                ),
              )),
        );
      },
    );
    return gridOfListaMesas;
  }

  Future<void> _createPdfToMesa() async {
    final logo = await mesasAsignadasService.getLogoPlanner();

    final pdf = pw.Document();
    List<pw.Widget> listaGridChild = [];
    List<pw.Widget> listaView = [];

    for (int index = 0; index < listaMesaFromDB.length; index++) {
      listaView = [];
      final listaAsignados = listaMesasAsignadas
          .where((m) => m.idMesa == listaMesaFromDB[index].idMesa)
          .toList();
      for (var i = 0; i < listaAsignados.length; i++) {
        String temp = '';
        final asigando = listaAsignados[i];
        asigando.idAcompanante != 0
            ? temp = asigando.acompanante
            : temp = asigando.invitado;

        pw.Widget listViewChild = pw.Align(
          alignment: pw.Alignment.topLeft,
          child: pw.Text(
            temp,
            style: pw.TextStyle(
              fontSize: 10.0,
            ),
          ),
        );

        listaView.add(listViewChild);
      }

      pw.Widget gridChild = (pw.Container(
        margin: const pw.EdgeInsets.only(bottom: 6.0),
        decoration: pw.BoxDecoration(boxShadow: [
          pw.BoxShadow(
            color: PdfColors.grey,
            offset: PdfPoint(0.0, 0.1),
            spreadRadius: 5.0, //(x,y)
            blurRadius: 6.0,
          ),
        ], border: pw.Border.all()),
        padding: pw.EdgeInsets.all(8.0),
        child: pw.Column(
          children: [
            pw.Center(
              child: pw.Text(
                listaMesaFromDB[index].descripcion,
                style: pw.TextStyle(fontSize: 10),
              ),
            ),
            pw.Center(
              child: pw.Text(
                listaMesaFromDB[index].tipoMesa,
                style: pw.TextStyle(fontSize: 10),
              ),
            ),
            pw.SizedBox(
              height: 10.0,
            ),
            for (var item in listaView) item
          ],
        ),
      ));
      listaGridChild.add(gridChild);
    }
    var imageWidget;
    if (logo != null) {
      Uint8List image = base64Decode(logo);
      imageWidget = pw.MemoryImage(image);
    }

    var now = DateTime.now();

    String fecha = DateFormat.yMMMd().format(now);

    pdf.addPage(
      pw.MultiPage(
        build: (pw.Context context) => [
          pw.Row(children: [
            if (logo != null)
              pw.ConstrainedBox(
                constraints: pw.BoxConstraints(maxWidth: 50.0, minWidth: 40.0),
                child: pw.Image(imageWidget),
              ),
            pw.Spacer(),
            pw.Center(
              child: pw.Text('Evento: ${widget.nameEvento}',
                  style: pw.Theme.of(context).header4),
            ),
            pw.Spacer(),
            pw.Text(fecha)
          ]),
          pw.SizedBox(height: 15.0),
          pw.GridView(
            crossAxisCount: 3,
            childAspectRatio: 1.0,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
            direction: pw.Axis.vertical,
            children: listaGridChild,
          )
        ],
      ),
    );

    String titulotemp = widget.nameEvento;

    final titulo = titulotemp.replaceAll(" ", "_");

    final date = DateTime.now();

    final bytes = await pdf.save();
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);

    final anchor = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = 'Evento :$titulo-$date.pdf';
    html.document.body.children.add(anchor);
    anchor.click();
    html.document.body.children.remove(anchor);
    html.Url.revokeObjectUrl(url);

    // * For Mobile
    // final output = await getTemporaryDirectory();
    // final file = File("${output.path}/$titulo.pdf");
    // await file.writeAsBytes(await pdf.save());
  }

  Widget asignarInvitadosMesasPage() {
    setState(() {});

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
    return Column(
      children: [
        SizedBox(
          height: 15.0,
        ),
        Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          child: BlocBuilder<InvitadosMesasBloc, InvitadosMesasState>(
            builder: (context, state) {
              if (state is LoadingInvitadoMesasState) {
                return Align(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(),
                );
              } else if (state is MostraListaInvitadosMesaState) {
                state.listaInvitadoMesa.length > 0
                    ? _enable = true
                    : _enable = false;
                if (state.listaInvitadoMesa.isNotEmpty ||
                    state.listaInvitadoMesa != null) {
                  _listaInvitadoDisponibles = state.listaInvitadoMesa;
//
                  return Expanded(
                      child: buildListInvitadosConfirmador(
                          state.listaInvitadoMesa));
                } else {
                  return Text('No se encontraron datos');
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
          ),
        ),
        SizedBox(
          height: 8.0,
        ),
        Row(
          children: [
            ElevatedButton(
              onPressed: asignarMesas,
              child: Icon(Icons.arrow_downward),
            ),
            SizedBox(
              width: 5.0,
            ),
            ElevatedButton(
              onPressed: _deleteAsignadoToMesa,
              child: Icon(Icons.arrow_upward),
            ),
            Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 5.0,
              ),
              onPressed: _asignarAutoMesas,
              child: Text('Asignar auto.'),
            ),
            SizedBox(
              width: 8.0,
            )
          ],
        ),
        SizedBox(
          height: 8.0,
        ),
        Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          child: BlocBuilder<MesasBloc, MesasState>(
            builder: (context, state) {
              if (state is LoadingMesasState) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is MostrarMesasState) {
                if (state.listaMesas != null) {
                  lastNumMesa = state.listaMesas.last.numDeMesa;
                  listaMesaFromDB = state.listaMesas;

                  if (state.listaMesas.length > 0) {
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
                return Container();
              }
            },
          ),
        ),
        if (mesaModelData != null) Divider(),
        if (mesaModelData != null)
          SizedBox(
            height: 10.0,
          ),
        if (mesaModelData != null) Expanded(child: formTableByMesa())
      ],
    );
  }

  Widget buildAsignarMesaDesktop() {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Padding(
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
                        state.listaInvitadoMesa.length > 0
                            ? _enable = true
                            : _enable = false;
                        if (state.listaInvitadoMesa.isNotEmpty ||
                            state.listaInvitadoMesa != null) {
                          _listaInvitadoDisponibles = state.listaInvitadoMesa;

                          return Expanded(
                              child: buildListInvitadosConfirmador(
                                  state.listaInvitadoMesa));
                        } else {
                          return Text('No se encontraron datos');
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
                  child: Icon(Icons.arrow_back),
                ),
                Spacer(),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 5.0,
                  ),
                  onPressed: _asignarAutoMesas,
                  child: Text('Asignar auto.'),
                ),
                SizedBox(
                  height: 20.0,
                )
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
                          if (state.listaMesas != null) {
                            lastNumMesa = state.listaMesas.last.numDeMesa;
                            listaMesaFromDB = state.listaMesas;

                            if (state.listaMesas.length > 0) {
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
                          return Container();
                        }
                      },
                    ),
                    if (mesaModelData != null) Divider(),
                    if (mesaModelData != null)
                      SizedBox(
                        height: 10.0,
                      ),
                    if (mesaModelData != null)
                      Expanded(child: formTableByMesa())
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _deleteAsignadoToMesa() async {
    if (mesaModelData != null) {
      if (listAsigandosToDelete.isEmpty) {
        _mostrarMensaje(
          'Seleccione alguna opcion de la lista',
          Colors.red,
        );
      } else {
        final data = await mesasAsignadasService
            .deleteAsignadoFromMesa(listAsigandosToDelete);
        if (data == 'Ok') {
          _mostrarMensaje('Se agrego correctamente', Colors.green);
          await invitadosBloc.add(MostrarInvitadosMesasEvent());

          await BlocProvider.of<MesasBloc>(context).add(MostrarMesasEvent());

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
          _mostrarMensaje('Ocurrio un error', Colors.red);
        }
      }
    } else {
      _mostrarMensaje('Seleccione un mesa', Colors.red);
    }
  }

  asignarMesas() async {
    List<int> listTemp = [];
    if (listaMesasAsignadas.length > 0 && mesaModelData != null) {
      final datosMesaAsginada = listaMesasAsignadas
          .where((mesaAsignada) => mesaAsignada.idMesa == mesaModelData.idMesa);
      datosMesaAsginada.forEach((element) {
        listPosicionDisponible.remove(element.posicion);
      });

      if (datosMesaAsginada.length > 0) {
        datosMesaAsginada.forEach((asignado) {
          listTemp.add(asignado.posicion);
        });
      }
    }

    if (mesaModelData == null || listToAsignarForAdd.isEmpty) {
      _mostrarMensaje(
          'Seleccione la mesa y los invitados ha asignar', Colors.red);
    } else {
      if (listToAsignarForAdd.length >
          (mesaModelData.dimension - listTemp.length)) {
        _mostrarMensaje(
            'El número de invitados es mayor al numero de sillas disponibles',
            Colors.red);
      } else {
        for (var i = 0; i < listToAsignarForAdd.length; i++) {
          listToAsignarForAdd[i].posicion = listPosicionDisponible[i];
        }

        listPosicionDisponible.forEach((element) {});

        listToAsignarForAdd.forEach((asignado) {});

        final data = await mesasAsignadasService
            .asignarPersonasMesas(listToAsignarForAdd);
        mesaModelData.dimension;
        if (data == 'Ok') {
          await invitadosBloc.add(MostrarInvitadosMesasEvent());

          mesasAsignadasService.getMesasAsignadas().then((value) {
            setState(() {
              listAsigandosToDelete.forEach((element) {
                listPosicionDisponible.remove(element.posicion);
              });
              listToAsignarForAdd.clear();
              listaMesasAsignadas = value;
              checkedsInvitados = [];
            });
          });

          _mostrarMensaje('Se agrego correctamente', Colors.green);
          setState(() {
            listToAsignarForAdd.clear();
          });
        } else {
          _mostrarMensaje(data, Colors.red);
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

  _asignarAutoMesas() async {
    listToAsignarForAdd.clear();
    List<MesasAsignadasModel> _listaMesasAsignadas = [...listaMesasAsignadas];
    if (listaMesaFromDB.isNotEmpty && _listaInvitadoDisponibles.isNotEmpty) {
      for (var invitado in _listaInvitadoDisponibles) {
        final mesaDisponible = listaMesaFromDB.firstWhere((mesa) {
          final listaAsignado = _listaMesasAsignadas
              .where((asignado) => asignado.idMesa == mesa.idMesa);
          if (listaAsignado.length < mesa.dimension)
            return true;
          else
            return false;
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
      if (listToAsignarForAdd.isNotEmpty && listToAsignarForAdd.length > 0) {
        final data = await mesasAsignadasService
            .asignarPersonasMesas(listToAsignarForAdd);
        if (data == 'Ok') {
          await invitadosBloc.add(MostrarInvitadosMesasEvent());

          mesasAsignadasService.getMesasAsignadas().then((value) {
            setState(() {
              listAsigandosToDelete.forEach((element) {
                listPosicionDisponible.remove(element.posicion);
              });
              listToAsignarForAdd.clear();
              listaMesasAsignadas = value;
              checkedsInvitados = [];
            });
          });

          _mostrarMensaje('Se agrego correctamente', Colors.green);
          setState(() {
            listToAsignarForAdd.clear();
          });
        } else {
          _mostrarMensaje(data, Colors.red);
        }
      }
    }
  }

  // * Layout Mesas Page

  Widget layoutMesa() {
    return SingleChildScrollView(
      child: Column(
        children: [
          FutureBuilder(
            future: mesasAsignadasService.getLayoutMesa(),
            builder: (BuildContext context,
                AsyncSnapshot<LayoutMesaModel> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.file != null) {
                  return _viewFile(snapshot.data);
                } else {
                  return Align(
                    alignment: Alignment.center,
                    child: Center(
                      child: Text('No se encontraron datos'),
                    ),
                  );
                }
              } else {
                return Align(
                  alignment: Alignment.center,
                  child: Center(
                    child: Text('No se encontraron datos'),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _viewFile(LayoutMesaModel layoutMesa) {
    if (layoutMesa.mime == 'pdf') {
      final bytes = base64Decode(layoutMesa.file);
      return Center(
        child: Container(
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
        child: Container(
          width: 500.0,
          height: MediaQuery.of(context).size.height,
          child: ClipRect(
            child: PhotoView(
              tightMode: true,
              backgroundDecoration: BoxDecoration(color: Colors.white),
              imageProvider: image,
            ),
          ),
        ),
      );
    }
  }

  _mostrarMensaje(String msj, Color color) {
    SnackBar snackBar = SnackBar(
      content: Text(msj),
      backgroundColor: color,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
