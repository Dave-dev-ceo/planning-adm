import 'package:flutter/material.dart';
import 'package:weddingplanner/src/ui/planners/agregar_planner.dart';

class FullScreenDialogAddPlanners extends StatefulWidget {
  const FullScreenDialogAddPlanners({Key key}) : super(key: key);
  @override
  _FullScreenDialogAddPlannersState createState() =>
      _FullScreenDialogAddPlannersState();
}

class _FullScreenDialogAddPlannersState
    extends State<FullScreenDialogAddPlanners> {
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
        title: Text('Agregar Planner'),
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
            AgregarPlanners(),
        //CargarExcel(id: id,),
        //],
      ),
      // ),

      //),
    );
  }
}
