import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weddingplanner/src/blocs/blocs.dart';
import 'package:weddingplanner/src/models/item_model_estatus_invitado.dart';
import 'package:weddingplanner/src/resources/api_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:weddingplanner/src/ui/widgets/call_to_action/call_to_action.dart';

class ListaEstatusInvitaciones extends StatefulWidget {
  final int idPlanner;

  const ListaEstatusInvitaciones({Key key, this.idPlanner}) : super(key: key);
  static Route<dynamic> route() => MaterialPageRoute(
        builder: (context) => ListaEstatusInvitaciones(),
      );
  @override
  _ListaEstatusInvitacionesState createState() => _ListaEstatusInvitacionesState(idPlanner);
}

class _ListaEstatusInvitacionesState extends State<ListaEstatusInvitaciones> {
  final TextStyle estiloTxt = TextStyle(fontWeight: FontWeight.bold);
  final int idPlanner;
  ApiProvider api = new ApiProvider();
  TextEditingController  estatusCtrl = new TextEditingController();
  _ListaEstatusInvitacionesState(this.idPlanner);  
  Color hexToColor(String code) {
    return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }
  
  listaEstatusInvitaciones(BuildContext cont){
    ///bloc.dispose();
    blocEstatus.fetchAllEstatus(context);
    return StreamBuilder(
            stream: blocEstatus.allEstatus,
            builder: (context, AsyncSnapshot<ItemModelEstatusInvitado> snapshot) {
              if (snapshot.hasData) {
                return buildList(snapshot);
              } else if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }
              return Center(child: CircularProgressIndicator());
            },
          );
  }
  formItemsDesign(icon, item, large,ancho) {
   return Padding(
     padding: EdgeInsets.symmetric(vertical: 3),
     child: Container(child: Card(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),elevation: 10,child: ListTile(leading: Icon(icon), title: item)), width: large,height: ancho,),
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

  _saveEstatus(BuildContext context) async{
    if (estatusCtrl.text.trim() == "" || estatusCtrl.text.trim() == null) {
      _msgSnackBar('El campo esta vacío',Color(0x64E032));
    }else{
      Map <String,String> json = {
       "descripcion":estatusCtrl.text
      };
      //json.
      bool response = await api.createEstatus(json,context);
      if (response) {
        //_mySelection = "0";
        _msgSnackBar('Estatus agregado',Colors.green[300]);
        //_listaGrupos();
      } else {
        _msgSnackBar('Error no se pudo agregar el estatus',Colors.red[300]);
        print('error');
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: SingleChildScrollView(
                      child: Container(
        width: double.infinity,
        //height: 936.0,
        child: Column(
            children: [
              SizedBox(height: 50.0,),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.all(15),
                child: 
                      formItemsDesign(null,Row(
                        children: [
                          Expanded(
                                                      child: TextFormField(
                                  controller: estatusCtrl,
                                  decoration: new InputDecoration(
                                    labelText: 'Estatus',
                                  ),
                                  //initialValue: invitado.nombre,
                                  //validator: validateNombre,
                                ),
                          ),
                              Expanded(
                                                              child: GestureDetector(
                            child: Container(
                                margin: const EdgeInsets.all(15),
                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 12),
                                child: FittedBox(
                                        child: Text(
                                    "Agregar",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w100,
                                      color: Colors.white
                                    ),
                                  ),
                                ),
                                decoration: BoxDecoration(color: hexToColor('#880B55'),
                                borderRadius: BorderRadius.circular(5),),
                            ),
                            onTap: (){_saveEstatus(context);},
                          ),
                              ),
                        ],
                      ),570.0,80.0),
                      
                    
              ),
              
              Center(
                child:Container(
                  height: 400.0,
                  width: 600.0,
                  child: listaEstatusInvitaciones(context),
                ),
                  
              ),
            ],
        ),
      ),
          ),
    );
  }
  Widget buildList(AsyncSnapshot<ItemModelEstatusInvitado> snapshot) {
    return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          PaginatedDataTable(
            header: Center(child: Text('Lista de los estatus')),
            rowsPerPage: 3,
            showCheckboxColumn: false,
            columns: [
              DataColumn(label: Text('Descripción del estatus', style:estiloTxt)),
            ],
            
            source: _DataSource(snapshot.data.results,context,idPlanner),
          ),
        ],
      );
  }
  
}
class _Row {
  _Row(
    this.valueId,
    this.valueA,
  );
  final int valueId;
  final String valueA;

  bool selected = false;
}

class _DataSource extends DataTableSource {
  BuildContext _cont;
  final int idPlanner;
  GlobalKey<FormState> keyForm = new GlobalKey();
  TextEditingController  estatusCtrl = new TextEditingController();
  ApiProvider api = new ApiProvider();
  _DataSource(context,BuildContext cont, this.idPlanner) {
    _rows = <_Row>[];
    for (int i = 0; i < context.length; i++) {
      _rows.add(_Row(context[i].idEstatusInvitado,context[i].descripcion));  
    }
    _cont=cont;
  }
  Future<void> _showMyDialogEditar(int idEstatus, String estatus) async {
  estatusCtrl.text = estatus;
  return showDialog<void>(
    context: _cont,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Editar estatus', textAlign: TextAlign.center),
        content: //SingleChildScrollView(
          //child: 
          Form(
            key: keyForm,
            child: 
            //ListBody(
              //children: <Widget>[
                  
                TextFormField(
                  controller: estatusCtrl,
                  decoration: new InputDecoration(
                    labelText: 'Estatus',
                  ),
                  validator: validateEstatus,
                ),
                
                /*SizedBox(
                  height: 30,
                ),

                GestureDetector(
                        onTap: (){
                          _saveEstatus(context, idEstatus);
                          //print('guardado');
                        },
                        child: CallToAction('Agregar'),
                      ),*/
              //],
            //),
          ),
        //),
        actions: <Widget>[
          TextButton(
            child: Text('Editar'),
            onPressed: () async{
              await _saveEstatus(context, idEstatus);
              //Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Eliminar'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Cancelar'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
String validateEstatus(String value) {
   String pattern = r"[a-zA-ZñÑáéíóúÁÉÍÓÚ\s]+";
   RegExp regExp = new RegExp(pattern);
   if (value.length == 0) {
     return "El estatus es necesario";
   } else if (!regExp.hasMatch(value)) {
     return "El estatus debe de ser a-z y A-Z";
   }
   return null;
 }
 _saveEstatus(BuildContext context, int idEstatus) async{
    if (keyForm.currentState.validate()) {
      Map <String,String> json = {
       "descripcion":estatusCtrl.text,
       "id_estatus_invitado":idEstatus.toString()
      };
      //json.
      bool response = await api.updateEstatus(json,context);
      if (response) {
        //_mySelection = "0";
        Navigator.of(context).pop();
        _msgSnackBar('Estatus actualizado',Colors.green[300]);
        //_listaGrupos();
      } else {
        _msgSnackBar('Estatus actualizado',Colors.red[300]);
      }
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
    ScaffoldMessenger.of(_cont).showSnackBar(snackBar);
  }

  
  

  List<_Row> _rows;

  int _selectedCount = 0;
  
  @override
  DataRow getRow(int index) {
    assert(index >= 0);
    if (index >= _rows.length) return null;
    final row = _rows[index];
    return DataRow.byIndex(
      index: index,
      selected: row.selected,
      
      onSelectChanged: (value) {
        if (row.selected != value) {
          print(value);
          _selectedCount += value ? 1 : -1;
          assert(_selectedCount >= 0);
          row.selected = value;
          
          //notifyListeners();
        }
      },
      cells: [
        //DataCell(Text(row.valueId.toString())),
        DataCell(Text(row.valueA), onTap: ()async{await _showMyDialogEditar(row.valueId, row.valueA);}),
        //DataCell(Icon(Icons.edit)),
        //DataCell(Icon(Icons.delete)),
      ],
    );
  }

  @override
  int get rowCount => _rows.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedCount;
}
