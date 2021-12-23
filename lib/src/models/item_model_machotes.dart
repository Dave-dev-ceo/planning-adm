class ItemModelMachotes {
  List<Machotes> _results = [];

  ItemModelMachotes.fromJson(List<dynamic> parsedJson) {
    List<Machotes> temp = [];
    /*Machotes dat = Machotes({"id_estatus_invitado":0, "descripcion":"Sin estatus"});
    temp.add(dat);*/
    for (int i = 0; i < parsedJson.length; i++) {
      Machotes result = Machotes(parsedJson[i]);
      temp.add(result);
    }
    _results = temp;
  }
  List<Machotes> get results => _results;
}

class Machotes {
  String _clave;
  String _descripcion;
  String _machote;
  int _idMachote;

  Machotes(datos) {
    _clave = datos['clave_plantilla'];
    _descripcion = datos['descripcion'];
    _idMachote = datos['id_machote'];
    _machote = datos['machote'];
  }
  set addDescripcion(String data) {
    _descripcion = data;
  }

  set addMachote(String data) {
    _machote = data;
  }

  String get clave => _clave;
  String get descripcion => _descripcion;
  String get machote => _machote;
  int get idMachote => _idMachote;
}
