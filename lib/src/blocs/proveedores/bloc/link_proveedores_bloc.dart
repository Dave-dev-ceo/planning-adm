import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'link_proveedores_event.dart';
part 'link_proveedores_state.dart';

class LinkProveedoresBloc extends Bloc<LinkProveedoresEvent, LinkProveedoresState> {
  LinkProveedoresBloc() : super(LinkProveedoresInitial()) {
    on<LinkProveedoresEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
