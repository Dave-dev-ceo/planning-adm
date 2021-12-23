// imports dart/flutter
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class EventoCalendario extends StatefulWidget {
  const EventoCalendario({Key key}) : super(key: key);

  @override
  _EventoCalendarioState createState() => _EventoCalendarioState();
}

class _EventoCalendarioState extends State<EventoCalendario> {
  @override
  Widget build(BuildContext context) {
    return _crearVista();
  }

  Widget _crearVista() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendario del evento'),
      ),
      body: ListView(
        children: [_addCalendary()],
      ),
    );
  }

  Widget _addCalendary() {
    return TableCalendar(
        locale: 'es_ES',
        firstDay: DateTime.utc(2010, 10, 16),
        lastDay: DateTime.utc(2030, 3, 14),
        focusedDay: DateTime.now(),
        headerStyle:
            HeaderStyle(formatButtonVisible: false, titleCentered: true),
        onDaySelected: (selectedDay, focusedDay) {});
  }
}
