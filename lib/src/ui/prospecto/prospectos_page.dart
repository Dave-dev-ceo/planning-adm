import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:planning/src/animations/loading_animation.dart';
import 'package:planning/src/blocs/prospecto/prospecto_bloc.dart';
import 'package:planning/src/models/prospectosModel/prospecto_model.dart';
import 'package:planning/src/ui/widgets/snackbar_widget/snackbar_widget.dart';

class ProspectosPage extends StatefulWidget {
  const ProspectosPage({Key key}) : super(key: key);

  @override
  _ProspectosPageState createState() => _ProspectosPageState();
}

class _ProspectosPageState extends State<ProspectosPage> {
  ProspectoBloc _prospectoBloc;
  List<EtapasModel> etapas = [];
  final ScrollController _scrollController = ScrollController();

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
              MostrarAlerta(
                  mensaje: 'Se añadio correctamente un nueva etapa',
                  tipoMensaje: TipoMensaje.correcto);
            } else {
              MostrarAlerta(
                  mensaje: 'Ocurrio un error al intentar crear una etapa',
                  tipoMensaje: TipoMensaje.error);
            }
          }
        },
        child: BlocBuilder<ProspectoBloc, ProspectoState>(
          builder: (context, state) {
            if (state is MostrarEtapasState) {
              etapas = state.etapas;
              return Padding(
                padding: const EdgeInsets.all(15.0),
                child: buildEtapas(),
              );
            } else {
              return const Center(
                child: LoadingCustom(),
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: UniqueKey(),
        tooltip: 'Añadir Etapa',
        child: const Icon(Icons.add),
        onPressed: () {
          _addEtapaSubmit(
              EtapasModel(
                  nombreEtapa: '',
                  ordenEtapa: etapas.length + 1,
                  color: '0xFFfdf4e5'),
              false);
        },
      ),
    );
  }

  Widget buildEtapas() {
    return Scrollbar(
      controller: _scrollController,
      isAlwaysShown: true,
      child: DragAndDropLists(
        contentsWhenEmpty: const Text('Sin datos'),
        scrollController: _scrollController,
        listWidth: 300,
        listDraggingWidth: 200,
        listDecoration: const BoxDecoration(
          color: Color(0xFFfdf4e5),
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
        listPadding: const EdgeInsets.all(8.0),
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
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(7.0)),
                  color: Color(int.parse(etapa.color)),
                ),
                padding: const EdgeInsets.all(10),
                child: ListTile(
                  title: Text(
                    etapa.nombreEtapa,
                    style: TextStyle(
                      color: useWhiteForeground(Color(int.parse(etapa.color)))
                          ? Colors.white
                          : Colors.black,
                      fontSize: 20.0,
                    ),
                  ),
                  trailing: PopupMenuButton(
                      icon: Icon(
                        Icons.more_vert_rounded,
                        color: useWhiteForeground(Color(int.parse(etapa.color)))
                            ? Colors.white
                            : Colors.black,
                      ),
                      onSelected: (value) {
                        if (value == 2) {
                          deleteDialogEtapa(etapa.idEtapa);
                        } else {
                          _addEtapaSubmit(etapa, true);
                        }
                      },
                      tooltip: null,
                      itemBuilder: (BuildContext context) => <PopupMenuItem>[
                            const PopupMenuItem(
                              child: Text('Editar'),
                              value: 1,
                            ),
                            if (etapa.claveEtapa == null)
                              const PopupMenuItem(
                                child: Text('Eliminar'),
                                value: 2,
                              ),
                          ]),
                )),
          ),
        ],
      ),
      footer: (!etapa.isAdd)
          ? ListTile(
              title: const Text('Añadir prospecto'),
              leading: const Icon(Icons.add),
              hoverColor: Colors.white,
              onTap: () {
                setState(() {
                  etapa.isAdd = true;
                });
              },
            )
          : Card(
              margin: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Form(
                    key: keyForm,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        decoration: const InputDecoration(
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
                  const SizedBox(
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
                                _prospectoBloc
                                    .add(AddProspectoEvent(newProspecto));
                              }
                            },
                            child: const Text('Añadir prospecto')),
                        IconButton(
                          tooltip: 'Cancelar',
                          hoverColor: Colors.transparent,
                          onPressed: () {
                            setState(() {
                              etapa.isAdd = false;
                            });
                          },
                          icon: const Icon(Icons.close),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
      leftSide: const VerticalDivider(
        color: Color(0xFFEBECF0),
        width: 1.5,
        thickness: 1.5,
      ),
      rightSide: const VerticalDivider(
        color: Color(0xFFEBECF0),
        width: 1.5,
        thickness: 1.5,
      ),
      contentsWhenEmpty: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text('Sin datos'),
      ),
      children: etapa.prospectos
          .map((prospecto) =>
              _buildItem(prospecto, etapa.nombreEtapa, etapa.claveEtapa))
          .toList(),
    );
  }

  void deleteDialogEtapa(int idEtapa) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('¿Desea eliminar la etapa?'),
              content: const Text(
                  'Los prospectos que contiene la etapa también seran eliminados.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () {
                    _prospectoBloc.add(DeleteEtapaEvent(idEtapa));
                    Navigator.of(context).pop();
                  },
                  child: const Text('Aceptar'),
                ),
              ],
            ));
  }

  DragAndDropItem _buildItem(
      ProspectoModel prospecto, String nameEtapa, String claveEtapa) {
    return DragAndDropItem(
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 5.0),
        elevation: 3,
        child: ListTile(
          title: Text(prospecto.nombreProspecto),
          onTap: () => _openDetailProspecto(prospecto, nameEtapa, claveEtapa),
        ),
      ),
    );
  }

  void _openDetailProspecto(
      ProspectoModel prospecto, String nameEtapa, String claveEtapa) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => DetailProspectoDialog(
        nameEtapa: nameEtapa,
        prospecto: prospecto,
        claveEtapa: claveEtapa,
      ),
    );
  }

  void _addEtapaSubmit(EtapasModel etapa, bool isEdit) {
    final _keyFormNewEtapa = GlobalKey<FormState>();

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return BlocListener<ProspectoBloc, ProspectoState>(
            listener: (context, state) {
              if (state is AddedEtapaState) {
                if (state.wasAdded) {
                  MostrarAlerta(
                      mensaje: 'Se añadio correctamente la etapa',
                      tipoMensaje: TipoMensaje.correcto);
                  Navigator.of(context).pop();
                } else {
                  MostrarAlerta(
                      mensaje: 'Ocurrio un error',
                      tipoMensaje: TipoMensaje.error);
                }
              }
            },
            child: StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  title: Text(!isEdit ? 'Insertar etapa' : 'Editar etapa'),
                  content: SizedBox(
                    // width: size.width * 0.3,
                    // height: size.height * 0.5,
                    child: Form(
                      key: _keyFormNewEtapa,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              initialValue: etapa.nombreEtapa,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Nombre de la etapa',
                                labelText: 'Nombre de la etapa',
                              ),
                              onChanged: (value) {
                                etapa.nombreEtapa = value;
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
                              initialValue: etapa.descripcionEtapa,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Descripción de la etapa',
                                labelText: 'Descripción de la etapa',
                              ),
                              onChanged: (value) {
                                etapa.descripcionEtapa = value;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                const Text('Seleccione el color'),
                                const SizedBox(
                                  width: 5.0,
                                ),
                                GestureDetector(
                                  child: Icon(
                                    Icons.circle,
                                    color: Color(int.parse(etapa.color)),
                                  ),
                                  onTap: () {
                                    showColorPicker(
                                            Color(int.parse(etapa.color)))
                                        .then((value) {
                                      if (value != null) {
                                        setState(() {
                                          etapa.color =
                                              "0x" + colorToHex(value);
                                        });
                                      }
                                    });
                                  },
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () {
                        if (isEdit) {
                          if (_keyFormNewEtapa.currentState.validate()) {
                            _prospectoBloc.add(UpdateDatosEtapa(etapa));
                          }
                        } else {
                          if (_keyFormNewEtapa.currentState.validate()) {
                            _prospectoBloc.add(AddEtapaEvent(etapa));
                          }
                        }
                      },
                      child: const Text('Aceptar'),
                    )
                  ],
                );
              },
            ),
          );
        });
  }

  Future showColorPicker(Color selectedColor) {
    return showDialog(
        context: context,
        builder: (contex) => AlertDialog(
              title: const Text('Seleccionar color'),
              content: SingleChildScrollView(
                child: ColorPicker(
                  pickerColor: selectedColor,
                  onColorChanged: (value) {
                    setState(() {
                      selectedColor = value;
                    });
                  },
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(selectedColor);
                    },
                    child: const Text('Aceptar'))
              ],
            ));
  }

  _onItemReorder(
      int oldItemIndex, int oldListIndex, int newItemIndex, int newListIndex) {
    _prospectoBloc.add(
      UpdateEtapaProspectoEvent(
          idEtapa: etapas[newListIndex].idEtapa,
          idProspecto:
              etapas[oldListIndex].prospectos[oldItemIndex].idProspecto),
    );
    ProspectoModel movedItem =
        etapas[oldListIndex].prospectos.removeAt(oldItemIndex);
    movedItem.idEtapa = etapas[newListIndex].idEtapa;
    etapas[newListIndex].prospectos.insert(newItemIndex, movedItem);
    setState(() {});
  }

  _onListReorder(int oldListIndex, int newListIndex) async {
    List<UpdateEtapaModel> etapasToUpdate = [];

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
    setState(() {});
  }
}

class DetailProspectoDialog extends StatefulWidget {
  final ProspectoModel prospecto;
  final String claveEtapa;
  final String nameEtapa;

  const DetailProspectoDialog(
      {Key key, @required this.prospecto, this.nameEtapa, this.claveEtapa})
      : super(key: key);

  @override
  _DetailProspectoDialogState createState() => _DetailProspectoDialogState();
}

class _DetailProspectoDialogState extends State<DetailProspectoDialog> {
  ProspectoBloc _prospectoBloc;

  bool canEditName = false;
  bool canEditPhone = false;
  bool canEditEmail = false;
  bool canEditInvolucrado = false;

  bool isFocusDescripcion = false;
  bool isEditDescripcion = false;
  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    _prospectoBloc = BlocProvider.of<ProspectoBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: BlocListener<ProspectoBloc, ProspectoState>(
        listener: (context, state) {
          if (state is DeleteProspectoSuccessState) {
            Navigator.of(context).pop();
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              tituloWidget(context),
              namePredecesorWidget(),
              involucradoWidget(),
              phonePredecesorWidget(),
              emailPredecesorWidget(),
              descripcionPredecesorWidget(),
              actividadesWidget(),
              if (widget.claveEtapa == 'ACP') addEventoButton(context),
              spacerSizedBoxWidget(),
              deleteProspectoButton(),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox spacerSizedBoxWidget() {
    return const SizedBox(
      height: 10.0,
    );
  }

  Align deleteProspectoButton() {
    return Align(
      alignment: Alignment.center,
      child: ElevatedButton(
        onPressed: () {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) => AlertDialog(
              content: const Text('¿Esta seguro de eliminar el prospecto?'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancelar')),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _prospectoBloc.add(
                          DeleteProspectoEvent(widget.prospecto.idProspecto));
                    },
                    child: const Text('Aceptar')),
              ],
            ),
          );
        },
        child: const Text('Eliminar prospecto'),
      ),
    );
  }

  Widget involucradoWidget() {
    return ListTile(
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      selectedTileColor: Colors.transparent,
      onTap: () => setState(
        () {
          canEditInvolucrado = true;
        },
      ),
      leading: const Icon(
        Icons.person,
        color: Colors.black,
      ),
      title: const Text('Involucrado'),
      subtitle: TextFormField(
        decoration: InputDecoration(
          suffixIcon: canEditInvolucrado
              ? IconButton(
                  onPressed: () {
                    _prospectoBloc.add(EditInvolucradoEvent(widget.prospecto));
                    setState(() {
                      canEditInvolucrado = false;
                    });
                  },
                  icon: const Icon(
                    Icons.save,
                    color: Colors.black,
                  ),
                )
              : null,
          hintText: 'Añadir involucrado...',
          disabledBorder: InputBorder.none,
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 1.0),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 1.0),
          ),
          border: InputBorder.none,
        ),
        enabled: canEditInvolucrado,
        initialValue: (widget.prospecto.involucradoProspecto != null)
            ? widget.prospecto.involucradoProspecto
            : null,
        onChanged: (value) => {widget.prospecto.involucradoProspecto = value},
        onFieldSubmitted: (value) => {
          _prospectoBloc.add(EditInvolucradoEvent(widget.prospecto)),
          setState(() {
            canEditInvolucrado = false;
          })
        },
      ),
    );
  }

  Widget addEventoButton(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: ElevatedButton(
          onPressed: () {
            Navigator.of(context)
                .pushNamed('/addEvento', arguments: widget.prospecto)
                .then((_) {
              Navigator.of(context).pop();
            });
          },
          child: const Text('Crear Evento')),
    );
  }

  Widget tituloWidget(BuildContext context) {
    return Row(
      children: [
        const Spacer(),
        Column(
          children: [
            const AutoSizeText(
              'Datos del prospecto',
              maxFontSize: 18.0,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            AutoSizeText(
              'Etapa: ${widget.nameEtapa}',
              maxFontSize: 13.0,
            )
          ],
        ),
        const Spacer(),
        IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.close),
        )
      ],
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
        leading: const Icon(
          Icons.email_outlined,
          color: Colors.black,
        ),
        title: const Text('Correo'),
        subtitle: TextFormField(
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            RegExp regExpEmail = RegExp(
                r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

            if (value == null || value == '') {
              return null;
            } else {
              if (regExpEmail.hasMatch(value)) {
                return null;
              } else {
                return 'Ingrese un correo eléctronico valido';
              }
            }
          },
          decoration: InputDecoration(
            suffixIcon: canEditEmail
                ? IconButton(
                    onPressed: () {
                      if (_keyFormEmail.currentState.validate()) {
                        _prospectoBloc
                            .add(UpdateCorreoProspecto(widget.prospecto));
                        setState(() {
                          canEditEmail = false;
                        });
                      }
                      setState(() {
                        canEditEmail = false;
                      });
                    },
                    icon: const Icon(
                      Icons.save,
                      color: Colors.black,
                    ),
                  )
                : null,
            hintText: 'Añadir correo electrónico...',
            helperText: 'correo@dominio.com',
            disabledBorder: InputBorder.none,
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue, width: 1.0),
            ),
            focusedErrorBorder: const OutlineInputBorder(
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
        onTap: () {
          setState(() {
            canEditPhone = true;
          });
        },
        leading: const Icon(
          Icons.phone,
          color: Colors.black,
        ),
        title: const Text('Teléfono'),
        subtitle: TextFormField(
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            suffixIcon: canEditPhone
                ? IconButton(
                    onPressed: () {
                      if (_keyPhoneForm.currentState.validate()) {
                        _prospectoBloc
                            .add(UpdateTelefonoProspecto(widget.prospecto));
                        setState(() {
                          canEditPhone = false;
                        });
                      }
                    },
                    icon: const Icon(
                      Icons.save,
                      color: Colors.black,
                    ),
                  )
                : null,
            hintText: 'Añadir teléfono...',
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue, width: 1.0),
            ),
            border: InputBorder.none,
          ),
          validator: (value) {
            if (value.length < 11 && value.isNotEmpty) {
              return null;
            }
            return 'El numero debe tener 10 digitos';
          },
          enabled: canEditPhone,
          initialValue: (widget.prospecto.telefono != null)
              ? widget.prospecto.telefono.toString()
              : null,
          onChanged: (value) =>
              {widget.prospecto.telefono = int.tryParse(value)},
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

  Widget descripcionPredecesorWidget() {
    return ListTile(
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      selectedTileColor: Colors.transparent,
      onTap: () => setState(() {
        isEditDescripcion = true;
      }),
      leading: const Icon(
        Icons.person,
        color: Colors.black,
      ),
      title: const Text('Descripción'),
      subtitle: TextFormField(
        decoration: InputDecoration(
          suffixIcon: isEditDescripcion
              ? IconButton(
                  onPressed: () {
                    _prospectoBloc
                        .add(UpdateDescripcionProspecto(widget.prospecto));
                    setState(() {
                      isEditDescripcion = false;
                    });
                  },
                  icon: const Icon(
                    Icons.save,
                    color: Colors.black,
                  ),
                )
              : null,
          hintText: 'Añadir una descripción más detallada...',
          disabledBorder: InputBorder.none,
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 1.0),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 1.0),
          ),
          border: InputBorder.none,
        ),
        enabled: isEditDescripcion,
        initialValue: (widget.prospecto.descripcion != null)
            ? widget.prospecto.descripcion
            : null,
        onChanged: (value) => {widget.prospecto.descripcion = value},
        onFieldSubmitted: (value) {
          _prospectoBloc.add(UpdateDescripcionProspecto(widget.prospecto));
          setState(() {
            isEditDescripcion = false;
          });
        },
      ),
    );
  }

  Widget namePredecesorWidget() {
    return ListTile(
      leading: const Icon(Icons.article_outlined, color: Color(0xFF172C4C)),
      title: GestureDetector(
        onTap: () => setState(
          () {
            canEditName = true;
          },
        ),
        child: TextFormField(
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
          ),
          decoration: InputDecoration(
            suffixIcon: canEditName
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        _prospectoBloc
                            .add(UpdateNameProspecto(widget.prospecto));
                        canEditName = false;
                      });
                    },
                    icon: const Icon(
                      Icons.save,
                      color: Colors.black,
                    ),
                  )
                : null,
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue, width: 1.0),
            ),
            border: InputBorder.none,
          ),
          enabled: canEditName,
          initialValue: widget.prospecto.nombreProspecto,
          onChanged: (value) => {widget.prospecto.nombreProspecto = value},
          onFieldSubmitted: (value) => {
            setState(() {
              _prospectoBloc.add(UpdateNameProspecto(widget.prospecto));
              canEditName = false;
            })
          },
        ),
      ),
    );
  }

  Widget actividadesWidget() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const ListTile(
          leading: Icon(
            Icons.wysiwyg,
            color: Color(0xFF172C4C),
          ),
          title: Text('Actividades'),
        ),
        ListTile(
          title: TextField(
            controller: textEditingController,
            decoration: const InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 1.0),
              ),
              hintText: 'Añadir comentario..',
              border: OutlineInputBorder(),
            ),
          ),
          trailing: IconButton(
            onPressed: () {
              if (textEditingController.text.isNotEmpty) {
                ActividadProspectoModel newActividad = ActividadProspectoModel(
                  descripcion: textEditingController.text,
                  idProspecto: widget.prospecto.idProspecto,
                );
                _prospectoBloc.add(InsertActividadProspecto(newActividad));
                setState(() {
                  textEditingController.clear();
                });
              }
            },
            icon: const Icon(Icons.save),
            color: Colors.black,
          ),
        ),
        BlocBuilder<ProspectoBloc, ProspectoState>(
          builder: (context, state) {
            if (state is MostrarEtapasState) {
              final etapas = state.etapas;
              final etapa = etapas
                  .firstWhere((e) => e.idEtapa == widget.prospecto.idEtapa);
              final prospecto = etapa?.prospectos?.firstWhere(
                  (p) => p.idProspecto == widget.prospecto.idProspecto);
              final List<ActividadProspectoModel> actividades =
                  prospecto.actividades;
              return Flexible(
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: actividades.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      onTap: () {
                        setState(() {
                          actividades[index].isEdit = true;
                        });
                      },
                      key: UniqueKey(),
                      leading: const Icon(Icons.messenger_sharp),
                      title: TextFormField(
                        enabled: actividades[index].isEdit,
                        initialValue: actividades[index].descripcion,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.blue,
                                width: 1.0,
                              ),
                            ),
                            suffixIcon: actividades[index].isEdit
                                ? IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _prospectoBloc.add(UpdateActividadEvent(
                                            actividades[index]));
                                        actividades[index].isEdit = false;
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.save,
                                      color: Colors.black,
                                    ))
                                : null),
                        onChanged: (value) {
                          actividades[index].descripcion = value;
                        },
                      ),
                      trailing: IconButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    content: const Text(
                                        '¿Desea eliminar la actividad?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Cancelar'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          _prospectoBloc.add(
                                            DeleteActividadEvent(
                                              actividades[index].idActividad,
                                            ),
                                          );
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Aceptar'),
                                      )
                                    ],
                                  ));
                        },
                        icon: const Icon(Icons.delete_forever),
                      ),
                    );
                  },
                ),
              );
            }
            return const LinearProgressIndicator();
          },
        ),
      ],
    );
  }

  Widget textAreaWidgetEdit() {
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
              decoration: const InputDecoration(
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
                  child: const Text('Guardar')),
              const SizedBox(
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
                icon: const Icon(Icons.close),
              ),
            ],
          )
      ],
    );
  }
}
