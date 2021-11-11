part of 'view_archivos_bloc.dart';

@immutable
abstract class ViewArchivosEvent {}

class FechtArchivoByIdEvent extends ViewArchivosEvent {
  final int id_archivo;
  FechtArchivoByIdEvent(this.id_archivo);
  List<Object> get props => [id_archivo];
}
