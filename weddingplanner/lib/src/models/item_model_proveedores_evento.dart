import 'package:weddingplanner/src/models/item_model_proveedores.dart';

class ItemModelProveedoresEvento {
  List<ProveedoresEvento> _results = [];

  ItemModelProveedoresEvento.fromJson(List<dynamic> parsedJson) {
    List<ProveedoresEvento> temp = [];
    for (int i = 0; i < parsedJson.length; i++) {
      ProveedoresEvento result = ProveedoresEvento(parsedJson[i]);
      temp.add(result);
    }
    _results = temp;
  }

  List<ProveedoresEvento> get results => _results;
}

class ProveedoresEvento {
  int _id_servicio;
  int _id_proveedor;
  int _id_planner;
  String _nombre;
  List _prov;

  ProveedoresEvento(datos) {
    _id_servicio = datos['id_servicio'];
    _id_planner = datos['id_planner'];
    _nombre = datos['nombre'];
    _prov = datos['prov'];
  }

  int get idServicio => _id_servicio;
  int get idProveedor => _id_proveedor;
  int get idPlanner => _id_planner;
  String get nombre => _nombre;
  List get prov => _prov;
}

class ItemProveedorEvento {
  ItemProveedorEvento(
      {this.id_servicio,
      this.id_planner,
      this.nombre,
      this.prov,
      this.isExpanded = true});
  int id_servicio;
  int id_planner;
  String nombre;
  List<ItemProveedor> prov;
  bool isExpanded;
}

class ItemModelProveedoresEvent {
  List<ProveedoresEvent> _results = [];

  ItemModelProveedoresEvent.fromJson(List<dynamic> parsedJson) {
    List<ProveedoresEvent> temp = [];
    for (int i = 0; i < parsedJson.length; i++) {
      ProveedoresEvent result = ProveedoresEvent(parsedJson[i]);
      temp.add(result);
    }
    _results = temp;
  }

  List<ProveedoresEvent> get results => _results;
}

class ProveedoresEvent {
  int _id_planner;
  int _id_servicio;
  int _id_proveedor;
  String _seleccionado;
  String _observacion;

  ProveedoresEvent(datos) {
    _id_planner = datos['id_planner'];
    _id_servicio = datos['id_servicio'];
    _id_proveedor = datos['id_proveedor'];
    _observacion = datos['seleccionado'];
    _observacion = datos['observacion'];
  }

  int get idPlanner => _id_planner;
  int get idServicio => _id_servicio;
  int get idProveedor => _id_proveedor;
  String get nombre => _seleccionado;
  String get prov => _observacion;
}
