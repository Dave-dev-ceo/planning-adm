class ConfigConection {
  String _url;
  String _puerto;
  bool desarrollo = false;
  set addUrl(String data) {
    _url = data;
  }

  set addPuerto(String data) {
    _puerto = data;
  }

  String get url => _url;
  String get puerto => _puerto;
  ConfigConection() {
    if (desarrollo) {
      addPuerto = "3005";
      addUrl = "http://localhost:"; //Local
      // addUrl = "http://10.0.2.2:"; //Emulador
      // addUrl = "http://10.0.1.127:"; //Dispositivo
    } else {
      addPuerto = "9000";
      addUrl = "https://planning.com.mx:"; //Producción
      //addPuerto = "9004";
      //addUrl = "https://pruebas.grupotum.com:"; //Pruebas
    }
  }
}
