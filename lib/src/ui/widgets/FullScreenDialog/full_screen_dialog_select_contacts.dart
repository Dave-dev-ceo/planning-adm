// ignore_for_file: no_logic_in_create_state

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:planning/src/animations/loading_animation.dart';
import 'package:planning/src/blocs/grupos_bloc.dart';
import 'package:planning/src/models/item_model_grupos.dart';
import 'package:planning/src/resources/api_provider.dart';
import 'package:planning/src/ui/widgets/call_to_action/call_to_action.dart';
import 'package:planning/src/ui/widgets/snackbar_widget/snackbar_widget.dart';

import '../multi_selector_item.dart';

class FullScreenDialog extends StatefulWidget {
  final int? id;

  const FullScreenDialog({Key? key, this.id}) : super(key: key);
  @override
  _FullScreenDialogState createState() => _FullScreenDialogState(id);
}

class _FullScreenDialogState extends State<FullScreenDialog> {
  final int? id;
  String dropdownValue = 'Seleccione un grupo';
  String? _mySelection = "0";
  bool bandera = true;
  Iterable<Contact>? _contacts;
  TextEditingController grupo = TextEditingController();
  GlobalKey<FormState> keyForm = GlobalKey();
  ApiProvider api = ApiProvider();

  _FullScreenDialogState(this.id);
  _listaGrupos() {
    ///bloc.dispose();
    bloc.fetchAllGrupos(context);
    return StreamBuilder(
      stream: bloc.allGrupos,
      builder: (context, AsyncSnapshot<ItemModelGrupos?> snapshot) {
        if (snapshot.hasData) {
          //_mySelection = ((snapshot.data.results.length - 1).toString());
          return _dropDown(snapshot.data!);
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        return const Center(child: LoadingCustom());
      },
    );
  }

  _dropDown(ItemModelGrupos grupos) {
    return DropdownButton(
      value: _mySelection,
      icon: const Icon(Icons.arrow_drop_down_outlined),
      iconSize: 24,
      elevation: 16,
      style: const TextStyle(color: Color(0xFF000000)),
      underline: Container(
        height: 2,
        color: const Color(0xFF000000),
      ),
      onChanged: (dynamic newValue) {
        setState(() {
          if (newValue ==
              grupos.results
                  .elementAt(grupos.results.length - 1)
                  .idGrupo
                  .toString()) {
            _showMyDialog();
          } else {
            _mySelection = newValue;
          }
        });
      },
      items: grupos.results.map((item) {
        return DropdownMenuItem(
          value: item.idGrupo.toString(),
          child: Text(
            item.nombreGrupo!,
            style: const TextStyle(fontSize: 18),
          ),
        );
      }).toList(),
    );
  }

  @override
  void initState() {
    //_listaGrupos();
    controller = MultiSelectController();
    getContacts();
    super.initState();
  }

  String? validateGrupo(String? value) {
    String pattern = r"[a-zA-ZñÑáéíóúÁÉÍÓÚ\s]+";
    RegExp regExp = RegExp(pattern);
    if (value!.isEmpty) {
      return "El grupo es necesario";
    } else if (!regExp.hasMatch(value)) {
      return "El grupo debe de ser a-z y A-Z";
    }
    return null;
  }

  formItemsDesign(icon, item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Card(child: ListTile(leading: Icon(icon), title: item)),
    );
  }

  _save(BuildContext context) async {
    if (keyForm.currentState!.validate()) {
      Map<String, String> json = {"nombre_grupo": grupo.text};
      //json.
      bool response = (await api.createGrupo(json, context))!;
      if (response) {
        //_mySelection = "0";
        Navigator.of(context).pop();
        MostrarAlerta(
            mensaje: 'Grupo agregado.', tipoMensaje: TipoMensaje.correcto);
        _listaGrupos();
      } else {
        if (kDebugMode) {
          print('error');
        }
      }
    }
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title:
              const Text('Registar nuevo grupo', textAlign: TextAlign.center),
          content: SingleChildScrollView(
            child: Form(
              key: keyForm,
              child: ListBody(
                children: <Widget>[
                  TextFormField(
                    controller: grupo,
                    decoration: const InputDecoration(
                      labelText: 'Grupo',
                    ),
                    validator: validateGrupo,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                    onTap: () {
                      _save(context);
                    },
                    child: const CallToAction('Agregar'),
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cerrar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> getContacts() async {
    //We already have permissions for contact when we get to this page, so we
    // are now just retrieving it
    final Iterable<Contact> contacts = await ContactsService.getContacts();
    setState(() {
      _contacts = contacts;
      controller.set(_contacts?.length ?? 0);
    });
  }

  _avatarContact(Contact contact) {
    if (contact.avatar != null && contact.avatar!.isNotEmpty) {
      return CircleAvatar(
        backgroundImage: MemoryImage(contact.avatar!),
        radius: 25,
      );
    } else {
      return CircleAvatar(
        child: const Icon(Icons.person),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        radius: 25,
      );
    }
  }

  _nameContact(Contact contact) {
    if (contact.displayName != null && contact.displayName!.isNotEmpty) {
      return contact.displayName;
    } else {
      return 'Sin nombre';
    }
  }

  _phoneContact(Contact contact) {
    if (contact.phones != null && contact.phones!.isNotEmpty) {
      return contact.phones!.elementAt(0).value;
    } else {
      return 'Sin número';
    }
  }

  _saveContact() async {
    if (controller.selectedIndexes.isEmpty) {
      MostrarAlerta(
          mensaje: 'Seleccione un contacto.',
          tipoMensaje: TipoMensaje.advertencia);
    } else if (_mySelection == "0") {
      MostrarAlerta(
          mensaje: 'Seleccione un grupo.',
          tipoMensaje: TipoMensaje.advertencia);
    } else {
      ///////////Validar que no este vacio
      for (var i = 0; i < controller.selectedIndexes.length; i++) {
        Map<String, String?> json = {
          "nombre":
              _contacts!.elementAt(controller.selectedIndexes[i]).displayName,
          "telefono": _contacts!
              .elementAt(controller.selectedIndexes[i])
              .phones!
              .elementAt(0)
              .value,
          "id_evento": id.toString(),
          "id_grupo": _mySelection
        };
        bool response = (await api.createInvitados(json, context))!;
        if (response) {
        } else {
          bandera = false;
        }
      }
      if (bandera) {
        controller.deselectAll();
        MostrarAlerta(
            mensaje: 'Se importaron los contactos con éxito.',
            tipoMensaje: TipoMensaje.correcto);
      } else {
        MostrarAlerta(
            mensaje: 'Error: No se pudo realizar la importación.',
            tipoMensaje: TipoMensaje.error);
      }
    }
  }

  late MultiSelectController controller;
  void selectAll() {
    setState(() {
      controller.toggleAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text((controller.selectedIndexes.isNotEmpty
            ? 'Seleccionados ${controller.selectedIndexes.length}'
            : 'Seleccionar contactos')),
        actions: (controller.isSelecting)
            ? <Widget>[
                IconButton(
                  icon: const Icon(Icons.check_box),
                  onPressed: selectAll,
                )
              ]
            : <Widget>[],
      ),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 70,
            width: double.infinity,
            child: Center(
              child: _listaGrupos(),
            ),
          ),
          Expanded(
            child: _contacts != null
                ? ListView.builder(
                    itemCount: _contacts?.length ?? 0,
                    itemBuilder: (BuildContext context, int index) {
                      Contact contact = _contacts!.elementAt(index);
                      return MultiSelectItem(
                        isSelecting: controller.isSelecting,
                        onSelected: () {
                          setState(() {
                            controller.toggle(index);
                          });
                        },
                        child: Container(
                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 2, horizontal: 10),
                                child: _avatarContact(contact),
                              ),
                              //SizedBox(height: 10,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _nameContact(contact),
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    _phoneContact(contact),
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          decoration: controller.isSelected(index)
                              ? BoxDecoration(color: Colors.grey[300])
                              : const BoxDecoration(),
                        ),
                      );
                    },
                  )
                : const Center(child: LoadingCustom()),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        heroTag: UniqueKey(),
        onPressed: () {
          _saveContact();
        },
        child: const Icon(Icons.cloud_upload_outlined),
      ),
    );
  }
}
