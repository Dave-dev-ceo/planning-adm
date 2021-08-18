import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weddingplanner/src/blocs/proveedorEvento/proveedoreventos_bloc.dart';
import 'package:weddingplanner/src/models/item_model_proveedores.dart';
import 'package:weddingplanner/src/models/item_model_proveedores_evento.dart';

class ProveedorEvento extends StatefulWidget {
  const ProveedorEvento({Key key}) : super(key: key);
  static Route<dynamic> route() => MaterialPageRoute(
        builder: (context) => ProveedorEvento(),
      );
  @override
  _ProveedorEventoState createState() => _ProveedorEventoState();
}

class _ProveedorEventoState extends State<ProveedorEvento> {
  ProveedoreventosBloc proveedoreventosBloc;

  List<ItemProveedorEvento> _dataPrvEv = [];

  ItemModelProveedoresEvent provEvet;

  @override
  void initState() {
    proveedoreventosBloc = BlocProvider.of<ProveedoreventosBloc>(context);
    proveedoreventosBloc.add(FechtProveedorEventosEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(15),
        child: BlocBuilder<ProveedoreventosBloc, ProveedoreventosState>(
            builder: (context, state) {
          if (state is MostrarProveedorEventoState) {
            if (state.detlistas != null && _dataPrvEv.length == 0) {
              _dataPrvEv = _createDataListProvEvt(state.detlistas);
            }
            return _listaBuild();
          } else {
            return Center(child: CircularProgressIndicator());
          }
        }),
      ),
    ));
  }

  Widget _listaBuild() {
    return Container(
        child: ExpansionPanelList(
      animationDuration: Duration(milliseconds: 500),
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _dataPrvEv[index].isExpanded = !isExpanded;
        });
      },
      children: _dataPrvEv.map<ExpansionPanel>((ItemProveedorEvento item) {
        return ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: Text(item.nombre),
              trailing: Wrap(spacing: 12, children: <Widget>[]),
            );
          },
          body: Column(children: _listServicio(item.prov, item.id_servicio)),
          isExpanded: item.isExpanded,
        );
      }).toList(),
    ));
  }

  _createDataListProvEvt(ItemModelProveedoresEvento prov) {
    List<ItemProveedorEvento> _dataProv = [];
    prov.results.forEach((element) {
      List<ItemProveedor> _provTemp = [];
      if (element.prov.length > 0) {
        element.prov.forEach((element) {
          _provTemp.add(ItemProveedor(
              id_proveedor: element['id_proveedor'],
              nombre: element['nombre'],
              descripcion: element['descripcion'],
              isExpanded: element['check']));
        });
      }
      _dataProv.add(ItemProveedorEvento(
          id_servicio: element.idServicio,
          id_planner: element.idPlanner,
          nombre: element.nombre,
          prov: _provTemp,
          isExpanded: false));
    });
    return _dataProv;
  }

  List<Widget> _listServicio(List<ItemProveedor> itemServicio, int idServi) {
    List<Widget> lista = [];
    for (var opt in itemServicio) {
      final tempWidget = ListTile(
          title: Text(opt.nombre),
          subtitle: Text(opt.descripcion),
          trailing: Wrap(
            spacing: 12,
            children: <Widget>[
              Text('Seleccionado: No'),
              Text('Observaciónes: '),
              Checkbox(
                checkColor: Colors.white,
                value: opt.isExpanded,
                onChanged: (value) {
                  setState(() {
                    opt.isExpanded = value;
                  });
                  print(opt.isExpanded);
                  Map<String, dynamic> json = {
                    'id_servicio': idServi,
                    'id_proveedor': opt.id_proveedor
                  };
                  if (opt.isExpanded) {
                    proveedoreventosBloc.add(CreateProveedorEventosEvent(json));
                  } else if (!opt.isExpanded) {
                    proveedoreventosBloc.add(DeleteProveedorEventosEvent(json));
                  }
                },
              ),
            ],
          ));
      lista.add(tempWidget);
    }
    return lista;
  }

  insert(opt) {
    print('object');
    proveedoreventosBloc.add(CreateProveedorEventosEvent(
        {'id_servicio': opt.id_servicio, 'id_proveedor': opt.id_proveedor}));
  }

  _eliminarDetalleLista() {}
}
