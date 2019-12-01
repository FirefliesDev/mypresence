import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:mypresence/database/firebase_service.dart';
import 'package:mypresence/model/event.dart' as model;
import 'package:mypresence/model/item.dart';
import 'package:mypresence/model/occurrence.dart';
import 'package:mypresence/ui/activities/event_details_management.dart';
import 'package:mypresence/ui/activities/home_event_management.dart';
import 'package:mypresence/utils/colors_palette.dart';

import 'package:intl/intl.dart';
import 'package:mypresence/utils/transitions/fade_route.dart';

class CreateEventOccurrences extends StatefulWidget {
  final String eventName;
  final VoidCallback onSignedOut;
  final FirebaseUser currentUser;
  final model.Event event;

  CreateEventOccurrences(
      {this.eventName, this.currentUser, this.onSignedOut, this.event});

  @override
  _CreateEventOccurrencesState createState() => _CreateEventOccurrencesState();
}

class _CreateEventOccurrencesState extends State<CreateEventOccurrences> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _timeStartController;
  TextEditingController _timeEndController;
  String _localValue, _timeStartValue, _timeEndValue;
  //
  static DateTime now = DateTime.now();
  DateTime currentdate = DateTime(now.year, now.month, now.day);
  //
  DateTime _date = now;
  //
  Color _todayButtonColor = ColorsPalette.accentColor;
  TextStyle _todayTextStyle = TextStyle(fontSize: 14.0, color: Colors.white);
  //
  String _eventId;

  @override
  Widget build(BuildContext context) {
    return _buildScaffold(context);
  }

  /// Creates a Scaffold
  Widget _buildScaffold(context) {
    final _location = TextFormField(
      validator: (input) =>
          input.isEmpty ? 'Digite o local do seu evento' : null,
      onSaved: (input) => _localValue = input,
      decoration: InputDecoration(
        labelText: 'Local',
        prefixIcon: Icon(
          Icons.room,
          color: ColorsPalette.primaryColor,
        ),
      ),
    );

    final _timeStart = GestureDetector(
      onTap: () {
        DatePicker.showTimePicker(context,
            showTitleActions: true, onChanged: (date) {}, onConfirm: (date) {
          String time = '${DateFormat('HH:mm').format(date)}';
          setState(() {
            _timeStartController = TextEditingController(text: time);
            // _timeStartValue = time;
          });
        }, currentTime: DateTime.now(), locale: LocaleType.pt);
      },
      child: Align(
        alignment: Alignment.center,
        child: AbsorbPointer(
          child: TextFormField(
            controller: _timeStartController,
            validator: (input) => input.isEmpty ? 'Início' : null,
            onSaved: (input) => _timeStartValue = input,
            decoration: InputDecoration(
              labelText: 'Início',
              prefixIcon: Icon(
                Icons.timer,
                color: ColorsPalette.primaryColor,
              ),
            ),
          ),
        ),
      ),
    );

    final _timeEnd = GestureDetector(
      onTap: () {
        DatePicker.showTimePicker(context,
            showTitleActions: true, onChanged: (date) {}, onConfirm: (date) {
          String time = '${DateFormat('HH:mm').format(date)}';
          setState(() {
            _timeEndController = TextEditingController(text: time);
          });
        }, currentTime: DateTime.now(), locale: LocaleType.pt);
      },
      child: AbsorbPointer(
        child: TextFormField(
          controller: _timeEndController,
          validator: (input) => input.isEmpty ? 'Fim' : null,
          onSaved: (input) => _timeEndValue = input,
          decoration: InputDecoration(
            labelText: 'Fim',
            prefixIcon: Icon(
              Icons.timer,
              color: ColorsPalette.primaryColor,
            ),
          ),
        ),
      ),
    );

    final _title = Text(
      "Ocorrências",
      style: TextStyle(
          color: ColorsPalette.textColorDark,
          fontSize: 24,
          fontWeight: FontWeight.w700),
      textAlign: TextAlign.center,
    );

    final _subtitle = Text(
      "Informe a data, o local e a duração do seu evento. Você pode adicionar quantas datas quiser!",
      style: TextStyle(
          color: ColorsPalette.textColorDark90,
          fontSize: 16,
          fontWeight: FontWeight.w400),
      textAlign: TextAlign.center,
    );

    final _labelCreateEvent = Text(
      widget.event == null ? "CRIAR EVENTO" : "CRIAR OCORRÊNCIA",
      style: TextStyle(
          color: ColorsPalette.textColorLight,
          fontWeight: FontWeight.w700,
          fontSize: 16),
      textAlign: TextAlign.center,
    );

    return Scaffold(
      appBar: _buildAppBar(context),
      backgroundColor: ColorsPalette.backgroundColorSnow,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: <Widget>[
                    _title,
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: _subtitle,
                    ),
                    calendarCarousel(),
                    Padding(
                      padding: const EdgeInsets.only(top: 0, bottom: 30),
                      child: _location,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: _timeStart,
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          Expanded(
                            child: _timeEnd,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        color: ColorsPalette.accentColor,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: GestureDetector(
            onTap: () async {
              if (isValidForm()) {
                saveDataForm();

                List<Occurrence> occurrences = new List();

                occurrences.add(Occurrence(
                    local: _localValue,
                    date: DateFormat('yyyy-MM-dd').format(_date),
                    timeStart: _timeStartValue,
                    timeEnd: _timeEndValue,
                    qrCode: ""));

                if (widget.event == null) {
                  _eventId = await _createEvent(model.Event(
                      title: widget.eventName,
                      descripton: "Custom Description"));

                  await _createEventOccurrences(_eventId, occurrences);

                  Navigator.push(
                    context,
                    FadeRoute(
                      page: HomeEventManagement(
                        currentUser: widget.currentUser,
                        onSignedOut: widget.onSignedOut,
                      ),
                    ),
                  );
                } else {
                  _eventId = widget.event.id;

                  await _createEventOccurrences(_eventId, occurrences);

                  Navigator.push(
                    context,
                    FadeRoute(
                      page: EventDetails(
                        event: widget.event,
                        currentUser: widget.currentUser,
                        onSignedOut: widget.onSignedOut,
                      ),
                    ),
                  );
                }
              }
            },
            child: _labelCreateEvent,
          ),
        ),
      ),
    );
  }

  /// Build app bar
  Widget _buildAppBar(context) {
    return AppBar(
      title: Text(
        '',
        style: TextStyle(color: ColorsPalette.textColorLight),
      ),
      elevation: 0.0,
      backgroundColor: ColorsPalette.backgroundColorLight,
      leading: IconButton(
        icon: Icon(
          Icons.close,
          color: ColorsPalette.textColorDark,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      iconTheme: IconThemeData(color: ColorsPalette.textColorLight),
    );
  }

  /// Build Calendar
  Widget calendarCarousel() {
    double itemWidth = MediaQuery.of(context).size.width / 5;
    double itemHeight = 400 / 5;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
      child: CalendarCarousel<Event>(
          onDayPressed: (DateTime date, List<Event> events) {
            setState(() {
              if (date == currentdate) {
                _todayTextStyle =
                    TextStyle(fontSize: 14.0, color: Colors.white);
              } else {
                _todayTextStyle = TextStyle(
                    fontSize: 14.0,
                    color: Colors.green, // ALERT
                    fontWeight: FontWeight.w500);
              }
              _date = date;
              _todayButtonColor = Colors.transparent;
            });
            events.forEach((event) => print(event.title));
          },
          todayButtonColor: _todayButtonColor,
          todayTextStyle: _todayTextStyle,
          weekendTextStyle: TextStyle(color: ColorsPalette.accentColor),
          headerTextStyle:
              TextStyle(fontSize: 20.0, color: ColorsPalette.primaryColor),
          iconColor: ColorsPalette.primaryColor,
          weekFormat: false,
          height: 420.0,
          daysHaveCircularBorder: null,
          selectedDayButtonColor: ColorsPalette.accentColor,
          selectedDateTime: _date,
          customGridViewPhysics: NeverScrollableScrollPhysics(),
          isScrollable: false,
          pageSnapping: false,
          childAspectRatio: itemWidth / itemHeight),
    );
  }

  /// Create Event
  Future<String> _createEvent(model.Event item) async {
    final eventId = await FirebaseService.createEvent(item);
    return eventId;
  }

  /// Create Occurrences
  Future<void> _createEventOccurrences(
      String eventId, List<Occurrence> occurrences) async {
    await FirebaseService.createEventOccurrences(eventId, occurrences);
  }

  /// Check if form is valid
  bool isValidForm() {
    return _formKey.currentState.validate();
  }

  /// Save form
  void saveDataForm() {
    _formKey.currentState.save();
  }
}
