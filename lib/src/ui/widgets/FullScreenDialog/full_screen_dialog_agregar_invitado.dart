import 'package:flutter/material.dart';
import 'package:planning/src/resources/api_provider.dart';
import 'package:planning/src/ui/widgets/invitados/agregar_invitado.dart';

class FullScreenDialogAdd extends StatefulWidget {
  final int id;

  const FullScreenDialogAdd({Key key, this.id}) : super(key: key);
  @override
  _FullScreenDialogAddState createState() => _FullScreenDialogAddState(id);
}

class _FullScreenDialogAddState extends State<FullScreenDialogAdd> {
  ApiProvider api = new ApiProvider();
  final int id;
  _FullScreenDialogAddState(this.id);

  @override
  void initState() {
    super.initState();
  }

  Color hexToColor(String code) {
    return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  @override
  Widget build(BuildContext context) {
    //return DefaultTabController(
    //length: 2,
    //child:
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar invitado'),
        backgroundColor: hexToColor('#fdf4e5'),
        actions: [],
        automaticallyImplyLeading: true,
        /*bottom: TabBar(
            onTap: (int index){
              setState(() {
                _pageIndex = index;  
              });
            },
            indicatorColor: Colors.white,
            //isScrollable: true,
            tabs: [
              Tab(
                icon: Icon(Icons.person_add_alt),
                //text: 'Resumen',
                child: Text('Agregar invitado', style: TextStyle(fontSize: 15),),
              ),
              Tab(
                icon: Icon(Icons.import_contacts),
                //text: 'Invitados',
                child: Text('Importar lista invitados', style: TextStyle(fontSize: 15),),
              ),
            ],
          ),*/
      ),
      body: SafeArea(
        child:
            //IndexedStack(
            //index: _pageIndex,
            //children: <Widget>[
            AgregarInvitados(
          id: id,
        ),
        //CargarExcel(id: id,),
        //],
      ),
      // ),

      //),
    );
  }
}