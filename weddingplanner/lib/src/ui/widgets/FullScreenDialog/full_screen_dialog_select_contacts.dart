import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:multi_select_item/multi_select_item.dart';
import 'package:weddingplanner/src/blocs/grupos_bloc.dart';
import 'package:weddingplanner/src/models/item_model_grupos.dart';
import 'package:weddingplanner/src/ui/widgets/call_to_action/call_to_action.dart';

class FullScreenDialog extends StatefulWidget {
  @override
  _FullScreenDialogState createState() => _FullScreenDialogState();
}

class _FullScreenDialogState extends State<FullScreenDialog> {
  String dropdownValue = 'Seleccione un grupo';
  String _mySelection = "0";
  Iterable<Contact> _contacts;
  TextEditingController  grupo = new TextEditingController();
  GlobalKey<FormState> keyForm = new GlobalKey();

  _listaGrupos(){
    ///bloc.dispose();
    bloc.fetchAllGrupos();
    return StreamBuilder(
            stream: bloc.allGrupos,
            builder: (context, AsyncSnapshot<ItemModelGrupos> snapshot) {
              if (snapshot.hasData) {
                //_mySelection = ((snapshot.data.results.length - 1).toString());
                //print(_mySelection);
                return _dropDown(snapshot.data);
                //print(snapshot.data);
              } else if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }
              return Center(child: CircularProgressIndicator());
            },
          );
  }
  /*Widget buildList(AsyncSnapshot<ItemModelGrupos> snapshot) {
    return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          PaginatedDataTable(
            header: Text('Invitados'),
            rowsPerPage: 5,
            showCheckboxColumn: false,
            columns: [
              DataColumn(label: Text('Nombre', style:estiloTxt)),
              DataColumn(label: Text('Telefono', style:estiloTxt)),
              DataColumn(label: Text('Email', style:estiloTxt)),
              DataColumn(label: Text('Asistencia', style:estiloTxt)),
            ],
            
            source: _DataSource(snapshot.data.results),
          ),
        ],
      );
  }*/
  /*_seleccion(grupos){
    _mySelection = ((grupos.results.length - 1).toString());
    return ((grupos.results.length - 1).toString());
  } */
  _dropDown(ItemModelGrupos grupos){
    return DropdownButton(
      value: _mySelection,
      icon: const Icon(Icons.arrow_drop_down_outlined),
      iconSize: 24,
      elevation: 16,
      style: const TextStyle(color: Colors.pink),
      underline: Container(
        height: 2,
        color: Colors.pink,
      ),
      onChanged: (newValue) {
        setState(() {
          _mySelection = newValue;
        });
      },
      items: grupos.results.map((item) {
        return DropdownMenuItem(
          value: item.idGrupo.toString(),
          child: Text(item.nombreGrupo, style: TextStyle(fontSize: 18),),
        );
      }).toList(),
    );
  }
    @override
  void initState() {
    //_listaGrupos();
    controller = new MultiSelectController();
    getContacts();
    super.initState();
  }
  String validateGrupo(String value) {
    String pattern = r"[a-zA-ZñÑáéíóúÁÉÍÓÚ\s]+";
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "El grupo es necesario";
    } else if (!regExp.hasMatch(value)) {
      return "El grupo debe de ser a-z y A-Z";
    }
    return null;
  }

  formItemsDesign(icon, item) {
   return Padding(
     padding: EdgeInsets.symmetric(vertical: 7),
     child: Card(child: ListTile(leading: Icon(icon), title: item)),
   );
  }
  _save(){
    if (keyForm.currentState.validate()) {
      print('grupo');
    }
  }

  Future<void> _showMyDialog() async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Registar nuevo grupo', textAlign: TextAlign.center),
        content: SingleChildScrollView(
          child: Form(
            key: keyForm,
            child: ListBody(
              children: <Widget>[
                  
                TextFormField(
                  controller: grupo,
                  decoration: new InputDecoration(
                    labelText: 'Grupo',
                  ),
                  validator: validateGrupo,
                ),
                
                SizedBox(
                  height: 30,
                ),

                GestureDetector(
                        onTap: (){
                          _save();
                          //print('guardado');
                        },
                        child: CallToAction('Guardar grupo'),
                      ),
              ],
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Approve'),
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

  _avatarContact(Contact contact){
    if(contact.avatar!= null && contact.avatar.isNotEmpty){
      return CircleAvatar(
              backgroundImage: MemoryImage(contact.avatar),
              radius: 25,
            );
    }else{
      return
      CircleAvatar(
        child: Icon(Icons.person),
        backgroundColor: Theme.of(context).accentColor,
        
        radius: 25,
      );
    }
  }
  _nameContact(Contact contact){
    if(contact.displayName!= null && contact.displayName.isNotEmpty){
      return contact.displayName;
    }else{
      return
      'Sin nombre';
    }
  }
  _phoneContact(Contact contact){
    if(contact.phones!= null && contact.phones.isNotEmpty){
      return contact.phones.elementAt(0).value;
    }else{
      return
      'Sin número';
    }
  }
  MultiSelectController controller;
  void selectAll() {
    setState(() {
      controller.toggleAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text((controller.selectedIndexes.length>0?'Seleccionados ${controller.selectedIndexes.length}':'Seleccionar Contactos')),
        actions: (controller.isSelecting)
        ?<Widget>[
                  IconButton(
                    icon: Icon(Icons.check_box),
                    onPressed: selectAll,
                    
                  )
                ]
              : <Widget>[],
      ),
      body:  Column(
        children: <Widget>[
          Container(
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
                  Contact contact = _contacts?.elementAt(index);
                  return MultiSelectItem(
                    isSelecting: controller.isSelecting, 
                    onSelected: (){
                      setState(() {
                        controller.toggle(index);
                        //print(controller.selectedIndexes.toString());
                      });
                    },
                    child: Container(
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                            child: _avatarContact(contact),
                          ),
                          //SizedBox(height: 10,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _nameContact(contact),
                                style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold
                                ),
                              ),
                              SizedBox(height: 5,),
                              Text(
                                _phoneContact(contact),
                                style: TextStyle(
                                  fontSize: 10, fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      decoration: controller.isSelected(index)
                      ? new BoxDecoration(color: Colors.grey[300])
                      : new BoxDecoration(),
                    ),
                    
                  );
                },
              )
            : Center(child: const CircularProgressIndicator()),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showMyDialog();
        },
        child: const Icon(Icons.cloud_upload_outlined),
        //backgroundColor: Colors.green,
      ),
      
      
      
        
    );
  }
}