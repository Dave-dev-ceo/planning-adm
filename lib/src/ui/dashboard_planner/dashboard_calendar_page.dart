// ignore_for_file: unused_field

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planning/src/blocs/dashboard/dashboard_bloc.dart';
import 'package:planning/src/logic/dashboard_logic/dashboard_logic.dart';
import 'package:planning/src/models/Planes/planes_model.dart';
import 'package:planning/src/models/eventosModel/eventos_dashboard_model.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class DashboardCalendarPage extends StatefulWidget {
  const DashboardCalendarPage({Key key}) : super(key: key);

  @override
  State<DashboardCalendarPage> createState() => _DashboardCalendarPageState();
}

class _DashboardCalendarPageState extends State<DashboardCalendarPage> {
  final List<CalendarView> _allowedViews = <CalendarView>[
    CalendarView.week,
    CalendarView.month,
    CalendarView.schedule,
  ];

  DashboardLogic logic = DashboardLogic();

  DashboardBloc dashboardBloc;

  final ScrollController _controller = ScrollController();
  final List<Meeting> _eventos = [];
  final MeetingDataSource _events = MeetingDataSource();
  List<DashboardEventoModel> eventos = [];
  List<EventoActividadModel> actividades = [];
  final CalendarController _calendarController = CalendarController();

  final textStyleCustom = const TextStyle(
    fontFamily: 'Montserrat-Medium',
    color: Colors.black,
  );
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
                  thumbVisibility: true,
                  controller: _controller,
                  child: ListView(
                    shrinkWrap: true,
                    controller: _controller,
                    children: <Widget>[
                      SizedBox(height: 600, child: calendar())
                    ],
                  ))
              : Container(child: calendar()),
        )
      ],
    ));
  }

  Widget calendar() {
    return Theme(
      data: ThemeData.light(),
      child: SfCalendar(
        appointmentTextStyle: textStyleCustom,
        scheduleViewSettings: ScheduleViewSettings(
            appointmentTextStyle: textStyleCustom,
            dayHeaderSettings: DayHeaderSettings(
              dateTextStyle: textStyleCustom,
              dayTextStyle: textStyleCustom,
            ),
            monthHeaderSettings: MonthHeaderSettings(
              monthTextStyle: textStyleCustom,
            ),
            weekHeaderSettings: WeekHeaderSettings(
              weekTextStyle: textStyleCustom,
            )),
        headerStyle: CalendarHeaderStyle(
          backgroundColor: const Color(0xFFFFF0D6),
          textStyle: textStyleCustom,
        ),
        viewHeaderStyle: ViewHeaderStyle(
          dateTextStyle: textStyleCustom,
          dayTextStyle: textStyleCustom.copyWith(fontFamily: 'Montserrat'),
        ),
        initialDisplayDate: DateTime.now(),
        controller: _calendarController,
        allowedViews: _allowedViews,
        dataSource: _events,
        showNavigationArrow: true,
        showDatePickerButton: true,
        selectionDecoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(color: Colors.green, width: 2)),
        monthViewSettings: MonthViewSettings(
          monthCellStyle: MonthCellStyle(
            textStyle: textStyleCustom,
            leadingDatesTextStyle: textStyleCustom.copyWith(color: Colors.grey),
            trailingDatesTextStyle:
                textStyleCustom.copyWith(color: Colors.grey),
          ),
          agendaStyle: AgendaStyle(
            dayTextStyle: textStyleCustom,
            dateTextStyle: textStyleCustom,
            appointmentTextStyle: textStyleCustom,
          ),
          showAgenda: true,
          appointmentDisplayMode: MonthAppointmentDisplayMode.indicator,
        ),
        timeSlotViewSettings: TimeSlotViewSettings(
          timeTextStyle: textStyleCustom,
        ),
        loadMoreWidgetBuilder:
            (BuildContext context, LoadMoreCallback loadMoreAppointments) {
          return FutureBuilder<void>(
              future: loadMoreAppointments(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                return Container(
                  height: _calendarController.view == CalendarView.schedule
                      ? 50
                      : double.infinity,
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(),
                );
              });
        },
      ),
    );
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource();

  final DashboardLogic logic = DashboardLogic();

  List<Meeting> source = [];

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
    List<Color> colorCollection = <Color>[];

    colorCollection.add(const Color(0xFFF05837));
    colorCollection.add(const Color(0xFF0F8644));
    colorCollection.add(const Color(0xFF888c46));
    colorCollection.add(const Color(0xFFf4874b));
    colorCollection.add(const Color(0xFF0444BF));
    colorCollection.add(const Color(0xFF6465A5));
    colorCollection.add(const Color(0xFF8B1FA9));
    colorCollection.add(const Color(0xFFD20100));
    colorCollection.add(const Color(0xFFdaa2da));
    colorCollection.add(const Color(0xFFF49F05));
    colorCollection.add(const Color(0xFF36B37B));
    colorCollection.add(const Color(0xFF01A1EF));
    colorCollection.add(const Color(0xFFFC571D));
    colorCollection.add(const Color(0xFF80add7));
    colorCollection.add(const Color(0xFFbf9d7a));
    colorCollection.add(const Color(0xFF3D4FB5));
    colorCollection.add(const Color(0xFFE47C73));
    colorCollection.add(const Color(0xFFbed905));
    colorCollection.add(const Color(0xFF00743f));
    colorCollection.add(const Color(0xFF636363));
    colorCollection.add(const Color(0xFF1d65a6));
    colorCollection.add(const Color(0xFFde8cf0));
    colorCollection.add(const Color(0xFF0A8043));
    colorCollection.add(const Color(0xFFff6961));
    colorCollection.add(const Color(0xFF77dd77));
    colorCollection.add(const Color(0xFFfdfd96));
    colorCollection.add(const Color(0xFF84b6f4));
    colorCollection.add(const Color(0xFFfdcae1));
    colorCollection.add(const Color(0xFFb2dafa));
    colorCollection.add(const Color(0xFF0584F2));
    colorCollection.add(const Color(0xFFfad2b2));
    colorCollection.add(const Color(0xFFA7414A));
    colorCollection.add(const Color(0xFFb6fab2));

    List<EventoDetails> eventoColors = [];

    try {
      final List<Meeting> meetings = <Meeting>[];
      int index = 0;

      final actividades =
          await logic.getAllActivitiesPlanner(startDate, endDate);

      for (var actividad in actividades) {
        if (appointments.any((m) => m.idActividad == actividad.idActividad)) {
          continue;
        }
        if (!eventoColors.any((evento) => evento.id == actividad.idEvento)) {
          eventoColors.add(EventoDetails(
            color: colorCollection[index],
            id: actividad.idEvento,
          ));
          index++;
        }
        final meeting = Meeting(
          idEvento: actividad.idEvento,
          eventName: actividad.nombreActividad,
          description: actividad.descripcionActividad,
          from: actividad.fechaInicioActividad,
          to: actividad.fechaInicioActividad.add(const Duration(hours: 1)),
          background:
              eventoColors.firstWhere((e) => e.id == actividad.idEvento).color,
          isAllDay: false,
          organizer: actividad.responsable ?? 'Sin responsable',
          idActividad: actividad.idActividad,
        );
        meetings.add(meeting);
      }
      appointments.addAll(meetings);
      notifyListeners(CalendarDataSourceAction.add, meetings);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}

class EventoDetails {
  int id;
  Color color;

  EventoDetails({
    this.id,
    this.color,
  });
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
