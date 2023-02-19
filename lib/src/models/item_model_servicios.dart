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
  int? _idServicio;
  int? _idProveedor;
  String? _nombre;

  _Servicios(datos) {
    _idServicio = datos['id_servicio'];
    _idProveedor = datos['id_proveedor'];
    _nombre = datos['nombre'];
  }
  int? get idServicio => _idServicio;
  int? get idProveedor => _idProveedor;
  String? get nombre => _nombre;
}

class ServiciosModel {
  ServiciosModel(
      {this.idServicio,
      this.idProveedor,
      this.nombre,
      this.isExpanded = false,
      this.proveedores});

  int? idServicio;
  int? idProveedor;
  String? nombre;
  bool isExpanded;
  List<ItemProveedor>? proveedores;
}
