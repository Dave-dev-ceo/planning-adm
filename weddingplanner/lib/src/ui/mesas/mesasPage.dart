import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:native_pdf_view/native_pdf_view.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:screenshot/screenshot.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:weddingplanner/src/blocs/Mesas/mesas_bloc.dart';
import 'package:weddingplanner/src/blocs/invitadosMesa/invitadosmesas_bloc.dart';
import 'package:weddingplanner/src/logic/mesas_asignadas_logic/mesas_asignadas_services.dart';
import 'package:weddingplanner/src/models/MesasAsignadas/mesas_asignadas_model.dart';
import 'package:weddingplanner/src/models/invitadosConfirmadosModel/invitado_mesa_Model.dart';
import 'package:weddingplanner/src/models/mesa/mesas_model.dart';
import 'package:weddingplanner/src/ui/widgets/expandable_fab/expandable_fab_widget.dart';

class MesasPage extends StatefulWidget {
  @override
  State<MesasPage> createState() => _MesasPageState();
}

class _MesasPageState extends State<MesasPage> {
  // * Instacia del Screenshot Controller
  ScreenshotController _screenshotController = ScreenshotController();

  // * Se crea la variable donde se guardara
  Uint8List capturedImage;

  GlobalKey previewContainer = new GlobalKey();

  Image _imageScreen;

  final mesasAsignadasService = MesasAsignadasService();
  final asignarMesasService = MesasAsignadasService();
  InvitadosMesasBloc invitadosBloc;
  List<MesasAsignadasModel> listaMesasAsignadas = [];
  List<MesasAsignadasModel> listAsigandosToDelete = [];
  List<MesasAsignadasModel> listToAsignarForAdd = [];
  List<bool> checkedsInvitados = [];
  List<bool> checkedsAsignados = [];
  List<int> listPosicionDisponible = [];
  List<MesaModel> listaMesaFromDB = [];
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
          builder:
              (context, AsyncSnapshot<List<MesasAsignadasModel>> snapshot) {
            if (snapshot.hasData) {
              listaMesasAsignadas = snapshot.data;
              return listWidget[indexNavBar];
            } else {
              listaMesasAsignadas = [];
              return listWidget[indexNavBar];
            }
          },
        ),
        floatingActionButton:
            indexNavBar == 0 ? _expandableButtonOptions() : _buttonAddMesas());
  }

  Widget _expandableButtonOptions() {
    return ExpandableFab(
      distance: 100.0,
      initialOpen: false,
      children: [
        _buttonAddMesas(),
        ActionButton(
          icon: Icon(Icons.download),
          onPressed: () async {
            if (listaMesaFromDB != null && listaMesaFromDB.isNotEmpty) {
              final file = await _createPdfToMesa();
              _showDialogPdf(file);
            }
          },
        )
      ],
    );
  }

  FloatingActionButton _buttonAddMesas() {
    return FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context)
              .pushNamed('/asignarMesas',
                  arguments:
                      (lastNumMesa == null) ? lastNumMesa = 0 : lastNumMesa)
              .then((value) => {
                    lastNumMesa = value,
                  });
        });
  }

  Future<Uint8List> _createPdfToMesa() async {
    final pdf = pw.Document();
    List<pw.Widget> listaGridChild = [];
    List<pw.Widget> listaView = [];
    List<pw.Widget> childrenRow = [];

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

        pw.Widget listViewChild =
            pw.Text(temp, style: pw.TextStyle(fontSize: 10.0));

        listaView.add(listViewChild);
      }

      pw.Widget gridChild = pw.Container(
        decoration: pw.BoxDecoration(boxShadow: [], border: pw.Border.all()),
        padding: pw.EdgeInsets.all(8.0),
        child: pw.Column(
          children: [
            pw.Center(
              child: pw.Text(
                listaMesaFromDB[index].descripcion,
                style: pw.TextStyle(fontSize: 10),
              ),
            ),
            pw.SizedBox(
              height: 10.0,
            ),
            for (var item in listaView) item
          ],
        ),
      );
      listaGridChild.add(gridChild);
    }
    pdf.addPage(
      pw.MultiPage(
        build: (pw.Context context) => [
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

    return await pdf.save();
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
                          onPressed: () {},
                          icon: Icon(Icons.edit),
                        ),
                        title: TextFormField(
                          enabled: false,
                          decoration: InputDecoration(border: InputBorder.none),
                          initialValue: listaMesa[index].descripcion,
                          onChanged: (value) {},
                        ),
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

  // ? Page Asignar Mesas a Invitados

  _mostraMensaje(String msj, Color color) {
    SnackBar snackBar = SnackBar(
      content: Text(msj),
      backgroundColor: color,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Widget asignarInvitadosMesasPage() {
    setState(() {});
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
                child: Icon(Icons.arrow_back),
              ),
              Spacer(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 5.0,
                ),
                onPressed: _asignarAutoMesas,
                child: Text('Asignar Auto.'),
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
                        if (state.listaMesas != null ||
                            state.listaMesas.isNotEmpty) {
                          listaMesaFromDB = state.listaMesas;
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
          _mostraMensaje('Ocurrio un error', Colors.red);
        }
      }
    } else {
      _mostraMensaje('Seleccione un mesa', Colors.red);
    }
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

      if (datosMesaAsginada.length > 0) {
        lastPosicion = datosMesaAsginada.last.posicion;
        datosMesaAsginada.forEach((asignado) {
          listTemp.add(asignado.posicion);
        });
      }
    }

    if (mesaModelData == null || listToAsignarForAdd.isEmpty) {
      _mostraMensaje(
          'Seleccione la mesa y los invitados a asignar', Colors.red);
    } else {
      if (listToAsignarForAdd.length >
          (mesaModelData.dimension - listTemp.length)) {
        _mostraMensaje(
            'El número de invitados es mayor al numero de sillas dsiponibles',
            Colors.red);
      } else {
        for (var i = 0; i < listToAsignarForAdd.length; i++) {
          listToAsignarForAdd[i].posicion = listPosicionDisponible[i];
        }

        listPosicionDisponible.forEach((element) {});

        listToAsignarForAdd.forEach((asignado) {});

        final data =
            await asignarMesasService.asignarPersonasMesas(listToAsignarForAdd);
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

          _mostraMensaje('Se agrego correctamente', Colors.green);
          setState(() {
            listToAsignarForAdd.clear();
          });
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
    print('Asigando automatico los datos ');
  }

  Future<Image> takeScreenShot() async {
    RenderRepaintBoundary boundary =
        previewContainer.currentContext.findRenderObject();
    var image = await boundary.toImage();
    ByteData bydata = await image.toByteData(format: ImageByteFormat.png);
    Uint8List pngImage = bydata.buffer.asUint8List();
    _imageScreen = Image.memory(pngImage.buffer.asUint8List());
    return _imageScreen;
  }

  _showDialogPdf(Uint8List fileToView) {
    return showDialog(
      context: context,
      builder: (context) => Scaffold(
        appBar: AppBar(),
        body: SfPdfViewer.memory(
          fileToView,
          pageLayoutMode: PdfPageLayoutMode.continuous,
          pageSpacing: 10.0,
          canShowPaginationDialog: true,
        ),
      ),
    );
  }
}
