class ItemModelReporteInvitadosGenero {
  String _masculino;
  String _femenino;  
  //List<_Result> _results = [];

  ItemModelReporteInvitadosGenero.fromJson(List<dynamic> parsedJson){
    _masculino = parsedJson[0]['masculino'];
    _femenino = parsedJson[1]['femenino'];
  }
  String get masculino => _masculino;
  String get femenino => _femenino;
}
