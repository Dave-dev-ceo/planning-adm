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

class LayoutBookModel {
  LayoutBookModel({
    this.file,
    this.mime,
    this.idEvento,
    this.idBookInspiracion,
  });
  int idEvento;
  String file;
  String mime;
  int idBookInspiracion;

  factory LayoutBookModel.fromJson(Map<String, dynamic> json) =>
      LayoutBookModel(
        file: json['archivo'],
        mime: json['tipo_mime'],
        idEvento: json['id_evento'],
        idBookInspiracion: json['id_book_inspiracion'],
      );
  Map<String, dynamic> toJson() => {
        'archivo': file,
        'tipo_mime': mime,
        'id_evento': idEvento,
        'id_book_inspiracion': idBookInspiracion,
      };
}
