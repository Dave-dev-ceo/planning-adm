import 'package:planning/src/models/item_model_proveedores.dart';

class ItemModuleServicios {
  List<_Servicios> _results = [];
  ItemModuleServicios.fromJson(List<dynamic> parsedJson) {
    List<_Servicios> temp = [];
    for (int i = 0; i < parsedJson.length; i++) {
      _Servicios result = _Servicios(parsedJson[i]);
      temp.add(result);
    }
    _results = temp;
  }
  List<_Servicios> get results => _results;
}

class _Servicios {
  int _id_servicio;
  int _id_proveedor;
  String _nombre;

  _Servicios(datos) {
    _id_servicio = datos['id_servicio'];
    _id_proveedor = datos['id_proveedor'];
    _nombre = datos['nombre'];
  }
  int get id_servicio => _id_servicio;
  int get id_proveedor => _id_proveedor;
  String get nombre => _nombre;
}

class ServiciosModel {
  ServiciosModel(
      {this.id_servicio,
      this.id_proveedor,
      this.nombre,
      this.isExpanded = false,
      this.proveedores});

  int id_servicio;
  int id_proveedor;
  String nombre;
  bool isExpanded;
  List<ItemProveedor> proveedores;
}
