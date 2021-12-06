import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planning/src/blocs/dashboard/dashboard_bloc.dart';
import 'package:planning/src/logic/dashboard_logic/dashboard_logic.dart';
import 'package:planning/src/models/Planes/planes_model.dart';
import 'package:planning/src/models/eventosModel/eventos_dashboard_model.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class DashboardCalendarPage extends StatefulWidget {
  @override
  _DashboardCalendarPageState createState() => _DashboardCalendarPageState();
}

class _DashboardCalendarPageState extends State<DashboardCalendarPage> {
  final List<CalendarView> _allowedViews = <CalendarView>[
    CalendarView.day,
    CalendarView.week,
    CalendarView.month,
    CalendarView.schedule,
  ];

  DashboardLogic logic = DashboardLogic();

  DashboardBloc dashboardBloc;

  final ScrollController _controller = ScrollController();
  List<Meeting> _eventos = [];
  final MeetingDataSource _events = MeetingDataSource(<Meeting>[]);
  List<DashboardEventoModel> eventos = [];
  List<EventoActividadModel> actividades = [];
  final CalendarController _calendarController = CalendarController();

  @override
  void initState() {
    dashboardBloc = BlocProvider.of<DashboardBloc>(context);
    dashboardBloc.add(MostrarFechasEvent());
    _calendarController.view = CalendarView.month;
    _calendarController.selectedDate = DateTime.now();

    super.initState();
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        body: Row(
      children: <Widget>[
        Expanded(
          child: _calendarController.view == CalendarView.month &&
                  screenHeight < 800
              ? Scrollbar(
                  isAlwaysShown: true,
                  controller: _controller,
                  child: ListView(
                    controller: _controller,
                    children: <Widget>[
                      Container(height: 600, child: calendar())
                    ],
                  ))
              : Container(child: calendar()),
        )
      ],
    )
        // } else {
        //   return Row(
        //     children: <Widget>[
        //       Expanded(
        //         child: _calendarController.view == CalendarView.month &&
        //                 screenHeight < 800
        //             ? Scrollbar(
        //                 isAlwaysShown: true,
        //                 controller: _controller,
        //                 child: ListView(
        //                   controller: _controller,
        //                   children: <Widget>[
        //                     Container(height: 600, child: calendar(false))
        //                   ],
        //                 ))
        //             : Container(child: calendar(false)),
        //       )
        //     ],
        //   );
        // }
        // },
        // ),
        );
  }

  Widget calendar() {
    return Theme(
      data: ThemeData.light(),
      child: SfCalendar(
        headerStyle: CalendarHeaderStyle(
          backgroundColor: Colors.green,
          textStyle: TextStyle(
            color: Colors.white,
            locale: Locale('es'),
          ),
        ),
        initialDisplayDate: DateTime.now(),
        controller: _calendarController,
        allowedViews: _allowedViews,
        dataSource: MeetingDataSource(_getDataSource()),
        showNavigationArrow: true,
        showDatePickerButton: true,
        selectionDecoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(color: Colors.green, width: 2)),
        monthViewSettings: const MonthViewSettings(
            showAgenda: true,
            appointmentDisplayMode: MonthAppointmentDisplayMode.indicator),
        loadMoreWidgetBuilder:
            (BuildContext context, LoadMoreCallback loadMoreAppointments) {
          return FutureBuilder<void>(
              future: loadMoreAppointments(),
              builder: (BuildContext context, AsyncSnapshot<void> snapchost) {
                return Container(
                  height: _calendarController.view == CalendarView.schedule
                      ? 50
                      : double.infinity,
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(),
                );
              });
        },
      ),
    );
  }

  List<Meeting> _getDataSource() {
    return _eventos = [];
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(this.source);

  final DashboardLogic logic = DashboardLogic();

  List<Meeting> source;
  List<Meeting> seccionSource = [];

  @override
  List<dynamic> get appointments => source;

  @override
  DateTime getStartTime(int index) {
    return source[index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return source[index].to;
  }

  @override
  String getSubject(int index) {
    return source[index].eventName;
  }

  @override
  Color getColor(int index) {
    return source[index].background;
  }

  @override
  bool isAllDay(int index) {
    return source[index].isAllDay;
  }

  @override
  String getRecurrenceRule(int index) {
    return source[index].recurrenceRule;
  }

  @override
  Future<void> handleLoadMore(DateTime startDate, DateTime endDate) async {
    final Random random = Random();
    List<Color> _colorCollection = <Color>[];
    _colorCollection.add(Color(0xFF0F8644));
    _colorCollection.add(Color(0xFF8B1FA9));
    _colorCollection.add(Color(0xFFD20100));
    _colorCollection.add(Color(0xFFFC571D));
    _colorCollection.add(Color(0xFF36B37B));
    _colorCollection.add(Color(0xFF01A1EF));
    _colorCollection.add(Color(0xFF3D4FB5));
    _colorCollection.add(Color(0xFFE47C73));
    _colorCollection.add(Color(0xFF636363));
    _colorCollection.add(Color(0xFF0A8043));
    try {
      int index = 0;
      final actividades =
          await logic.getAllActivitiesPlanner(startDate, endDate);

      for (var actividad in actividades) {
        DateTime starttime = actividad.fechaInicioActividad;
        DateTime endtime = actividad.fechaFinActividad;

        source.add(Meeting(
          eventName: actividad.nombreActividad,
          description: actividad.descripcionActividad,
          from: starttime,
          to: endtime,
          background: _colorCollection[index],
          isAllDay: false,
          organizer: actividad.responsable != null
              ? actividad.responsable
              : 'Sin responsable',
          idActividad: actividad.idActividad,
        ));
        index++;
      }

      for (var meet in source) {
        if (appointments.contains(meet.idActividad) ||
            appointments.contains(meet.idEvento)) {
          appointments.add(meet);
          continue;
        }
      }
      notifyListeners(CalendarDataSourceAction.add, source);
    } catch (e) {
      print(e);
    }
  }
}

class Meeting {
  Meeting({
    this.eventName,
    this.description,
    this.organizer,
    this.contactID,
    this.capacity,
    this.from,
    this.to,
    this.background,
    this.isAllDay,
    this.startTimeZone,
    this.endTimeZone,
    this.recurrenceRule,
    this.idActividad,
    this.idEvento,
  });

  int idActividad;
  int idEvento;
  String eventName;
  String description;
  String organizer;
  String contactID;
  int capacity;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
  String startTimeZone;
  String endTimeZone;
  String recurrenceRule;
}
