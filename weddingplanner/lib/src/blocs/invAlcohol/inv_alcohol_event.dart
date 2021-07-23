part of 'inv_alcohol_bloc.dart';

@immutable
abstract class InvAlcoholEvent {}

class FechtInvAlcoholEvent extends InvAlcoholEvent {}

class CreateInvAlcoholEvent extends InvAlcoholEvent {
  final Map<String, dynamic> data;
  final ItemModelInventarioAlcohol cantidad;
  final ItemModelInventarioAlcohol mililitros;
  CreateInvAlcoholEvent(this.data, this.cantidad, this.mililitros);
  List<Object> get props => [data, cantidad, mililitros];
}

class UpdateInvAlcoholEvent extends InvAlcoholEvent {
  final Map<String, dynamic> data;
  final ItemModelInventarioAlcohol cantidad;
  final ItemModelInventarioAlcohol mililitros;
  final int id;

  UpdateInvAlcoholEvent(this.data, this.cantidad, this.mililitros, this.id);
  List<Object> get props => [data, cantidad, mililitros, id];
}
