import 'dart:io';

//import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:async';
import 'package:http/http.dart' show Client;
import 'package:weddingplanner/src/models/item_model_estatus_invitado.dart';
import 'package:weddingplanner/src/models/item_model_eventos.dart';
import 'package:weddingplanner/src/models/item_model_grupos.dart';
import 'package:weddingplanner/src/models/item_model_invitado.dart';
import 'package:weddingplanner/src/models/item_model_mesas.dart';
import 'package:weddingplanner/src/models/item_model_preferences.dart';
import 'package:weddingplanner/src/models/item_model_reporte_genero.dart';
import 'package:weddingplanner/src/models/item_model_reporte_invitados.dart';
import 'dart:convert';
import '../models/item_model_invitados.dart';
//import '../models/item_model_response.dart';

class ApiProvider {
  SharedPreferencesT _sharedPreferences = new SharedPreferencesT();

  Client client = Client();
  //String baseUrlPruebas = 'server01.grupotum.com:3004';
  String baseUrlPruebas = 'localhost:3010';
  _loadLogin(BuildContext context) async{
    await _sharedPreferences.setSesion(false);
    await _sharedPreferences.setToken('');
    await _sharedPreferences.setIdPlanner(0);
    await _sharedPreferences.setIdEvento(0);
    _showDialogMsg(context);
  }
  _showDialogMsg(BuildContext context){
    showDialog(
      barrierDismissible: false,
        context: context,
        //barrierDismissible: false,
        builder: (BuildContext context) {
       //_ingresando = context;
          return AlertDialog(
            title: Text(
              "Sesión",
              textAlign: TextAlign.center,
            ),
            content: Column(
              children: [
                Text('Lo sentimos la sesión a caducado, por favor inicie sesión de nuevo.'),
                Image.asset('assets/cancelado.png',height: 100.0,width: 150.0,),
              ],
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            actions: <Widget>[TextButton(
              child: Text('Cerrar'),
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
              },
           ),
          ],
           
          );
        });
  }
  Future<ItemModelReporteInvitadosGenero> fetchReporteInvitadosGenero(BuildContext context) async {
    
    int res = await renovarToken();

    if(res == 0){
      int idEvento = await _sharedPreferences.getIdEvento();
      String token = await _sharedPreferences.getToken();
      final response = await client.get(Uri.http(baseUrlPruebas, 'wedding/INVITADOS/obtenerReporteInvitadosGenero/$idEvento'),
      headers: {HttpHeaders.authorizationHeader: token});
      
      if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return ItemModelReporteInvitadosGenero.fromJson(json.decode(response.body));
    } else if(response.statusCode == 401){
        _loadLogin(context);
        return null;
      }else{
        
        throw Exception('Failed to load get');
      }
    }else if(res == 1){
        _loadLogin(context);
        return null;
    }else{
      _loadLogin(context);
        return null;
    }
  }

  Future<ItemModelReporteInvitados> fetchReporteInvitados(BuildContext context) async {
    
    int res = await renovarToken();
    if(res == 0){
      int idEvento = await _sharedPreferences.getIdEvento();
      String token = await _sharedPreferences.getToken();
      final response = await client.get(Uri.http(baseUrlPruebas, 'wedding/INVITADOS/obtenerReporteInvitados/$idEvento'),
      headers: {HttpHeaders.authorizationHeader: token});
      
      if (response.statusCode == 200) {
        // If the call to the server was successful, parse the JSON
        return ItemModelReporteInvitados.fromJson(json.decode(response.body));
      } else if(response.statusCode == 401){
        _loadLogin(context);
        return null;
      }else{

        throw Exception('Failed to load get');
      }
    }else if(res == 1){
        _loadLogin(context);
        return null;
    }else{
      _loadLogin(context);
        return null;
    }
  }

  Future<ItemModelInvitados> fetchInvitadosList(BuildContext context) async {
    

    int res = await renovarToken();
    if(res == 0){
      int idEvento = await _sharedPreferences.getIdEvento();
    String token = await _sharedPreferences.getToken();
      final response = await client.get(Uri.http(baseUrlPruebas, 'wedding/INVITADOS/obtenerInvitados/$idEvento'),
      headers: {HttpHeaders.authorizationHeader: token});
      
      if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return ItemModelInvitados.fromJson(json.decode(response.body));
    } else if(response.statusCode == 401){
        _loadLogin(context);
        return null;
      }else{
        throw Exception('Failed to load get');
      }
    }else if(res == 1){
        _loadLogin(context);
        return null;
    }else{
      _loadLogin(context);
        return null;
    }
  }

  Future<ItemModelEventos> fetchEventosList(BuildContext context) async {
    
    int res = await renovarToken();
    if(res == 0){
      int idPlanner = await _sharedPreferences.getIdPlanner();
      String token = await _sharedPreferences.getToken();
      final response = await client.get(Uri.http(baseUrlPruebas, '/wedding/EVENTOS/obtenerEventos/$idPlanner'),
      headers: {HttpHeaders.authorizationHeader: token});
      
      if (response.statusCode == 200) {
        // If the call to the server was successful, parse the JSON
        return ItemModelEventos.fromJson(json.decode(response.body));
      } else if(response.statusCode == 401){
        _loadLogin(context);
        return null;
      }else{
        
        throw Exception('Failed to load get');
      }
    }else if(res == 1){
      _loadLogin(context);
        return null;
    }else{
      _loadLogin(context);
        return null;
    }
  }
  
  Future<ItemModelInvitado> fetchInvitadoList(int idInvitado, BuildContext context) async {
    
    int res = await renovarToken();
    
    if(res == 0){
      String token = await _sharedPreferences.getToken();
      final response = await client.get(Uri.http(baseUrlPruebas, '/wedding/INVITADOS/obtenerInvitado/$idInvitado'),
      headers: {HttpHeaders.authorizationHeader: token});
      
      if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return ItemModelInvitado.fromJson(json.decode(response.body));
    } else if(response.statusCode == 401){
        _loadLogin(context);
        return null;
      }else{
        
        throw Exception('Failed to load get');
      }
    }else if(res == 1){
        _loadLogin(context);
        return null;
    }else{
      _loadLogin(context);
        return null;
    }
  }

  Future<bool> createInvitados(Map<String,String> invitados, BuildContext context) async{
    
    
    int res = await renovarToken();
    
    if(res == 0){
      String token = await _sharedPreferences.getToken();
      final response = await client.post(Uri.http(baseUrlPruebas, 'wedding/INVITADOS/createInvitados'),
        body: invitados,
      headers: {HttpHeaders.authorizationHeader: token});
      
      if (response.statusCode == 201) {
        return true;  
      } else if(response.statusCode == 401){
        _loadLogin(context);
        return null;
      }else{
        return false;
      }
    }else if(res == 1){
        _loadLogin(context);
        return null;
    }else{
      _loadLogin(context);
        return false;
    }
  }

  Future<bool> updateEstatusInvitado(Map<String,String> data, BuildContext context) async{
    
    
    int res = await renovarToken();

    if(res == 0){
      String token = await _sharedPreferences.getToken();
      final response = await client.post(Uri.http(baseUrlPruebas, 'wedding/INVITADOS/updateEstatusInvitados'),
        
        body: data,
      headers: {HttpHeaders.authorizationHeader: token});
      
      if (response.statusCode == 201) {
        return true;  
      } else if(response.statusCode == 401){
        _loadLogin(context);
        return null;
      }else{
        return false;
      }
    }else if(res == 1){
        _loadLogin(context);
        return null;
    }else{
      _loadLogin(context);
        return false;
    }
  }

  Future<bool> updateInvitado(Map<String,String> data, BuildContext context) async{
  
    
    int res = await renovarToken();

    if(res == 0){
      String token = await _sharedPreferences.getToken();
      final response = await client.post(Uri.http(baseUrlPruebas, 'wedding/INVITADOS/updateInvitado'),
        
        body: data,
      headers: {HttpHeaders.authorizationHeader: token});
      
      if (response.statusCode == 201) {
        return true;  
      } else if(response.statusCode == 401){
        _loadLogin(context);
        return null;
      }else{
        return false;
      }
    }else if(res == 1){
        _loadLogin(context);
        return null;
    }else{
      _loadLogin(context);
        return false;
    }
  }

  Future<ItemModelMesas> fetchMesasList(BuildContext context) async {
    
    
    int res = await renovarToken();

    if(res == 0){
      String token = await _sharedPreferences.getToken();
      final response = await client.get(Uri.http(baseUrlPruebas, 'wedding/MESAS/obtenerMesas'),
      headers: {HttpHeaders.authorizationHeader: token});
      
      if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return ItemModelMesas.fromJson(json.decode(response.body));
    }else if(response.statusCode == 401){
        _loadLogin(context);
        return null;
      }else{
        
        throw Exception('Failed to load get');
      }
    }else if(res == 1){
        _loadLogin(context);
        return null;
    }else{
      _loadLogin(context);
        return null;
    }
  }

  Future<ItemModelGrupos> fetchGruposList(BuildContext context) async {
    
    
    int res = await renovarToken();

    if(res == 0){
      String token = await _sharedPreferences.getToken();
      final response = await client.get(Uri.http(baseUrlPruebas, 'wedding/GRUPOS/obtenerGrupos'),
      headers: {HttpHeaders.authorizationHeader: token});
      
      if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return ItemModelGrupos.fromJson(json.decode(response.body));
    }else if(response.statusCode == 401){
        _loadLogin(context);
        return null;
      }else{
        
        throw Exception('Failed to load get');
      }
    }else if(res == 1){
        _loadLogin(context);
        return null;
    }else{
      _loadLogin(context);
        return null;
    }
  }

  Future<ItemModelEstatusInvitado> fetchEstatusList(BuildContext context) async {
  
    
    int res = await renovarToken();

    if(res == 0){
      String token = await _sharedPreferences.getToken();
      final response = await client.get(Uri.http(baseUrlPruebas, 'wedding/ESTATUS/obtenerEstatus'),
      headers: {HttpHeaders.authorizationHeader: token});
      
      if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return ItemModelEstatusInvitado.fromJson(json.decode(response.body));
    }else if(response.statusCode == 401){
        _loadLogin(context);
        return null;
      }else{
        
        throw Exception('Failed to load get');
      }
    }else if(res == 1){
        _loadLogin(context);
        return null;
    }else{
      _loadLogin(context);
        return null;
    }
  }

  Future<bool> createGrupo(Map<String,String> grupo, BuildContext context) async{
    
    
    int res = await renovarToken();

    if(res == 0){
      String token = await _sharedPreferences.getToken();
      final response = await client.post(Uri.http(baseUrlPruebas, 'wedding/GRUPOS/createGrupo'),
        
        body: grupo,
      headers: {HttpHeaders.authorizationHeader: token});
      
      if (response.statusCode == 201) {
        return true;  
      } else if(response.statusCode == 401){
        _loadLogin(context);
        return null;
      }else{
        return false;
      }
    }else if(res == 1){
        _loadLogin(context);
        return null;
    }else{
      _loadLogin(context);
        return false;
    }
  }

  Future<int> loginPlanner(Map<String,String> auth) async{
    final response = await client.post(Uri.http(baseUrlPruebas, 'wedding/ACCESO/loginPlanner'),     
        body: auth
    );
    if (response.statusCode == 200) {
      Map<dynamic,dynamic> data = json.decode(response.body);
      await _sharedPreferences.setIdPlanner(data['usuario']['id_planner']);
      await _sharedPreferences.setToken(data['token']);
      await _sharedPreferences.setSesion(true);
      return 0;  
    } else if(response.statusCode == 403){
      return 1;
    }else{
      return 2;
    }
  }
  Future<int> renovarToken() async{
    final response = await client.post(Uri.http(baseUrlPruebas, 'wedding/ACCESO/renovarToken'),     
        body: {"token": await _sharedPreferences.getToken()}
    );
    if (response.statusCode == 200) {
      Map<dynamic,dynamic> data = json.decode(response.body);
      await _sharedPreferences.setToken(data['token']);
      return 0;  
    } else if(response.statusCode == 403){
      return 1;
    }else{
      return 2;
    }
  }
}