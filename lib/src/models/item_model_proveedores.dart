import 'package:planning/src/models/item_model_servicios.dart';

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
  int _id_servicio;
  String _nombre;
  String _descripcion;
  String _estatus;
  String _telefono;
  String _direccion;
  String _correo;
  int _idCiudad;
  int _idEstado;
  int _idPais;

  ProveedoresModel(datos) {
    _id_proveedor = datos['id_proveedor'];
    _id_servicio = datos['id_servicio'];
    _nombre = datos['nombre'];
    _descripcion = datos['descripcion'];
    _estatus = datos['estatus'];
    _telefono = datos['telefono'];
    _direccion = datos['direccion'];
    _correo = datos['correo'];
    _idCiudad = datos['id_ciudad'];
    _idEstado = datos['id_estado'];
    _idPais = datos['id_pais'];
  }
  int get id_proveedor => _id_proveedor;
  int get id_servicio => _id_servicio;
  String get nombre => _nombre;
  String get descripcion => _descripcion;
  String get estatus => _estatus;
  String get telefono => _telefono;
  String get direccion => _direccion;
  String get correo => _correo;
  int get idCiudad => _idCiudad;
  int get idEstado => _idEstado;
  int get idPais => _idPais;
}

class ItemProveedor {
  ItemProveedor({
    this.id_proveedor,
    this.id_servicio,
    this.nombre,
    this.descripcion,
    this.servicio,
    this.isExpanded = false,
    this.seleccion,
    this.observacion,
    this.estatus,
    this.correo,
    this.direccion,
    this.telefono,
    this.idCiudad,
    this.idEstado,
    this.idPais,
  });
  int id_proveedor;
  int id_servicio;
  String nombre;
  String descripcion;
  List<ServiciosModel> servicio;
  bool isExpanded;
  bool seleccion;
  String observacion;
  String estatus;
  String telefono;
  String direccion;
  String correo;
  int idCiudad;
  int idEstado;
  int idPais;
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
