class ItemModelEstatusInvitado {
  
  List<Estatus> _results = [];

  ItemModelEstatusInvitado.fromJson(List<dynamic> parsedJson){
    List<Estatus> temp = [];
    Estatus dat = Estatus({"id_estatus_invitado":0, "descripcion":"Sin estatus"});
    temp.add(dat);
    for (int i = 0; i < parsedJson.length; i++) {
      Estatus result = Estatus(parsedJson[i]);
      //print(parsedJson[i]);
      temp.add(result);
    }
    _results = temp;
  }
  List<Estatus> get results => _results;
}

class Estatus {
  String _descripcion;
  int _idEstatusInvitado;

  Estatus(datos){
    _descripcion = datos['descripcion'];
    _idEstatusInvitado = datos['id_estatus_invitado'];
  }
  set addDescripcion(String data){
    _descripcion = data;
  }
  String get descripcion =>_descripcion;
  int get idEstatusInvitado =>_idEstatusInvitado;
}