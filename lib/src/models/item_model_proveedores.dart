import 'package:flutter/foundation.dart';
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
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
  List<ProveedoresModel> get results => _results;
}

class ProveedoresModel {
  int? _idProveedor;
  int? _idServicio;
  String? _nombre;
  String? _descripcion;
  String? _estatus;
  String? _telefono;
  String? _direccion;
  String? _correo;
  int? _idCiudad;
  int? _idEstado;
  int? _idPais;

  ProveedoresModel(datos) {
    _idProveedor = datos['id_proveedor'];
    _idServicio = datos['id_servicio'];
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
  int? get idProveedor => _idProveedor;
  int? get idServicio => _idServicio;
  String? get nombre => _nombre;
  String? get descripcion => _descripcion;
  String? get estatus => _estatus;
  String? get telefono => _telefono;
  String? get direccion => _direccion;
  String? get correo => _correo;
  int? get idCiudad => _idCiudad;
  int? get idEstado => _idEstado;
  int? get idPais => _idPais;
}

class ItemProveedor {
  ItemProveedor({
    this.idProveedor,
    this.idServicio,
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
  int? idProveedor;
  int? idServicio;
  String? nombre;
  String? descripcion;
  List<ServiciosModel>? servicio;
  bool? isExpanded;
  bool? seleccion;
  String? observacion;
  String? estatus;
  String? telefono;
  String? direccion;
  String? correo;
  int? idCiudad;
  int? idEstado;
  int? idPais;
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
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
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
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
  List<ServicioByProvModel> get results => _results;
}

class ServicioByProvModel {
  int? _idProveedor;
  int? _idServicio;
  String? _nombre;

  ServicioByProvModel(datos) {
    _idProveedor = datos['id_proveedor'];
    _idServicio = datos['id_servicio'];
    _nombre = datos['nombre'];
  }
  int? get idProveedor => _idProveedor;
  int? get idServicio => _idServicio;
  String? get nombre => _nombre;
}
