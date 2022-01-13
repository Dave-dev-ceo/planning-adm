// imports flutter/dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planning/src/animations/loading_animation.dart';
import 'package:planning/src/blocs/contratos/bloc/add_contratos_bloc.dart';
import 'package:planning/src/blocs/contratos/bloc/contratos_bloc.dart';
import 'package:planning/src/blocs/contratos/contratos_bloc.dart' as verlitener;

class AddMachote extends StatefulWidget {
  final Map map;
  AddMachote({Key key, @required this.map}) : super(key: key);

  @override
  _AddMachoteState createState() => _AddMachoteState();
}

class _AddMachoteState extends State<AddMachote> {
  // variables bloc
  AddContratosBloc addContratosBloc;
  verlitener.ContratosBloc contratosBloc;
  ContratosDosBloc beforeBloc;

  // variables model
  List<Contratos> itemModel = [];

  // variables
  BuildContext _ingresando;

  @override
  void initState() {
    super.initState();
    addContratosBloc = BlocProvider.of<AddContratosBloc>(context);
    addContratosBloc.add(AddContratosSelect());
    contratosBloc = BlocProvider.of<verlitener.ContratosBloc>(context);
    beforeBloc = BlocProvider.of<ContratosDosBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        beforeBloc.add(ContratosSelect());
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: _giveTitle(widget.map['clave']),
        ),
        body: _myBloc(),
      ),
    );
  }

  // titulos
  _giveTitle(String clave) {
    switch (clave) {
      case 'CT':
        return Text('Selecciona Contratos');
      case 'RC':
        return Text('Selecciona Recibos');
      case 'PG':
        return Text('Selecciona Pagos');
      case 'MT':
        return Text('Selecciona Minutas');
      case 'OP':
        return Text('Selecciona Orden de Pedido');
      default:
        return Text('Selecciona Autorizaciones');
    }
  }

  // BLoC
  _myBloc() {
    return BlocListener<verlitener.ContratosBloc, verlitener.ContratosState>(
        listener: (context, state) {
      if (state is verlitener.LoadingContratosPdfViewState) {
        return _dialogMSG('Espere un momento');
      } else if (state is verlitener.MostrarContratosPdfViewState) {
        Navigator.pop(_ingresando);
        Navigator.pushNamed(context, '/viewContrato',
            arguments: state.contratos);
      }
    }, child: BlocBuilder<AddContratosBloc, AddContratosState>(
      builder: (context, state) {
        if (state is AddContratosInitialState) {
          return Center(
            child: LoadingCustom(),
          );
        } else if (state is AddContratosLoggingState) {
          return Center(
            child: LoadingCustom(),
          );
        } else if (state is SelectAddContratosState) {
          if (itemModel.length == 0) {
            itemModel = state.contratos.contrato.map((item) {
              return Contratos(
                  idContrato: item.idMachote,
                  description: item.descripcion,
                  clave: item.clavePlantilla,
                  archivo: item.machote,
                  valida: false,
                  newTitulo: '');
            }).toList();
          } else if (itemModel.length != state.contratos.contrato.length) {
            itemModel = state.contratos.contrato.map((item) {
              return Contratos(
                  idContrato: item.idMachote,
                  description: item.descripcion,
                  clave: item.clavePlantilla,
                  archivo: item.machote,
                  valida: false,
                  newTitulo: '');
            }).toList();
          }
          return Container(
            child: _generaContratos(
                itemModel, widget.map['clave'], widget.map['clave_t']),
          );
        } else if (state is InsertAddContratosState) {
          return Container(
            child: _generaContratos(
                itemModel, widget.map['clave'], widget.map['clave_t']),
          );
        } else {
          return Center(child: Text('Sin datos'));
        }
      },
    ));
  }

  // genera cards
  _generaContratos(List<Contratos> contratos, String clave, String clave_t) {
    List<Widget> listContrato = [];
    if (contratos.length > 0) {
      contratos.forEach((data) {
        if (data.clave == clave || data.clave == clave_t) {
          listContrato.add(Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: EdgeInsets.all(20),
            elevation: 10,
            child: ListTile(
                contentPadding: EdgeInsets.all(20.0),
                leading: Checkbox(
                    value: data.valida,
                    onChanged: (valor) => setState(() => data.valida = valor)),
                title: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(data.description),
                          TextButton.icon(
                            icon: Icon(Icons.remove_red_eye_rounded),
                            label: Text('Ver'),
                            onPressed: () => _verFile(data.archivo),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                        child: data.valida
                            ? TextFormField(
                                decoration: InputDecoration(
                                    icon: Icon(Icons.description),
                                    hintText: 'Titulo:'),
                                onChanged: (valor) => data.newTitulo = valor,
                              )
                            : SizedBox())
                  ],
                ),
                trailing: data.valida
                    ? TextButton.icon(
                        icon: Icon(Icons.save),
                        label: Text(''),
                        onPressed: () => _addContrato(data.idContrato,
                            data.newTitulo, data.archivo, data.clave),
                      )
                    : SizedBox()),
          ));
        }
      });
      if (listContrato.length > 0) {
        return ListView(
          children: [
            Column(
              children: listContrato,
            )
          ],
        );
      } else {
        return Center(child: Text('Sin datos'));
      }
    } else {
      return Center(child: Text('No sean creado plantillas'));
    }
  }

  // evento - guarda
  _addContrato(int idContrato, String titulo, String archivo, String clave) {
    if (titulo.isNotEmpty) {
      _mensaje('Contrato agregado.');
      setState(() {
        // itemModel.removeWhere((item) => item.idContrato == idContrato);
        itemModel.forEach((element) {
          if (element.idContrato == idContrato) {
            element.valida = false;
          }
        });
      });
      addContratosBloc.add(AddContratosInsert({
        'id_machote': idContrato.toString(),
        'titulo': titulo,
        'archivo': archivo,
        'clave': clave,
        'tipo_doc': 'html',
        'tipo_mime': 'pdf'
      }));
    } else {
      _mensaje('Descripcion vacia.');
    }
  }

  // evento - muestra pdf
  _verFile(String archivo) {
    contratosBloc
        .add(verlitener.FechtContratosPdfViewEvent({'machote': archivo}));
  }

  // mensaje
  Future<void> _mensaje(String txt) async {
    return await ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(txt),
    ));
  }

  //
  _dialogMSG(String title) {
    Widget child = LoadingCustom();
    showDialog(
        context: context,
        //barrierDismissible: false,
        builder: (BuildContext context) {
          _ingresando = context;
          return AlertDialog(
            title: Text(
              title,
              textAlign: TextAlign.center,
            ),
            content: child,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
          );
        });
  }
}

class Contratos {
  int idContrato;
  String description;
  String clave;
  String archivo;
  bool valida;
  String newTitulo;

  Contratos({
    this.idContrato,
    this.description,
    this.clave,
    this.archivo,
    this.valida,
    this.newTitulo,
  });
}
