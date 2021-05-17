import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weddingplanner/src/blocs/blocs.dart';
//import 'package:weddingplanner/src/blocs/estatus_bloc.dart';
import 'package:weddingplanner/src/models/item_model_estatus_invitado.dart';
import 'package:weddingplanner/src/models/item_model_grupos.dart';
import 'package:weddingplanner/src/models/item_model_invitado.dart';
import 'package:weddingplanner/src/models/item_model_mesas.dart';
import 'package:weddingplanner/src/resources/api_provider.dart';
import 'package:weddingplanner/src/resources/my_flutter_app_icons.dart';
import 'package:weddingplanner/src/ui/widgets/call_to_action/call_to_action.dart';
import 'package:material_segmented_control/material_segmented_control.dart';
class FullScreenDialogEdit extends StatefulWidget {
  final int idInvitado;

  const FullScreenDialogEdit({Key key, this.idInvitado}) : super(key: key);
  @override
  _FullScreenDialogEditState createState() => _FullScreenDialogEditState(idInvitado);
}

class _FullScreenDialogEditState extends State<FullScreenDialogEdit> {
  ApiProvider api = new ApiProvider();
  final int idInvitado;
  int contActualiza = 0;
  int contActualizaEdad = 0;
  int contActualizaGenero = 0;
  int contActualizaGrupo = 0;
  int contActualizaData = 0;
  int contActualizaMesa = 0;
  bool isExpaned = true;
  bool isExpanedT = false;
  GlobalKey<FormState> keyForm = new GlobalKey();
  GlobalKey<FormState> keyFormG = new GlobalKey();
  TextEditingController  nombreCtrl = new TextEditingController();

  TextEditingController  emailCtrl = new TextEditingController();

  //TextEditingController  apellidosCtrl = new TextEditingController();
  TextEditingController  grupo = new TextEditingController();

  TextEditingController  telefonoCtrl = new TextEditingController();

  TextEditingController  tipoAlimentacionCtrl = new TextEditingController();
  TextEditingController  asistenciaEspecialCtrl = new TextEditingController();
  TextEditingController  alergiasCtrl = new TextEditingController();
  //String dropdownValueEstatus = 'Confirmado';
  String dropdownValue = 'Hombre';
  int _currentSelection;
  int _currentSelectionGenero;
  String _mySelection;
  String _mySelectionG = "1";
  String _mySelectionM = "0";
  bool _lights = false;
  _FullScreenDialogEditState(this.idInvitado);
  Map<int, Widget> _children = {
    0: Text('Adulto',style: TextStyle(fontSize: 12),),
    1: Text('Niño',style: TextStyle(fontSize: 12),),
  };
  Map<int, Widget> _childrenGenero = {
    0: Text('Hombre',style: TextStyle(fontSize: 12),),
    1: Text('Mujer',style: TextStyle(fontSize: 12),),
  };

 //_FullScreenDialogEditState(this.id);

  _datosInvitado(){
    ///bloc.dispose();
    blocInvitado.fetchAllInvitado(idInvitado, context);
    return StreamBuilder(
            stream: blocInvitado.allInvitado,
            builder: (context, AsyncSnapshot<ItemModelInvitado> snapshot) {
              if (snapshot.hasData) {
                //_mySelection = ((snapshot.data.results.length - 1).toString());
                //print(_mySelection);
                return formUI(snapshot.data);
                //print(snapshot.data);
              } else if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }
              return Center(child: CircularProgressIndicator());
            },
          );
  }

  _listaGrupos(){
    ///bloc.dispose();
    blocGrupos.fetchAllGrupos(context);
    return StreamBuilder(
            stream: blocGrupos.allGrupos,
            builder: (context, AsyncSnapshot<ItemModelGrupos> snapshot) {
              if (snapshot.hasData) {
                //_mySelection = ((snapshot.data.results.length - 1).toString());
                //print(_mySelection);
                return _dropDownGrupos(snapshot.data);
                //print(snapshot.data);
              } else if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }
              return Center(child: CircularProgressIndicator());
            },
          );
  }

  _listaMesas(){
    ///bloc.dispose();
    blocMesas.fetchAllMesas(context);
    return StreamBuilder(
            stream: blocMesas.allMesas,
            builder: (context, AsyncSnapshot<ItemModelMesas> snapshot) {
              if (snapshot.hasData) {
                //_mySelection = ((snapshot.data.results.length - 1).toString());
                //print(_mySelection);
                return _dropDownMesas(snapshot.data);
                //print(snapshot.data);
              } else if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }
              return Center(child: CircularProgressIndicator());
            },
          );
  }

  _dropDownMesas(ItemModelMesas mesas){
    return DropdownButton(
      value: _mySelectionM,
      icon: const Icon(Icons.arrow_drop_down_outlined),
      iconSize: 24,
      elevation: 16,
      style: const TextStyle(color: Color(0xFF880B55)),
      underline: Container(
        height: 2,
        color: Color(0xFF880B55),
      ),
      onChanged: (newValue) {
        setState(() {
            _mySelectionM = newValue;
          
          
        });
      },
      items: mesas.results.map((item) {
        return DropdownMenuItem(
          value: item.idMesa.toString(),
          child: Text(item.mesa, style: TextStyle(fontSize: 18),),
        );
      }).toList(),
    );
  }

  _dropDownGrupos(ItemModelGrupos grupos){
    return DropdownButton(
        value: _mySelectionG,
        icon: const Icon(Icons.arrow_drop_down_outlined),
        iconSize: 24,
        elevation: 16,
        style: const TextStyle(color: Color(0xFF880B55)),
        underline: Container(
          height: 2,
          color: Color(0xFF880B55),
        ),
        onChanged: (newValue) {
          setState(() {
            if(newValue == grupos.results.elementAt(grupos.results.length-1).idGrupo.toString()){
              _showMyDialog();
            }else{
              _mySelectionG = newValue;
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

  Future<void> _showMyDialog() async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Registar nuevo grupo', textAlign: TextAlign.center),
        content: SingleChildScrollView(
          child: Form(
            key: keyFormG,
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
  _save(BuildContext context) async{
    if (keyFormG.currentState.validate()) {
      Map <String,String> json = {
       "nombre_grupo":grupo.text
      };
      //json.
      bool response = await api.createGrupo(json,context);
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
  _listaEstatus(){
    ///bloc.dispose();
    blocEstatus.fetchAllEstatus(context);
    return StreamBuilder(
            stream: blocEstatus.allEstatus,
            builder: (context, AsyncSnapshot<ItemModelEstatusInvitado> snapshot) {
              if (snapshot.hasData) {
                //_mySelection = ((snapshot.data.results.length - 1).toString());
                //print(_mySelection);
                return _dropDownEstatusInvitado(snapshot.data);
                //print(snapshot.data);
              } else if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }
              return Center(child: CircularProgressIndicator());
            },
          );
  }

  _dropDownEstatusInvitado(ItemModelEstatusInvitado estatus){
    return DropdownButton(
      value: _mySelection,
      icon: const Icon(Icons.arrow_drop_down_outlined),
      iconSize: 24,
      elevation: 16,
      
      style: const TextStyle(color: Color(0xFF880B55)),
      underline: Container(
        height: 2,
        color: Color(0xFF880B55),
      ),
      onChanged: (newValue) {
        setState(() {
            _mySelection = newValue;
            print(_mySelection);
        });
      },
      items: estatus.results.map((item) {
        return DropdownMenuItem(
          value: item.idEstatusInvitado.toString(),
          child: Text(item.descripcion, style: TextStyle(fontSize: 18),),
        );
      }).toList(),
    );
  }


  _dropDownGenero(){
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
            dropdownValue = newValue;
        });
      },
      items: <String>['Hombre', 'Mujer'].map((item) {
        return DropdownMenuItem(
          value: item,
          child: Text(item, style: TextStyle(fontSize: 18),),
        );
      }).toList(),
    );
  }
 String gender;
 String edad;
formItemsDesign(icon, item, large,ancho) {
   return Padding(
     padding: EdgeInsets.symmetric(vertical: 3),
     child: Container(child: Card(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),elevation: 10,child: ListTile(leading: Icon(icon), title: item)), width: large,height: ancho,),
   );
  }
  Widget formUI(ItemModelInvitado invitado) {
    if(contActualiza <= 0){
      if(invitado.asistencia == "Confirmado"){
        _mySelection = "1";
        contActualiza++;
        print('entro en confirmado');
      }else if(invitado.asistencia == "Sin Confirmar"){
        _mySelection = "2";
        contActualiza++;
        print('entro en no confirmado');
      }else if(invitado.asistencia == "No Asiste"){
        _mySelection = "3";
        contActualiza++;
        print('entro en no asiste');
      }
    }
    if(contActualizaEdad <= 0){
      if(invitado.edad == "A"){
        _currentSelection = 0;
        contActualizaEdad++;
        print('entro en A');
      }else if(invitado.edad == "N"){
        _currentSelection = 1;
        contActualizaEdad++;
        print('entro en N');
      }
    }

    if(contActualizaGenero <= 0){
      if(invitado.genero == "H"){
        _currentSelectionGenero = 0;
        contActualizaGenero++;
        print('entro en H');
      }else if(invitado.genero == "M"){
        _currentSelectionGenero = 1;
        contActualizaGenero++;
        print('entro en M');
      }
    }
    if(contActualizaGrupo <= 0){
      if(invitado.grupo == null){
        _mySelectionG = "0";
      }else{
        _mySelectionG = invitado.grupo.toString();
      }
      contActualizaGrupo++;
    }
    if(contActualizaMesa <= 0){
      if(invitado.idMesa == null){
        _mySelectionM = "0";
      }else{
        _mySelectionM = invitado.idMesa.toString();
      }
      contActualizaMesa++;
    }
    if(contActualizaData <= 0){
      nombreCtrl.text = invitado.nombre;
      emailCtrl.text = invitado.email;
      telefonoCtrl.text = invitado.telefono;
      alergiasCtrl.text = invitado.alergias;
      tipoAlimentacionCtrl.text = invitado.alimentacion;
      asistenciaEspecialCtrl.text = invitado.asistenciaEspecial;
      contActualizaData++;
    }
    
    //int _sliding = 0;
    //String nombre = "Victor Maunel Sanchez Rodriguez";
   return  Column(
     children: <Widget>[
       SizedBox(width: 35,),
       /*Wrap(
         children:<Widget>[
           
            formItemsDesign(
           Icons.person,
           TextFormField(
             controller: nombreCtrl,
             decoration: new InputDecoration(
               labelText: 'Nombre completo',
             ),
             //initialValue: invitado.nombre,
             validator: validateNombre,
           ),500.0,80.0),
       formItemsDesign(
           //MyFlutterApp.transgender,
           Icons.assignment,
           Row(
             children: <Widget>[
               Text('Asistencia'),
               SizedBox(width: 15,),
               
                _listaEstatus(),
                      //_dropDownEstatusInvitado(),
             ],),
             500.0,80.0
             )
            //Container(width: 300,child: TextFormField(initialValue: nombre,decoration: InputDecoration(labelText: 'Nombre'))),
         ]
       ),
       Wrap(
         children: <Widget>[
         formItemsDesign(Icons.av_timer_rounded, Row(
                    children:<Widget>[ 
              Text('Edad'),
              //SizedBox(width: 15,),
              Expanded(
                              child: MaterialSegmentedControl(
                children: _children,
                selectionIndex: _currentSelection,
                borderColor: Color(0xFF880B55),
                selectedColor: Color(0xFF880B55),
                unselectedColor: Colors.white,
                borderRadius: 32.0,
                horizontalPadding: EdgeInsets.all(8),
                onSegmentChosen: (index) {
                  setState(() {
                    _currentSelection = index;
                  });
                },
           ),
              ),]
         ), 500.0,80.0),
         formItemsDesign(MyFlutterApp.transgender, Row(
                    children:<Widget>[ 
              Text('Genero'),
              //SizedBox(width: 15,),
              Expanded(
                              child: MaterialSegmentedControl(
                children: _childrenGenero,
                selectionIndex: _currentSelectionGenero,
                borderColor: Color(0xFF880B55),
                selectedColor: Color(0xFF880B55),
                unselectedColor: Colors.white,
                borderRadius: 32.0,
                horizontalPadding: EdgeInsets.all(8),
                onSegmentChosen: (index) {
                  setState(() {
                    _currentSelectionGenero = index;
                  });
                },
           ),
              ),]
         ), 500.0,80.0),
         
         ],
       ),
       Wrap(
         children: <Widget>[
           formItemsDesign(Icons.email, TextFormField(
             controller: emailCtrl,
             //initialValue: invitado.email,
             decoration: new InputDecoration(
               labelText: 'Correo',
             ),
             validator: validateEmail,
           ), 500.0, 80.0),

           formItemsDesign(!invitado.estatusInvitacion?Icons.cancel:Icons.check_box, MergeSemantics(
            child: ListTile(
              title: Text(!invitado.estatusInvitacion?'Invitación pendiente':'Invitación enviada'),
              
              trailing: CupertinoSwitch(
                value: _lights,//invitado.estatusInvitacion,
                onChanged: (bool value) { setState(() { _lights = value; }); },
              ),
              onTap: () { setState(() { _lights = !_lights; }); },
            ),
          ), 500.0, 80.0)
         ],
       ),
       Wrap(
         children: <Widget>[
           formItemsDesign(Icons.phone, TextFormField(
             controller: telefonoCtrl,
             //initialValue: invitado.telefono,
             decoration: new InputDecoration(
               labelText: 'Número de teléfono',
             ),
             validator: validateTelefono,
           ), 500.0, 80.0),
            formItemsDesign(Icons.group, 
            Row(children: <Widget>[
              Text('Grupo'),
              SizedBox(width: 15,),
              _listaGrupos(), 
            ],),
             
            500.0, 80.0)

         ],
       ),*/
       
       /*Wrap(
         children: <Widget>[
           formItemsDesign(Icons.tablet_rounded, Row(children: <Widget>[
             Text('Mesa'),
              SizedBox(width: 15,),
             _listaMesas(),
           ],), 500.0, 50.0)
         ],
       ),*/
       SizedBox(width: 25,),
      ExpansionPanelList(
        animationDuration: Duration(milliseconds:1000),

        expansionCallback: (int index,bool expaned){setState(() {
          
          if(index == 0){
            isExpaned = !isExpaned;  
          }else{
            isExpanedT = !isExpanedT;
          }
          //print(index);
        });},
        children: [
          ExpansionPanel(headerBuilder: (BuildContext context, bool isExpaned){
            return Center(child: Text('Información general',style: TextStyle(fontSize: 20.0),));
          },
          canTapOnHeader: true,
          isExpanded: isExpaned,
           body: Container(
            child: Column(
              children: <Widget>[
                Wrap(
                  children:<Widget>[
                    
                      formItemsDesign(
                    Icons.person,
                    TextFormField(
                      controller: nombreCtrl,
                      decoration: new InputDecoration(
                        labelText: 'Nombre completo',
                      ),
                      //initialValue: invitado.nombre,
                      validator: validateNombre,
                    ),500.0,80.0),
                formItemsDesign(
                    //MyFlutterApp.transgender,
                    Icons.assignment,
                    Row(
                      children: <Widget>[
                        Text('Asistencia'),
                        SizedBox(width: 15,),
                        
                          _listaEstatus(),
                                //_dropDownEstatusInvitado(),
                      ],),
                      500.0,80.0
                      )
                      //Container(width: 300,child: TextFormField(initialValue: nombre,decoration: InputDecoration(labelText: 'Nombre'))),
                  ]
                ),
                Wrap(
                  children: <Widget>[
                  formItemsDesign(Icons.av_timer_rounded, Row(
                              children:<Widget>[ 
                        Text('Edad'),
                        //SizedBox(width: 15,),
                        Expanded(
                                        child: MaterialSegmentedControl(
                          children: _children,
                          selectionIndex: _currentSelection,
                          borderColor: Color(0xFF880B55),
                          selectedColor: Color(0xFF880B55),
                          unselectedColor: Colors.white,
                          borderRadius: 32.0,
                          horizontalPadding: EdgeInsets.all(8),
                          onSegmentChosen: (index) {
                            setState(() {
                              _currentSelection = index;
                            });
                          },
                    ),
                        ),]
                  ), 500.0,80.0),
                  formItemsDesign(MyFlutterApp.transgender, Row(
                              children:<Widget>[ 
                        Text('Genero'),
                        //SizedBox(width: 15,),
                        Expanded(
                                        child: MaterialSegmentedControl(
                          children: _childrenGenero,
                          selectionIndex: _currentSelectionGenero,
                          borderColor: Color(0xFF880B55),
                          selectedColor: Color(0xFF880B55),
                          unselectedColor: Colors.white,
                          borderRadius: 32.0,
                          horizontalPadding: EdgeInsets.all(8),
                          onSegmentChosen: (index) {
                            setState(() {
                              _currentSelectionGenero = index;
                            });
                          },
                    ),
                        ),]
                  ), 500.0,80.0),
                  
                  ],
                ),
                Wrap(
                  children: <Widget>[
                    formItemsDesign(Icons.email, TextFormField(
                      controller: emailCtrl,
                      //initialValue: invitado.email,
                      decoration: new InputDecoration(
                        labelText: 'Correo',
                      ),
                      validator: validateEmail,
                    ), 500.0, 80.0),

                    formItemsDesign(!invitado.estatusInvitacion?Icons.cancel:Icons.check_box, MergeSemantics(
                      child: ListTile(
                        title: Text(!invitado.estatusInvitacion?'Invitación pendiente':'Invitación enviada'),
                        
                        trailing: CupertinoSwitch(
                          value: _lights,//invitado.estatusInvitacion,
                          onChanged: (bool value) { setState(() { _lights = value; }); },
                        ),
                        onTap: () { setState(() { _lights = !_lights; }); },
                      ),
                    ), 500.0, 80.0)
                  ],
                ),
                Wrap(
                  children: <Widget>[
                    formItemsDesign(Icons.phone, TextFormField(
                      controller: telefonoCtrl,
                      //initialValue: invitado.telefono,
                      decoration: new InputDecoration(
                        labelText: 'Número de teléfono',
                      ),
                      validator: validateTelefono,
                    ), 500.0, 80.0),
                      formItemsDesign(Icons.group, 
                      Row(children: <Widget>[
                        Text('Grupo'),
                        SizedBox(width: 15,),
                        _listaGrupos(), 
                      ],),
                      
                      500.0, 80.0)

                  ],
                ),
                SizedBox(height: 30.0,),
              ],
            )
          )),
          ExpansionPanel(headerBuilder: (BuildContext context, bool isExpaned){
            return Center(child: Text('Comentarios',style: TextStyle(fontSize: 20.0),));
          },
          canTapOnHeader: true,
          isExpanded: isExpanedT,
           body: Container(
            child: Column(
              children: <Widget>[
                Wrap(
                  children: <Widget>[
                    formItemsDesign(null, TextFormField(
                      controller: tipoAlimentacionCtrl,
                      keyboardType: TextInputType.multiline,
                      maxLines: 2,
                      //initialValue: invitado.email,
                      decoration: new InputDecoration(
                        labelText: 'Tipo de alimentación',
                      ),
                      //validator: validateEmail,
                    ), 500.0, 100.0),

                    formItemsDesign(null, TextFormField(
                      controller: alergiasCtrl,
                      keyboardType: TextInputType.multiline,
                      maxLines: 2,
                      //initialValue: invitado.email,
                      decoration: new InputDecoration(
                        labelText: 'Alergias',
                      ),
                      //validator: validateEmail,
                    ), 500.0, 100.0),
                    //SizedBox(height: 30.0,),
                  ],
                ),
                Wrap(
                  children: <Widget>[
                    formItemsDesign(null, TextFormField(
                      controller: asistenciaEspecialCtrl,
                      keyboardType: TextInputType.multiline,
                      maxLines: 2,
                      //initialValue: invitado.email,
                      decoration: new InputDecoration(
                        labelText: 'Asistencia especial',
                      ),
                      //validator: validateEmail,
                    ), 500.0, 100.0),

                    formItemsDesign(Icons.tablet_rounded, Row(children: <Widget>[
                      Text('Mesa'),
                        SizedBox(width: 15,),
                      _listaMesas(),
                    ],), 500.0, 100.0),
                    
                  ],
                ),
                SizedBox(height: 30.0,),
              ],
            ),
          )),
          
        ],
      ),
      SizedBox(height: 30.0,),
      GestureDetector(
        
        onTap: (){
          save();
          
        },
        child: 
        CallToAction('Guardar')
      )
     ] 
   );
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

 String validateNombre(String value) {
   String pattern = r"[a-zA-ZñÑáéíóúÁÉÍÓÚ\s]+";
   RegExp regExp = new RegExp(pattern);
   if (value.length == 0) {
     return "El nombre es necesario";
   } else if (!regExp.hasMatch(value)) {
     return "El nombre debe de ser a-z y A-Z";
   }
   return null;
 }

 String validateTelefono(String value) {
   String patttern = r'(^[0-9]*$)';
   RegExp regExp = new RegExp(patttern);
   if (value.length == 0) {
     return "El telefono es necesario";
   } else if (value.length != 10) {
     return "El numero debe tener 10 digitos";
   }else if (!regExp.hasMatch(value)) {
     return "El numero debe ser de 0-9";
   }
   return null;
 }

 String validateEmail(String value) {
   String pattern =
       r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
   RegExp regExp = new RegExp(pattern);
   if (value.length == 0) {
     return "El correo es necesario";
   } else if (!regExp.hasMatch(value)) {
     return "Correo invalido";
   } else {
     return null;
   }
 }

 save() async{
   //if (keyForm.currentState.validate()) {
     if(_currentSelectionGenero == 0){
       gender = "H";
     }else if(_currentSelectionGenero == 1){
       gender = "M";
     }
     if(_currentSelection == 0){
       edad = "A";
     }else if(_currentSelection == 1){
       edad = "N";
     }
     //id_invitado, id_estatus_invitado, nombre, edad, genero, email, telefono, id_grupo
     Map <String,String> json = {
       "id_invitado":idInvitado.toString(),
       "id_estatus_invitado":_mySelection,
       "nombre":nombreCtrl.text,
       "edad":edad,
       "telefono":telefonoCtrl.text,
       "email":emailCtrl.text,
       "genero":gender,
       "id_grupo":_mySelectionG,
       "id_mesa":_mySelectionM,
       "alimentacion":tipoAlimentacionCtrl.text,
       "alergias":alergiasCtrl.text,
       "asistencia_especial":asistenciaEspecialCtrl.text
      };
     //json.
     bool response = await api.updateInvitado(json,context);

     //bloc.insertInvitados;
      //print(response);
      if (response) {
        Navigator.of(context).pop();
        /*keyForm.currentState.reset();
        nombreCtrl.clear();
        telefonoCtrl.clear();
        emailCtrl.clear();
        dropdownValue = "Hombre";*/
        final snackBar = SnackBar(
            content: Container(
              height: 30,
              child: Center(
              child: Text('Invitado actualizado'),
            ),
              //color: Colors.red,
            ),
            backgroundColor: Colors.green,  
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);  
      } else {
        final snackBar = SnackBar(
          content: Container(
            height: 30,
            child: Center(
            child: Text('Error: No se pudo realizar la actualización'),
          ),
            //color: Colors.red,
          ),
          backgroundColor: Colors.red,  
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
      
  //}
 }
    @override
  void initState() {
    super.initState();
  }
            
  Color hexToColor(String code) {
      return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
        appBar: AppBar(
          title: Text('Editar Invitado'),
          automaticallyImplyLeading: true,
          backgroundColor: hexToColor('#880B55'),
        ),
        body: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            alignment: Alignment.center,
                      //child: Expanded(
                                              child: 
                                              new Container(
              width: 1200,
              margin: new EdgeInsets.all(10.0),
              child: new Form(
                key: keyForm,
                child: _datosInvitado(),
              ),
            ),
                      ),
          //),
        )
    );
  }
}