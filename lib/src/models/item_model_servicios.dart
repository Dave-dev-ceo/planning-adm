class ItemModuleServicios {
  List<_Servicios> _results = [];
  ItemModuleServicios.fromJson(List<dynamic> parsedJson) {
    List<_Servicios> temp = [];
    for (int i = 0; i < parsedJson.length; i++) {
      _Servicios result = _Servicios(parsedJson[i]);
      //print(parsedJson[i]);
      temp.add(result);
    }
    _results = temp;
  }
  List<_Servicios> get results => _results;
}

class _Servicios {
  int _id_servicio;
  String _nombre;

  _Servicios(datos) {
    _id_servicio = datos['id_servicio'];
    _nombre = datos['nombre'];
  }
  int get id_servicio => _id_servicio;
  String get nombre => _nombre;
}

class ServiciosModel {
  int id_servicio;
  String nombre;

  ServiciosModel({this.id_servicio, this.nombre}) {}
}
