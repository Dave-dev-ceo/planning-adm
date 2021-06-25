class ItemModelPublicaciones {
  List<Publicaciones> _results = [];

  ItemModelPublicaciones.fromJson(List<dynamic> parsedJson) {
    List<Publicaciones> temp = [];
    for (int i = 0; i < parsedJson.length; i++) {
      Publicaciones result = Publicaciones(parsedJson[i]);
      temp.add(result);
    }
    _results = temp;
  }
  List<Publicaciones> get results => _results;
}

class Publicaciones {
  int _idPublicacion;
  String _titulo;
  String _informacion;
  String _claveTipoPublicacion;
  String _imagen;



  Publicaciones(datos) {
    _idPublicacion = datos['id_publicacion'];
    _titulo = datos['titulo'];
    _informacion = datos['informacion'];
    _claveTipoPublicacion = datos['clave_tipo_publicacion'];
    _imagen = datos['imagen'];
  }
  String get imagen => _imagen;
  String get claveTipoPublicacion => _claveTipoPublicacion;
  String get informacion => _informacion;
  String get titulo => _titulo;
  int get idPublicacion => _idPublicacion;
}
