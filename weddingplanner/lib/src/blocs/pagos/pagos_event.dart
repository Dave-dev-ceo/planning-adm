part of 'pagos_bloc.dart';

@immutable
abstract class PagosEvent {}

// eveno - select
class SelectPagosEvent extends PagosEvent {
  SelectPagosEvent();
}

class SelectIdEvent extends PagosEvent {
  final int id;
  
  SelectIdEvent(this.id);

  int get prop => id;
}

// evento - crear
class CrearPagosEvent extends PagosEvent {
  final Map data;
  CrearPagosEvent(this.data);

  Map get props => data;
}

// evento - update
class UpdatePagosEvent extends PagosEvent {
  final Map data;
  UpdatePagosEvent(this.data);

  Map get props => data;
}

class SelectFormPagosEvent extends PagosEvent {
  SelectFormPagosEvent();
}

// evento - delete
class DeletePagosEvent extends PagosEvent {
  final int id;

  DeletePagosEvent(this.id);

  int get props => id;
}
