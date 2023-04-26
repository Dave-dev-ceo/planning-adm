class ItemModelGrupos {
  List<_Grupos> _results = [];

  ItemModelGrupos.fromJson(List<dynamic> parsedJson) {
    List<_Grupos> temp = [];
    _Grupos dat = _Grupos({"id_grupo": 0, "nombre_grupo": "Sin grupo"});
    temp.add(dat);
    for (int i = 0; i < parsedJson.length; i++) {
      _Grupos result = _Grupos(parsedJson[i]);

      temp.add(result);
    }
    dat = _Grupos(
        {"id_grupo": parsedJson.length + 1, "nombre_grupo": "Nuevo grupo"});
    temp.add(dat);
    _results = temp;
  }

  List<_Grupos> get results => _results;
}

class _Grupos {
  String? _nombreGrupo;
  int? _idGrupo;
  bool? seleted;

  _Grupos(datos, {this.seleted = false}) {
    _nombreGrupo = datos['nombre_grupo'];
    _idGrupo = datos['id_grupo'];
  }

  String? get nombreGrupo => _nombreGrupo;

  int? get idGrupo => _idGrupo;

  set nombreGrupo(String? value) => _nombreGrupo = value;
}
