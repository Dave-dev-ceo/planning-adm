import 'package:flutter/material.dart';

class Perfil extends StatefulWidget {
  Perfil({Key key}) : super(key: key);

  @override
  _PerfilState createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil de usuario'),
      ),
      body: Container(
        child: _showPerfil(),
      ),
    );
  }

  _showPerfil() {
    return Container(
      padding: EdgeInsets.all(10.0),
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: TextEditingController(text: ''),
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.person),
                hintText: 'Nombre:',
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
              onChanged: (valor) {},
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: TextEditingController(text: ''),
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.work_sharp),
                hintText: 'Empresa:',
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
              onChanged: (valor) {},
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: TextEditingController(text: ''),
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.directions),
                hintText: 'Dirección:',
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
              onChanged: (valor) {},
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: TextEditingController(text: ''),
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.phone),
                hintText: 'Telefono:',
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
              onChanged: (valor) {},
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: TextEditingController(text: ''),
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.password),
                hintText: 'Contraseña:',
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
              obscureText: true,
              onChanged: (valor) {},
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: TextEditingController(text: ''),
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.password),
                hintText: 'Confirma la contraseña:',
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
              obscureText: true,
              onChanged: (valor) {},
            ),
          ),
        ],
      ),
    );
  }
}