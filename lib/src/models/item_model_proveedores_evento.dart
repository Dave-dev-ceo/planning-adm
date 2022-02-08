import 'package:planning/src/models/item_model_proveedores.dart';

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
  int _idServicio;
  int _idProveedor;
  int _idPlanner;
  String _nombre;
  List _prov;
  //
  bool _seleccion;
  String _observacion;

  ProveedoresEvento(datos) {
    _idServicio = datos['id_servicio'];
    _idPlanner = datos['id_planner'];
    _nombre = datos['nombre'];
    _prov = datos['prov'];
    //
    _seleccion = datos['seleccionado'];
    _observacion = datos['observacion'];
  }

  int get idServicio => _idServicio;
  int get idProveedor => _idProveedor;
  int get idPlanner => _idPlanner;
  String get nombre => _nombre;
  List get prov => _prov;
  //
  String get observacion => _observacion;
  bool get seleccion => _seleccion;
}

class ItemProveedorEvento {
  ItemProveedorEvento(
      {this.idServicio,
      this.idPlanner,
      this.nombre,
      this.prov,
      this.isExpanded = true,
      this.seleccion,
      this.observacion});
  int idServicio;
  int idPlanner;
  String nombre;
  List<ItemProveedor> prov;
  bool isExpanded;
  //
  bool seleccion;
  String observacion;
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
  int _idPlanner;
  int _idServicio;
  int _idProveedor;
  //
  bool _seleccionado;
  String _observacion;

  ProveedoresEvent(datos) {
    _idPlanner = datos['id_planner'];
    _idServicio = datos['id_servicio'];
    _idProveedor = datos['id_proveedor'];
    //
    _seleccionado = datos['seleccionado'];
    _observacion = datos['observacion'];
  }

  int get idPlanner => _idPlanner;
  int get idServicio => _idServicio;
  int get idProveedor => _idProveedor;
  //
  bool get seleccionado => _seleccionado;
  String get observacion => _observacion;
}
