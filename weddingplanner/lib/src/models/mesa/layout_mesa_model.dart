class LayoutMesaModel {
  LayoutMesaModel({
    this.file,
    this.mime,
    this.idEvento,
  });
  int idEvento;
  String file;
  String mime;

  factory LayoutMesaModel.fromJson(Map<String, dynamic> json) =>
      LayoutMesaModel(
        file: json['archivo_layout'],
        mime: json['tipo_mime'],
        idEvento: json['id_evento'],
      );
  Map<String, dynamic> toJson() => {
        'archivo_layout': file,
        'tipo_mime': mime,
        'id_evento': idEvento,
      };
}
