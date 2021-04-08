
import 'package:flutter/foundation.dart';

class Involucrados {
final int id_involucrado;
final String nombre;
final String apellidos;
final String fecha_nacimiento;
final String email;

Involucrados(
  {
    @required this.id_involucrado,
    @required this.nombre,
    @required this.apellidos,
    @required this.fecha_nacimiento,
    @required this.email
  }
);

/*factory Involucrados.fromMap(Map<String, dynamic> json) {
  
	return Involucrados(json['id_involucrado'], json['nombre'], json['apellidos'], json['fecha_nacimiento'], json['email']);
}*/
factory Involucrados.fromJson(List<dynamic> json) {
	print(json);
  return Involucrados(
    id_involucrado: json[0]['id_involucrado'],
    nombre: json[0]['nombre'],
    apellidos: json[0]['apellidos'],
    fecha_nacimiento: json[0]['fecha_nacimiento'],
    email: json[0]['email']
    );
}
fromJsonList(List<dynamic> json){
  
}
}
