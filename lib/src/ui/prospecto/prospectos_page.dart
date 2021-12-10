import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planning/src/blocs/prospecto/prospecto_bloc.dart';
import 'package:planning/src/models/prospectosModel/prospecto_model.dart';

class ProspectosPage extends StatefulWidget {
  @override
  _ProspectosPageState createState() => _ProspectosPageState();
}

class _ProspectosPageState extends State<ProspectosPage> {
  ProspectoBloc _prospectoBloc;
  List<EtapasModel> etapas = [];
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _prospectoBloc = BlocProvider.of<ProspectoBloc>(context);
    _prospectoBloc.add(MostrarEtapasEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<ProspectoBloc, ProspectoState>(
        listener: (context, state) {
          if (state is AddedEtapaState) {
            if (state.wasAdded) {
              _showSnackBar(
                  'Se añadio correctamente un nueva etapa', Colors.green);
            } else {
              _showSnackBar('Ocurrio un error', Colors.red);
            }
          }
        },
        child: BlocBuilder<ProspectoBloc, ProspectoState>(
          builder: (context, state) {
            if (state is MostrarEtapasState) {
              etapas = state.etapas;
              return Padding(
                padding: EdgeInsets.all(15.0),
                child: buildEtapas(),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Añadir Etapa',
        child: Icon(Icons.add),
        onPressed: _addEtapaSubmit,
      ),
    );
  }

  Widget buildEtapas() {
    return Scrollbar(
      controller: _scrollController,
      isAlwaysShown: true,
      child: DragAndDropLists(
        contentsWhenEmpty: Text('Sin datos'),
        scrollController: _scrollController,
        listWidth: 300,
        listDraggingWidth: 200,
        listDecoration: BoxDecoration(
          color: Color(0xFFEBECF0),
          borderRadius: BorderRadius.all(Radius.circular(7.0)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black45,
              spreadRadius: 2.0,
              blurRadius: 4.0,
              offset: Offset(2, 3),
            ),
          ],
        ),
        listPadding: EdgeInsets.all(8.0),
        axis: Axis.horizontal,
        onItemReorder: _onItemReorder,
        onListReorder: _onListReorder,
        children: etapas.map((etapa) => _buildList(etapa)).toList(),
      ),
    );
  }

  DragAndDropList _buildList(EtapasModel etapa) {
    final keyForm = GlobalKey<FormState>();
    ProspectoModel newProspecto = ProspectoModel(
      idEtapa: etapa.idEtapa,
      descripcion: '',
    );
    return DragAndDropList(
      header: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(7.0)),
                color: Color(0xFFEBECF0),
              ),
              padding: EdgeInsets.all(10),
              child: (etapa.claveEtapa == null)
                  ? GestureDetector(
                      onTap: () {
                        setState(() {
                          etapa.isEditNombreEtapa = true;
                        });
                      },
                      child: ListTile(
                        title: TextFormField(
                          style: TextStyle(fontSize: 20.0),
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.blue, width: 1.0),
                            ),
                            border: InputBorder.none,
                          ),
                          enabled: etapa.isEditNombreEtapa,
                          initialValue: etapa.nombreEtapa,
                          onChanged: (value) => {etapa.nombreEtapa = value},
                          onFieldSubmitted: (value) => {
                            if (value.length >= 1)
                              {
                                _prospectoBloc.add(EditNameEtapaEvent(etapa)),
                                setState(() {
                                  etapa.isEditNombreEtapa = false;
                                })
                              }
                          },
                        ),
                        trailing: PopupMenuButton(
                            onSelected: (value) {
                              if (value == 1) {
                                _prospectoBloc
                                    .add(DeleteEtapaEvent(etapa.idEtapa));
                              }
                            },
                            tooltip: null,
                            itemBuilder: (BuildContext context) =>
                                <PopupMenuItem>[
                                  const PopupMenuItem(
                                    child: Text('Eliminar'),
                                    value: 1,
                                  ),
                                ]),
                      ),
                    )
                  : ListTile(
                      title: Text(
                        etapa.nombreEtapa,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ),
            ),
          ),
        ],
      ),
      footer: (!etapa.isAdd)
          ? ListTile(
              title: Text('Añadir prospecto'),
              leading: Icon(Icons.add),
              hoverColor: Colors.white,
              onTap: () {
                setState(() {
                  etapa.isAdd = true;
                });
              },
            )
          : Card(
              margin: EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Form(
                    key: keyForm,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Nombre del prospecto',
                            labelText: 'Nombrel del prospecto'),
                        validator: (value) {
                          if (value != null || value != '') {
                            return null;
                          } else {
                            return 'El nombre del predecesor es requerido';
                          }
                        },
                        onChanged: (value) {
                          newProspecto.nombreProspecto = value;
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 12.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                            onPressed: () async {
                              if (keyForm.currentState.validate()) {
                                await _prospectoBloc
                                    .add(AddProspectoEvent(newProspecto));
                              }
                            },
                            child: Text('Añadir prospecto')),
                        IconButton(
                          tooltip: 'Cancelar',
                          hoverColor: Colors.transparent,
                          onPressed: () {
                            setState(() {
                              etapa.isAdd = false;
                            });
                          },
                          icon: Icon(Icons.close),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
      leftSide: VerticalDivider(
        color: Color(0xFFEBECF0),
        width: 1.5,
        thickness: 1.5,
      ),
      rightSide: VerticalDivider(
        color: Color(0xFFEBECF0),
        width: 1.5,
        thickness: 1.5,
      ),
      contentsWhenEmpty: Text('Sin datos'),
      children:
          etapa.prospectos.map((prospecto) => _buildItem(prospecto)).toList(),
    );
  }

  DragAndDropItem _buildItem(ProspectoModel prospecto) {
    return DragAndDropItem(
      child: Card(
        child: ListTile(
          title: Text(prospecto.nombreProspecto),
          onTap: () => _openDetailProspecto(prospecto),
        ),
      ),
    );
  }

  void _showSnackBar(String content, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(content),
      backgroundColor: color,
      duration: Duration(seconds: 2),
    ));
  }

  void _openDetailProspecto(ProspectoModel prospecto) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => DetailProspectoDialog(
        prospecto: prospecto,
      ),
    );
  }

  void _addEtapaSubmit() {
    final _keyFormNewEtapa = GlobalKey<FormState>();
    EtapasModel newEtapa = EtapasModel(
      nombreEtapa: '',
      ordenEtapa: etapas.length + 1,
    );
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          final size = MediaQuery.of(context).size;
          return BlocListener<ProspectoBloc, ProspectoState>(
            listener: (context, state) {
              if (state is AddedEtapaState) {
                if (state.wasAdded) {
                  _showSnackBar(
                      'Se añadio correctamente la etapa', Colors.green);
                  Navigator.of(context).pop();
                } else {
                  _showSnackBar('Ocurrio un erro', Colors.red);
                }
              }
            },
            child: AlertDialog(
              title: Text('Insertar etapa'),
              content: SizedBox(
                width: size.width * 0.3,
                height: size.height * 0.5,
                child: Form(
                  key: _keyFormNewEtapa,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Agregar etapa',
                            labelText: 'Agregar etapa',
                          ),
                          onChanged: (value) {
                            newEtapa.nombreEtapa = value;
                          },
                          validator: (value) {
                            if (value != null && value != '') {
                              return null;
                            } else {
                              return 'El nombre del etapa es necesario';
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Descripción de la etapa',
                            labelText: 'Descripción de la etapa',
                          ),
                          onChanged: (value) {
                            newEtapa.descripcionEtapa = value;
                          },
                        ),
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
                  child: Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () {
                    if (_keyFormNewEtapa.currentState.validate()) {
                      _prospectoBloc.add(AddEtapaEvent(newEtapa));
                    }
                  },
                  child: Text('Aceptar'),
                )
              ],
            ),
          );
        });
  }

  _onItemReorder(
      int oldItemIndex, int oldListIndex, int newItemIndex, int newListIndex) {
    setState(() {
      _prospectoBloc.add(
        UpdateEtapaProspectoEvent(
            idEtapa: etapas[newListIndex].idEtapa,
            idProspecto:
                etapas[oldListIndex].prospectos[oldItemIndex].idProspecto),
      );
      ProspectoModel movedItem =
          etapas[oldListIndex].prospectos.removeAt(oldItemIndex);
      etapas[newListIndex].prospectos.insert(newItemIndex, movedItem);
    });
  }

  _onListReorder(int oldListIndex, int newListIndex) {
    List<UpdateEtapaModel> etapasToUpdate = [];
    setState(() {
      EtapasModel movedList = etapas.removeAt(oldListIndex);
      etapas.insert(newListIndex, movedList);

      for (var i = 0; i < etapas.length; i++) {
        etapas[i].ordenEtapa = i + 1;
        etapasToUpdate.add(UpdateEtapaModel(
          idEtapa: etapas[i].idEtapa,
          ordenEtapa: etapas[i].ordenEtapa,
        ));
      }
      _prospectoBloc.add(UpdateEtapaEvent(listEtapasUpdate: etapasToUpdate));
    });
  }
}

class DetailProspectoDialog extends StatefulWidget {
  final ProspectoModel prospecto;

  const DetailProspectoDialog({Key key, @required this.prospecto})
      : super(key: key);

  @override
  _DetailProspectoDialogState createState() => _DetailProspectoDialogState();
}

class _DetailProspectoDialogState extends State<DetailProspectoDialog> {
  ProspectoBloc _prospectoBloc;

  bool canEditName = false;
  bool canEditPhone = false;
  bool canEditEmail = false;

  bool isFocusDescripcion = false;
  bool isEditDescripcion = false;

  @override
  void initState() {
    _prospectoBloc = BlocProvider.of<ProspectoBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Dialog(
      child: SingleChildScrollView(
        child: Container(
          height: size.height * 0.8,
          width: size.width * 0.6,
          margin: EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    Spacer(),
                    AutoSizeText(
                      'Datos del predecesor',
                      maxFontSize: 15.0,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(Icons.close),
                    )
                  ],
                ),
                namePredecesorWidget(),
                phonePredecesorWidget(),
                emailPredecesorWidget(),
                descripcionPredecesorWidget(),
                actividadesWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget emailPredecesorWidget() {
    final _keyFormEmail = GlobalKey<FormState>();

    return Form(
      key: _keyFormEmail,
      child: ListTile(
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        selectedTileColor: Colors.transparent,
        onTap: () => setState(
          () {
            canEditEmail = true;
          },
        ),
        leading: Icon(
          Icons.email_outlined,
          color: Colors.black,
        ),
        title: Text('Correo'),
        subtitle: TextFormField(
          validator: (value) {
            RegExp regExpEmail = RegExp(
                r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

            if (regExpEmail.hasMatch(value)) {
              return null;
            } else {
              return 'Ingrese un correo eléctronico valido';
            }
          },
          decoration: InputDecoration(
            hintText: 'Añadir correo eléctronico...',
            helperText: 'correo@dominio.com',
            disabledBorder: InputBorder.none,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue, width: 1.0),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 1.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue, width: 1.0),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 1.0),
            ),
            border: InputBorder.none,
          ),
          enabled: canEditEmail,
          initialValue: (widget.prospecto.correo != null)
              ? widget.prospecto.correo
              : null,
          onChanged: (value) => {widget.prospecto.correo = value},
          onFieldSubmitted: (value) => {
            if (_keyFormEmail.currentState.validate())
              {
                _prospectoBloc.add(UpdateCorreoProspecto(widget.prospecto)),
                setState(() {
                  canEditEmail = false;
                })
              }
          },
        ),
      ),
    );
  }

  Widget phonePredecesorWidget() {
    final _keyPhoneForm = GlobalKey<FormState>();
    return Form(
      key: _keyPhoneForm,
      child: ListTile(
        focusColor: Colors.transparent,
        selectedTileColor: Colors.transparent,
        hoverColor: Colors.transparent,
        onLongPress: null,
        onTap: () {
          setState(() {
            canEditPhone = true;
          });
        },
        leading: Icon(
          Icons.phone,
          color: Colors.black,
        ),
        title: Text('Teléfono'),
        subtitle: TextFormField(
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            hintText: 'Añadir teléfono',
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue, width: 1.0),
            ),
            border: InputBorder.none,
          ),
          validator: (value) {
            if (value.length < 11 && value.length > 0) {
              return null;
            } else {
              return 'El número debe tener 10 digitos';
            }
          },
          enabled: canEditPhone,
          initialValue: (widget.prospecto.telefono != null)
              ? widget.prospecto.telefono.toString()
              : null,
          onChanged: (value) => {widget.prospecto.telefono = int.parse(value)},
          onFieldSubmitted: (value) => {
            if (_keyPhoneForm.currentState.validate())
              {
                _prospectoBloc.add(UpdateTelefonoProspecto(widget.prospecto)),
                setState(() {
                  canEditPhone = false;
                })
              }
          },
        ),
      ),
    );
  }

  ListTile descripcionPredecesorWidget() {
    return ListTile(
      leading: Icon(
        Icons.description_outlined,
        color: Color(0xFF172C4C),
      ),
      title: Text('Descripcion'),
      subtitle: (widget.prospecto.descripcion != null)
          ? !isEditDescripcion
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    child: Text(widget.prospecto.descripcion),
                    onTap: () {
                      setState(() {
                        isEditDescripcion = true;
                      });
                    },
                  ),
                )
              : textAreaWidgetEdit()
          : textAreaWidgetEdit(),
    );
  }

  ListTile namePredecesorWidget() {
    return ListTile(
      leading: Icon(Icons.article_outlined, color: Color(0xFF172C4C)),
      title: TextFormField(
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16.0,
        ),
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 1.0),
          ),
          border: InputBorder.none,
        ),
        readOnly: !canEditName,
        initialValue: widget.prospecto.nombreProspecto,
        onChanged: (value) => {widget.prospecto.nombreProspecto = value},
        onTap: () => setState(
          () {
            canEditName = true;
          },
        ),
        onFieldSubmitted: (value) => {
          setState(() {
            _prospectoBloc.add(UpdateNameProspecto(widget.prospecto));
            canEditName = false;
          })
        },
      ),
    );
  }

  ListTile actividadesWidget() {
    TextEditingController textEditingController = TextEditingController();
    return ListTile(
      minVerticalPadding: 10.0,
      leading: Icon(
        Icons.description_outlined,
        color: Color(0xFF172C4C),
      ),
      title: Text('Actividades'),
      subtitle: Column(
        children: [
          ListTile(
            leading: Icon(Icons.comment_sharp),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: textEditingController,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 1.0),
                    ),
                    hintText: 'Añadir comentario...',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(
                  height: 6.0,
                ),
                ElevatedButton(
                    onPressed: () {
                      if (textEditingController.text.length > 0) {
                        ActividadProspectoModel newActividad =
                            ActividadProspectoModel(
                                descripcion: textEditingController.text,
                                idProspecto: widget.prospecto.idProspecto);

                        _prospectoBloc
                            .add(InsertActividadProspecto(newActividad));
                        setState(() {
                          widget.prospecto.actividades.add(newActividad);
                        });
                      }
                    },
                    child: Text('Guardar'))
              ],
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: widget.prospecto.actividades.length,
            itemBuilder: (BuildContext context, int index) {
              final List<ActividadProspectoModel> actividades =
                  List.from(widget.prospecto.actividades.reversed);
              return ListTile(
                leading: Icon(Icons.messenger_sharp),
                title: Text(actividades[index].descripcion),
              );
            },
          ),
        ],
      ),
    );
  }

  Column textAreaWidgetEdit() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              if (!isFocusDescripcion) {
                isFocusDescripcion = true;
                setState(() {});
              }
            },
            child: TextFormField(
              enabled: isFocusDescripcion,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 1.0),
                  ),
                  border: OutlineInputBorder(),
                  hintText: 'Añadir una descripción más detallada...'),
              maxLines: 3,
              initialValue: (widget.prospecto.descripcion != null)
                  ? widget.prospecto.descripcion
                  : null,
              onChanged: (value) {
                widget.prospecto.descripcion = value;
              },
            ),
          ),
        ),
        if ((widget.prospecto.descripcion == null)
            ? isFocusDescripcion
            : isEditDescripcion)
          Row(
            children: [
              ElevatedButton(
                  onPressed: () {
                    _prospectoBloc
                        .add(UpdateDescripcionProspecto(widget.prospecto));
                    setState(() {
                      isFocusDescripcion = false;
                      isEditDescripcion = false;
                    });
                  },
                  child: Text('Guardar')),
              SizedBox(
                width: 6.0,
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    if (widget.prospecto.descripcion == null) {
                      isFocusDescripcion = false;
                    } else {
                      isEditDescripcion = false;
                    }
                  });
                },
                icon: Icon(Icons.close),
              ),
            ],
          )
      ],
    );
  }
}
