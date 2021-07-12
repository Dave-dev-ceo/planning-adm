class ItemModelEvento {
  List<Evento> _results = [];

  ItemModelEvento.fromJson(Map<dynamic, dynamic> parsedJson) {
    List<Evento> temp = [];
    for (int i = 0; i < parsedJson['evento'].length; i++) {
      Evento result = Evento(parsedJson['evento'][i]);
      temp.add(result);
    }
    _results = temp;
  }
  List<Evento> get results => _results;

  ItemModelEvento.fromJsonUnit(Map<dynamic, dynamic> parsedJson) {
    List<Evento> temp = [];
    Evento result = Evento(parsedJson);
    temp.add(result);
    _results = temp;
  }
}

class Evento {
  // Evento
  int _idEvento;
  String _fechaInicio;
  String _fechaFin;
  String _fechaEvento;
  String _evento;
  int _idTipoEvento;
  String _tipoEvento;
  // Contrato
  int _idContratante;
  String _nombrect;
  String _apelliosct;
  String _telefonoct;
  String _emailct;
  String _direccionct;
  String _estadoct;

  List<Involucrados> _involucrados = [];
  Evento(datos) {
    // Evento
    _idEvento = datos['id_evento'];
    _fechaInicio = datos['fecha_inicio'];
    _fechaFin = datos['fecha_fin'];
    _fechaEvento = datos['fecha_evento'];
    _evento = datos['evento'];
    _idTipoEvento = datos['id_tipo_evento'];
    _tipoEvento = datos['tipo_evento'];
    // Contratante
    _idContratante = datos['id_contratante'];
    _nombrect = datos['nombre_ct'];
    _apelliosct = datos['apellidos_ct'];
    _telefonoct = datos['telefono_ct'];
    _emailct = datos['email_ct'];
    _direccionct = datos['direccion_ct'];
    _estadoct = datos['estado_ct'];

    List<Involucrados> tempI = [];
    for (var i = 0; i < datos['involucrados'].length; i++) {
      Involucrados invo = Involucrados(datos['involucrados'][i]);
      tempI.add(invo);
    }
    _involucrados = tempI;
  }

  // Evento
  int get idEvento => _idEvento;
  String get fechaInicio => _fechaInicio;
  String get fechaFin => _fechaFin;
  String get fechaEvento => _fechaEvento;
  String get tipoEvento => _tipoEvento;
  String get evento => _evento;
  int get idTipoEvento => _idTipoEvento;
  // Contratante
  int get idContratante => _idContratante;
  String get nombrect => _nombrect;
  String get apellidoct => _apelliosct;
  String get telefonoct => _telefonoct;
  String get emailct => _emailct;
  String get direccionct => _direccionct;
  String get estadoct => _estadoct;

  List<Involucrados> get involucrados => _involucrados;
}

class Involucrados {
  String _nombre;
  String _tipoInvolucrado;

  Involucrados(datos) {
    _nombre = datos['nombre'];
    _tipoInvolucrado = datos['tipo_involucrado'];
  }

  String get nombre => _nombre;
  String get tipoInvolucrado => _tipoInvolucrado;
}
