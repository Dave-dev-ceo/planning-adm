import 'package:weddingplanner/src/models/item_model_servicios.dart';

class ItemModelProveedores {
  List<ProveedoresModel> _results = [];
  ItemModelProveedores.fromJson(List<dynamic> parsedJson) {
    try {
      List<ProveedoresModel> temp = [];
      for (int i = 0; i < parsedJson.length; i++) {
        ProveedoresModel result = ProveedoresModel(parsedJson[i]);
        temp.add(result);
      }
      _results = temp;
    } catch (e) {}
  }
  List<ProveedoresModel> get results => _results;
}

class ProveedoresModel {
  int _id_proveedor;
  String _nombre;
  String _descripcion;

  ProveedoresModel(datos) {
    _id_proveedor = datos['id_proveedor'];
    _nombre = datos['nombre'];
    _descripcion = datos['descripcion'];
  }
  int get id_proveedor => _id_proveedor;
  String get nombre => _nombre;
  String get descripcion => _descripcion;
}

class ItemProveedor {
  ItemProveedor(
      {this.id_proveedor,
      this.nombre,
      this.descripcion,
      this.servicio,
      this.isExpanded = false,
      this.seleccion,
      this.observacion});
  int id_proveedor;
  String nombre;
  String descripcion;
  List<ServiciosModel> servicio;
  bool isExpanded;
  bool seleccion;
  String observacion;
}

class ItemProveedorServicio {
  List<ItemProveedor> _results = [];
  ItemProveedorServicio.fromJson(List<dynamic> parsedJson) {
    try {
      List<ItemProveedor> temp = [];
      for (int i = 0; i < parsedJson.length; i++) {
        ItemProveedor result = ItemProveedor();
        temp.add(result);
      }
      _results = temp;
    } catch (e) {}
  }
  List<ItemProveedor> get results => _results;
}

class ItemModelServicioByProv {
  List<ServicioByProvModel> _results = [];
  ItemModelServicioByProv.fromJson(List<dynamic> parsedJson) {
    try {
      List<ServicioByProvModel> temp = [];
      for (int i = 0; i < parsedJson.length; i++) {
        ServicioByProvModel result = ServicioByProvModel(parsedJson[i]);
        temp.add(result);
      }
      _results = temp;
    } catch (e) {}
  }
  List<ServicioByProvModel> get results => _results;
}

class ServicioByProvModel {
  int _id_proveedor;
  int _id_servicio;
  String _nombre;

  ServicioByProvModel(datos) {
    _id_proveedor = datos['id_proveedor'];
    _id_servicio = datos['id_servicio'];
    _nombre = datos['nombre'];
  }
  int get id_proveedor => _id_proveedor;
  int get id_servicio => _id_servicio;
  String get nombre => _nombre;
}
