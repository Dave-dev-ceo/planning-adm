import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planning/src/blocs/contratos/contratos_bloc.dart';
import 'package:planning/src/models/item_model_contratos.dart';
import 'package:planning/src/ui/contratos/agregar_contrato.dart';
import 'package:planning/src/ui/contratos/agregar_contrato_mobile.dart';

class Contratos extends StatefulWidget {
  const Contratos({Key? key}) : super(key: key);

  @override
  State<Contratos> createState() => _ContratosState();
}

class _ContratosState extends State<Contratos> {
  late ContratosBloc contratosBloc;
  ItemModelContratos? itemModelC;

  TextEditingController? descripcionMachote;
  GlobalKey<FormState>? keyForm;

  @override
  void initState() {
    contratosBloc = BlocProvider.of<ContratosBloc>(context);
    contratosBloc.add(FechtContratosEvent());
    keyForm = GlobalKey();
    descripcionMachote = TextEditingController();
    super.initState();
  }

  /*_contectCont(String etiqueta) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.all(20),
      elevation: 10,
      child: Column(
        children: <Widget>[
          ListTile(
            contentPadding: EdgeInsets.fromLTRB(15, 10, 25, 0),
            title: Text(
              'Machote',
              style: TextStyle(fontSize: 20),
            ),
            subtitle: Container(
                height: 55,
                //color: Colors.yellowAccent,
                child: Text(etiqueta)),
            leading: Icon(Icons.event),
          ),
        ],
      ),
    );
  }*/

  /*_constructorLista(ItemModelContratos modelMC) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
      child: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          for (var i = 0; i < modelMC.results.length; i++)
            _contectCont(modelMC.results.elementAt(i).descripcion)
        ],
      ),
    );
  }*/

  String? validateDescripcion(String value) {
    String pattern = r"[a-zA-ZñÑáéíóúÁÉÍÓÚ\s]+";
    RegExp regExp = RegExp(pattern);
    if (value.isEmpty) {
      return "La descripción es necesaria";
    } else if (!regExp.hasMatch(value)) {
      return "La descripción debe de ser a-z y A-Z";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: kIsWeb ? AgregarContrato() : AgregarContratoMobile(),
      //  //  //  //  //  //  //// Descomentar siguiente linea para generar apk y comentar la de arriba //  //  //  //  //  //  ////  //  //  //  //  //  //  ////
      /*Container(
        child: BlocBuilder<ContratosBloc, ContratosState>(
          builder: (context, state) {
            if (state is LoadingContratosState) {
              return Center(child: LoadingCustom());
            } else if (state is MostrarContratosState) {
              itemModelC = state.contratos;
              return _constructorLista(state.contratos);
            } else if (state is ErrorListaContratosState) {
              return Center(
                child: Text(state.message),
              );
            } else {
              return Center(child: LoadingCustom());
              //return _constructorLista(itemModelET);
            }
          },
        ),
      ),*/
      /*floatingActionButton: FloatingActionButton(
        heroTag: null,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context)
              .pushNamed('/addContrato', arguments: descripcionMachote.text);
        },
      ),*/
    );
  }
}
