class ItemModelPlanners {
  
  List<ResultsPlanners> _results = [];

  ItemModelPlanners.fromJson(Map<dynamic,dynamic> parsedJson){
    List<ResultsPlanners> temp = [];
    //print(parsedJson.length);
    //print(parsedJson[0]['nombre']);
    for (int i = 0; i < parsedJson['data'].length; i++) {
      //print(parsedJson[0][i]);
      ResultsPlanners result = ResultsPlanners(parsedJson['data'][i]);
      temp.add(result);
    }
    _results = temp;
  }
  List<ResultsPlanners> get results => _results;
}

class ResultsPlanners {
  int _idPlanner;
  String _empresa;
  String _correo;
  String _pais;
  String _telefono;

  ResultsPlanners(result){
    _idPlanner = result['id_planner'];
    _empresa = result['empresa'];
    _correo = result['correo'];    
    _pais = result['pais'];
    _telefono = result['telefono'];
  }
  int get idPlanner=>_idPlanner;
  String get empresa=>_empresa;
  String get correo=>_correo;
  String get pais=>_pais;
  String get telefono=>_telefono;

}