class InvitadosConfirmadosModel {
  InvitadosConfirmadosModel({
    this.idInvitado,
    this.idAcompanante,
    this.nombre,
    this.idEvento,
    this.alergias,
    this.alimentacion,
    this.asistenciaEspecial,
    this.genero,
    this.edad,
  });

  int idInvitado;
  int idAcompanante;
  String nombre;
  int idEvento;
  String alergias;
  String alimentacion;
  String asistenciaEspecial;
  String genero;
  String edad;

  factory InvitadosConfirmadosModel.fromJson(Map<String, dynamic> json) =>
      InvitadosConfirmadosModel(
        idInvitado: json['id_invitado'],
        idAcompanante: json['id_acompanante'],
        nombre: json['nombre'],
        idEvento: json['id_evento'],
        alergias: json['alergias'],
        alimentacion: json['alimentacion'],
        asistenciaEspecial: json['asistencia_especial'],
        genero: json['genero'],
        edad: json['edad'],
      );
  Map<String, dynamic> toJson() => {
        'id_invitado': idInvitado,
        'id_acompanante': idAcompanante,
        'nombre': nombre,
        'id_evento': idEvento,
        'alergias': alergias,
        'alimentacion': alimentacion,
        'asistencia_especial': asistenciaEspecial,
        'genero': genero,
        'edad': edad,
      };
}
