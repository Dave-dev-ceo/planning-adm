import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:multi_select_item/multi_select_item.dart';
import 'package:weddingplanner/src/blocs/grupos_bloc.dart';
import 'package:weddingplanner/src/models/item_model_grupos.dart';
import 'package:weddingplanner/src/resources/api_provider.dart';
import 'package:weddingplanner/src/ui/widgets/call_to_action/call_to_action.dart';

class FullScreenDialog extends StatefulWidget {
  final int id;

  const FullScreenDialog({Key key, this.id}) : super(key: key);
  @override
  _FullScreenDialogState createState() => _FullScreenDialogState(id);
}

class _FullScreenDialogState extends State<FullScreenDialog> {
  final int id;
  String dropdownValue = 'Seleccione un grupo';
  String _mySelection = "0";
  bool bandera = true;
  Iterable<Contact> _contacts;
  TextEditingController  grupo = new TextEditingController();
  GlobalKey<FormState> keyForm = new GlobalKey();
  ApiProvider api = new ApiProvider();

  _FullScreenDialogState(this.id);
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

  _dropDown2(){
    return DropdownButton(
      value: dropdownValue,
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
          if(newValue == "Nuevo grupo"){
            //print(newValue);
            _showMyDialog();
          }else{
            print(newValue);
            dropdownValue = newValue;
          }
          
        });
      },
      items: <String>['Seleccione un grupo', 'General', 'Familiares' ,'Nuevo grupo'].map((item) {
        return DropdownMenuItem(
          value: item,
          child: Text(item, style: TextStyle(fontSize: 18),),
        );
      }).toList(),
    );
  }
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
          if(newValue == grupos.results.elementAt(grupos.results.length-1).idGrupo.toString()){
            _showMyDialog();
          }else{
            _mySelection = newValue;
          }
          
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
  _save(BuildContext context) async{
    if (keyForm.currentState.validate()) {
      Map <String,String> json = {
       "nombre_grupo":grupo.text
      };
      //json.
      bool response = await api.createGrupo(json);
      if (response) {
        //_mySelection = "0";
        Navigator.of(context).pop();
        _msgSnackBar('Grupo agregado',Colors.green);
        _listaGrupos();
      } else {
        print('error');
      }
    }
  }

  Future<void> _showMyDialog() async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
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
                          _save(context);
                          //print('guardado');
                        },
                        child: CallToAction('Agregar'),
                      ),
              ],
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Cerrar'),
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
  _msgSnackBar(String error, Color color){
    final snackBar = SnackBar(
              content: Container(
                height: 30,
                child: Center(
                child: Text(error),
              ),
                //color: Colors.red,
              ),
              backgroundColor: color,  
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
  _saveContact() async{
    if(controller.selectedIndexes.length <=  0){
      _msgSnackBar('Seleccione un contacto',Colors.red);
    }else if(_mySelection == "0"){
      _msgSnackBar('Seleccione un grupo',Colors.red);
    }else{
      ///////////Validar que no este vacio
      for (var i = 0; i < controller.selectedIndexes.length; i++) {
        Map <String,String> json = {
          "nombre":_contacts.elementAt(controller.selectedIndexes[i]).displayName,
          "telefono":_contacts.elementAt(controller.selectedIndexes[i]).phones.elementAt(0).value,
          "id_evento":id.toString(),
          "id_grupo":_mySelection
        };
        bool response = await api.createInvitados(json);
            if(response){

            }else{
              bandera = false;
            }   
      }
      if(bandera){
        controller.deselectAll();
        _msgSnackBar('Se importaron los contactos con éxito',Colors.green);
      }else{
        _msgSnackBar('Error: No se pudo realizar la importación',Colors.red);
      }
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
          _saveContact();
        },
        child: const Icon(Icons.cloud_upload_outlined),
        backgroundColor: Colors.pink[300],
      ),
      
      
      
        
    );
  }
}