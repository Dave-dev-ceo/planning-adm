class ItemModelAutorizacion {
  List<_Autorizacion> _autorizacion = []; // lista

  // constructor
  ItemModelAutorizacion(this._autorizacion);

  // llenamos la lista
  ItemModelAutorizacion.fromJson(List<dynamic> pardedJson) {
    List<_Autorizacion> temp = []; // lista temporal

    // extramos los datos | llenamos lista - metodo forEach
    for (var data in pardedJson) {
      temp.add(_Autorizacion(data));
    }

    _autorizacion = temp; // guardamos en la lista
  }

  // data que recuperamos
  List<_Autorizacion> get autorizacion => _autorizacion;
}

class _Autorizacion {
  // variables
  int _idAutorizacion;
  String _descripcionAutorizacion;
  String _nombre;
  int _idEvidencia;
  String _archivo;
  String _comentario;

  // constructor
  _Autorizacion(consulta) {
    _idAutorizacion = consulta['id_autorizacion'];
    _descripcionAutorizacion = consulta['descripcion'];
    _nombre = consulta['nombre'];
    _idEvidencia = consulta['id_evidencia'];
    _archivo = consulta['archivo'];
    _comentario = consulta['comentario'];
  }

  // ini getters
  int get idAutorizacion => _idAutorizacion;
  String get descripcionAutorizacion => _descripcionAutorizacion;
  String get nombre => _nombre;
  int get idEvidencia => _idEvidencia;
  String get archivo => _archivo;
  String get comentario => _comentario;
  // fin getters

  // ini setters
  set idAutorizacion(value) => _idAutorizacion;
  set descripcionAutorizacion(value) => _descripcionAutorizacion;
  set nombre(value) => _nombre;
  set idEvidencia(value) => _idEvidencia;
  set archivo(value) => _archivo;
  set comentario(value) => _comentario;
  // fin setters
}
