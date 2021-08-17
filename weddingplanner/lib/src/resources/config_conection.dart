class ConfigConection {
  String _url;
  String _puerto;
  bool ambiente = true;
  set addUrl(String data) {
    this._url = data;
  }

  set addPuerto(String data) {
    this._puerto = data;
  }

  String get url => _url;
  String get puerto => _puerto;
  ConfigConection() {
    if (ambiente) {
      addPuerto = "3005";
      addUrl = "http://localhost:";
    } else {
      addPuerto = "9005";
      addUrl = "https://pruebas.grupotum.com:";
    }
  }
}
