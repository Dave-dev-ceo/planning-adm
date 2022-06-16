// imports flutter/dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planning/src/animations/loading_animation.dart';
import 'package:planning/src/blocs/contratos/bloc/add_contratos_bloc.dart';
import 'package:planning/src/blocs/contratos/bloc/contratos_bloc.dart';
import 'package:planning/src/blocs/contratos/contratos_bloc.dart' as verlitener;
import 'package:planning/src/ui/widgets/snackbar_widget/snackbar_widget.dart';

class AddMachote extends StatefulWidget {
  final Map map;
  const AddMachote({Key key, @required this.map}) : super(key: key);

  @override
  State<AddMachote> createState() => _AddMachoteState();
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
        return const Text('Selecciona contratos');
      case 'RC':
        return const Text('Selecciona recibos');
      case 'PG':
        return const Text('Selecciona pagos');
      case 'MT':
        return const Text('Selecciona minutas');
      case 'OP':
        return const Text('Selecciona orden de pedido');
      default:
        return const Text('Selecciona autorizaciones');
    }
  }

  // BLoC
  Widget _myBloc() {
    return BlocListener<verlitener.ContratosBloc, verlitener.ContratosState>(
        // ignore: void_checks
        listener: (context, state) {
      if (state is verlitener.LoadingContratosPdfViewState) {
        return _dialogMSG('Espere un momento');
      } else if (state is verlitener.MostrarContratosPdfViewState) {
        Navigator.pop(_ingresando);
        Navigator.pushNamed(context, '/viewContrato', arguments: {
          'tipo_mime': 'pdf',
          'htmlPdf': state.contratos,
        });
      }
    }, child: BlocBuilder<AddContratosBloc, AddContratosState>(
      builder: (context, state) {
        if (state is AddContratosInitialState) {
          return const Center(
            child: LoadingCustom(),
          );
        } else if (state is AddContratosLoggingState) {
          return const Center(
            child: LoadingCustom(),
          );
        } else if (state is SelectAddContratosState) {
          if (itemModel.isEmpty) {
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
          return const Center(child: Text('Sin datos'));
        }
      },
    ));
  }

  // genera cards
  Widget _generaContratos(
      List<Contratos> contratos, String clave, String claveT) {
    List<Widget> listContrato = [];
    if (contratos.isNotEmpty) {
      for (var data in contratos) {
        if (data.clave == clave || data.clave == claveT) {
          listContrato.add(Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: const EdgeInsets.all(20),
            elevation: 10,
            child: ListTile(
                contentPadding: const EdgeInsets.all(20.0),
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
                            icon: const Icon(Icons.remove_red_eye_rounded),
                            label: const Text('Ver'),
                            onPressed: () =>
                                _verFile(data.archivo, data.idContrato),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                        child: data.valida
                            ? TextFormField(
                                decoration: const InputDecoration(
                                    icon: Icon(Icons.description),
                                    hintText: 'Titulo:'),
                                onChanged: (valor) => data.newTitulo = valor,
                              )
                            : const SizedBox())
                  ],
                ),
                trailing: data.valida
                    ? TextButton.icon(
                        icon: const Icon(Icons.save),
                        label: const Text(''),
                        onPressed: () => _addContrato(data.idContrato,
                            data.newTitulo, data.archivo, data.clave),
                      )
                    : const SizedBox()),
          ));
        }
      }
      if (listContrato.isNotEmpty) {
        return ListView(
          children: [
            Column(
              children: listContrato,
            )
          ],
        );
      } else {
        return const Center(child: Text('Sin datos'));
      }
    } else {
      return const Center(child: Text('No se han creado plantillas'));
    }
  }

  // evento - guarda
  _addContrato(int idContrato, String titulo, String archivo, String clave) {
    if (titulo.isNotEmpty) {
      MostrarAlerta(
          mensaje: 'Contrato agregado.', tipoMensaje: TipoMensaje.correcto);
      setState(() {
        // itemModel.removeWhere((item) => item.idContrato == idContrato);
        for (var element in itemModel) {
          if (element.idContrato == idContrato) {
            element.valida = false;
          }
        }
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
      MostrarAlerta(
          mensaje: 'Descripción vacía.', tipoMensaje: TipoMensaje.advertencia);
    }
  }

  // evento - muestra pdf
  _verFile(String archivo, int idContrato) {
    contratosBloc.add(verlitener.FechtContratosPdfViewEvent(
        {'machote': archivo, 'id_contrato': idContrato.toString()}));
  }

  //
  _dialogMSG(String title) {
    Widget child = const LoadingCustom();
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
            shape: const RoundedRectangleBorder(
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
