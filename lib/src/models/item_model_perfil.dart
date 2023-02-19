class ItemModelPerfil {
  List<_Perfil> _perfil = []; // lista

  // constructor
  ItemModelPerfil(this._perfil);

  // llenamos la lista
  ItemModelPerfil.fromJson(List<dynamic> pardedJson) {
    List<_Perfil> temp = []; // lista temporal

    // extramos los datos | llenamos lista - metodo forEach
    for (var data in pardedJson) {
      temp.add(_Perfil(data));
    }

    _perfil = temp; // guardamos en la lista
  }

  // data que recuperamos
  List<_Perfil> get perfil => _perfil;
}

class _Perfil {
  // variables
  String? _nombreCompleto;
  String? _correo;
  String? _telefono;
  String? _imagen;

  // constructor
  _Perfil(consulta) {
    _nombreCompleto = consulta['nombre_completo'];
    _correo = consulta['correo'];
    _telefono = consulta['telefono'];
    _imagen = consulta['imagen'];
  }

  // ini getters
  String? get nombreCompleto => _nombreCompleto;
  String? get correo => _correo;
  String? get telefono => _telefono;
  String? get imagen => _imagen;
  // fin getters

  // ini setters
  set nombreCompleto(value) => _nombreCompleto;
  set correo(value) => _correo;
  set telefono(value) => _telefono;
  set imagen(value) => _imagen;
  // fin setters
}
