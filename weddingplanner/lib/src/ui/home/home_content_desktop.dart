import 'package:flutter/material.dart';
//import 'package:weddingplanner/src/ui/widgets/invitados/invitados.dart';
//import 'package:weddingplanner/src/ui/Tabs/pages_taps/tabs_page.dart';
import 'package:weddingplanner/src/ui/widgets/invitados/lista_invitados.dart';

class HomeContentDesktop extends StatelessWidget {
  const HomeContentDesktop({Key key, this.id}) : super(key: key);
  final int id;
  @override
  Widget build(BuildContext context) {
    return Center(
                child: 
                 //TabsPage(id: id),
                  ListaInvitados(id: id),
                //Invitados()
              );
  }
}