// To parse this JSON data, do
//
//     final plantillaSistemaModel = plantillaSistemaModelFromJson(jsonString);

import 'dart:convert';

List<PlantillaSistemaModel> plantillaSistemaModelFromJson(String str) =>
    List<PlantillaSistemaModel>.from(
        json.decode(str).map((x) => PlantillaSistemaModel.fromJson(x)));

String plantillaSistemaModelToJson(List<PlantillaSistemaModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

PlantillaSistemaModel plantillaSistemaModelFromData(String string) =>
    PlantillaSistemaModel.fromJson(jsonDecode(string));

class PlantillaSistemaModel {
  PlantillaSistemaModel({
    this.idPlantilla,
    this.descripcion,
    this.estatus,
    this.clavePlantilla,
    this.plantilla,
  });

  int idPlantilla;
  String descripcion;
  String plantilla;
  String estatus;
  String clavePlantilla;

  factory PlantillaSistemaModel.fromJson(Map<String, dynamic> json) =>
      PlantillaSistemaModel(
          idPlantilla: json["id_plantilla"],
          descripcion: json["descripcion"],
          estatus: json["estatus"],
          clavePlantilla: json["clave_plantilla"],
          plantilla: json['plantilla']);

  Map<String, dynamic> toJson() => {
        "id_plantilla": idPlantilla,
        "descripcion": descripcion,
        "estatus": estatus,
        "clave_plantilla": clavePlantilla,
        "plantilla": plantilla,
      };
}
