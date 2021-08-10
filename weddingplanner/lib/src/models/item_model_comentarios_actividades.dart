class ItemModelComentarios {
  // nuestrs lista
  List<_Comentarios> _comentarios = [];

  // constructor
  ItemModelComentarios(this._comentarios);

  // metodo crea item
  ItemModelComentarios.fromJson(List<dynamic> pardedJson) {
    List<_Comentarios> temp = []; // variable temp para ir agregando

    // extraemos los datos - metodo forEach
    pardedJson.forEach((data) {
      temp.add(_Comentarios(data));
    });
    
    _comentarios = temp; // guardamos en variable
  }

  // no ocupo metodo copy/copyWith

  // data que recuperamos
  List<_Comentarios> get comentarios => _comentarios;
}
// objeto
class _Comentarios {
  // mis variables
  int _idComentario;
  String _comentarioActividad;
  bool _estadoComentario;
  int _idEventoActividad;

  // constructor
  _Comentarios(consulta) {
    _idComentario = consulta['id_comentario_actividad'];
    _comentarioActividad = consulta['comentario_actividad'];
    _estadoComentario = consulta['estatus'];
    _idEventoActividad = consulta['id_evento_actividad'];
  }

  // model
  // _Comentarios.fromModel(dataObj) {
  //   _idComentario = dataObj._idComentario;
  //   _comentarioActividad = dataObj._comentarioActividad;
  //   _estadoComentario = dataObj._estadoComentario;
  //   _idEventoActividad = dataObj._idEventoActividad;
  // }

  /// creamos getter
  int get idComentario => this._idComentario;
  String get comentarioActividad => this._comentarioActividad;
  bool get estadoComentario => this._estadoComentario;
  int get idEventoActividad => this._idEventoActividad;
  /// fin getter

  /// creamos setter
  set idComentario(value) => this._idComentario;
  set comentarioActividad(value) => this._comentarioActividad;
  set estadoComentario(value) => this._estadoComentario;
  set idEventoActividad(value) => this._idEventoActividad;
  /// fin setter

}