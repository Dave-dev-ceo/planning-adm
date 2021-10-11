import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weddingplanner/src/blocs/Mesas/mesas_bloc.dart';
import 'package:weddingplanner/src/blocs/eventos/eventos_bloc.dart';
import 'package:weddingplanner/src/models/mesa/mesas_model.dart';
import 'package:weddingplanner/src/ui/widgets/showDialog/alertDialog.dart';

class MesasPage extends StatefulWidget {
  @override
  State<MesasPage> createState() => _MesasPageState();
}

class _MesasPageState extends State<MesasPage> {
  MesasAsignadasBloc mesasBloc;
  Size size;

  @override
  void initState() {
    BlocProvider.of<MesasAsignadasBloc>(context)
        .add(MostrarMesasAsignadasEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 20.0,
            ),
            Text(
              'Asignación de Mesas',
              style: Theme.of(context).textTheme.headline4,
            ),
            SizedBox(
              height: 20.0,
            ),
            BlocListener<MesasAsignadasBloc, MesasAsignadasState>(
              listener: (context, state) {
                if (state is ErrorTokenMesasAsignadasState) {
                  return _showDialogAlert();
                }
              },
              child: BlocBuilder<MesasAsignadasBloc, MesasAsignadasState>(
                builder: (context, state) {
                  if (state is LoadingMesasAsignadasState) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is MostrarMesasAsignadasState) {
                    if (state.mesasAsignadas.isNotEmpty &&
                        state.mesasAsignadas != null) {
                      return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child:
                              _buildTableMesasAsignadas(state.mesasAsignadas));
                    } else {
                      return Align(
                        alignment: Alignment.center,
                        child: Text(
                          'No se encontraron datos',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      );
                    }
                  } else if (state is ErrorMesasAsignadasState) {
                    return Container(
                      child: Center(child: Text(state.message)),
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/asignarMesas');
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildTableMesasAsignadas(List<MesasModel> listaMesas) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: size.width * 0.6,
        ),
        child: Card(
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: listaMesas.length,
              itemBuilder: (BuildContext context, int i) {
                List<Asignados> asignados = listaMesas[i].asignados;

                List<Widget> listWidgetAsignados = [];

                for (var asignado in asignados) {
                  Widget asignadoWidgetTemp = Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListTile(
                      title: Text(
                        '${asignado.posicion}: ${asignado.asignado}',
                        textAlign: TextAlign.left,
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
                          IconButton(onPressed: () {}, icon: Icon(Icons.delete))
                        ],
                      ),
                    ),
                  );

                  listWidgetAsignados.add(asignadoWidgetTemp);
                }

                return ExpansionTile(
                  title: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 5.0, vertical: 10.0),
                    child: Center(
                      child: Text(
                        '${listaMesas[i].nombre}',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  children: listWidgetAsignados,
                );
              }),
        ),
      ),
    );
  }

  _showDialogAlert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Sesión",
              textAlign: TextAlign.center,
            ),
            content: Text(
                'Lo Sentimos la sesión ha caducado, por favor inicie sesión de nuevo'),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil('/', (route) => false);
                },
                child: Text('Cerrar'),
              )
            ],
          );
        });
  }
}
