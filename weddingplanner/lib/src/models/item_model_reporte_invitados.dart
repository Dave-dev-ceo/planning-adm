class ItemModelReporteInvitados {
  String _confirmados;
  String _sinConfirmar;
  String _noAsistira;  
  //List<_Result> _results = [];

  ItemModelReporteInvitados.fromJson(List<dynamic> parsedJson){
    _confirmados = parsedJson[0]['confirmados'];
    _sinConfirmar = parsedJson[1]['sinconfirmar'];
    _noAsistira = parsedJson[2]['noasiste'];
  }
  //List<_Result> get results => _results;
  String get confirmados => _confirmados;
  String get sinConfirmar => _sinConfirmar;
  String get noAsistira => _noAsistira;
}

/*class _Result {
  int _confirmados;
  int _sinConfirmar;
  int _noAsistira;

  _Result(result){
    _confirmados = result['confirmados'];
    _sinConfirmar = result['sinconfirmar'];
    _noAsistira = result['noasistira'];
  }

  int get confirmados => _confirmados;
  int get sinConfirmar => _sinConfirmar;
  int get noAsistira => _noAsistira;
}*/