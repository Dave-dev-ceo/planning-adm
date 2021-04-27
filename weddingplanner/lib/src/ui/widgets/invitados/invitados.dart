import 'package:flutter/material.dart';
import 'package:weddingplanner/src/ui/widgets/invitados/lista_invitados.dart';

class Invitados extends StatefulWidget {
  const Invitados({Key key, this.destination}) : super(key: key);
  final Destination destination;
  @override
  _InvitadosState createState() => _InvitadosState();
}

class _InvitadosState extends State<Invitados> {
  int _selectedIndex = 0;
      
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Invitados().destination.title),
        backgroundColor: Invitados().destination.color,
      ),
      backgroundColor: Invitados().destination.color[50],
      body: SizedBox.expand(
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(context, "/list");
          },
        ),
      ),
    );
  }
}
class Destination {
  const Destination(this.title, this.icon, this.color);
  final String title;
  final IconData icon;
  final MaterialColor color;
}
const List<Destination> allDestinations = <Destination>[
  Destination('Invitados', Icons.list, Colors.teal),
  Destination('Agregar', Icons.add, Colors.cyan),
  Destination('Importar', Icons.import_contacts, Colors.orange)
];