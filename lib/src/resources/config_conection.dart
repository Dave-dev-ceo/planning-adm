class ConfigConection {
  String? _url;
  String? _puerto;
  bool desarrollo = true;
  set addUrl(String data) {
    _url = data;
  }

  set addPuerto(String data) {
    _puerto = data;
  }

  String? get url => _url;
  String? get puerto => _puerto;
  ConfigConection() {
    if (desarrollo) {
      addPuerto = "3005";
      addUrl = "http://192.168.100.17:"; //Local
    } else {
      addPuerto = "9000";
      addUrl = "https://planning.com.mx:"; //Producción
    }
  }
}
