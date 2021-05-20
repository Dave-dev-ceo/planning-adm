class ItemModelEstatusInvitado {
  
  List<_Estatus> _results = [];

  ItemModelEstatusInvitado.fromJson(List<dynamic> parsedJson){
    List<_Estatus> temp = [];
    _Estatus dat = _Estatus({"id_estatus_invitado":0, "descripcion":"Sin estatus"});
    temp.add(dat);
    for (int i = 0; i < parsedJson.length; i++) {
      _Estatus result = _Estatus(parsedJson[i]);
      //print(parsedJson[i]);
      temp.add(result);
    }
    _results = temp;
  }
  List<_Estatus> get results => _results;
}

class _Estatus {
  String _descripcion;
  int _idEstatusInvitado;

  _Estatus(datos){
    _descripcion = datos['descripcion'];
    _idEstatusInvitado = datos['id_estatus_invitado'];
  }

  String get descripcion =>_descripcion;
  int get idEstatusInvitado =>_idEstatusInvitado;
}