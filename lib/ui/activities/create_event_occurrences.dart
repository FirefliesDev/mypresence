import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:mypresence/utils/colors_palette.dart';

import 'package:intl/intl.dart';

class CreateEventOccurrences extends StatefulWidget {
  @override
  _CreateEventOccurrencesState createState() => _CreateEventOccurrencesState();
}

class _CreateEventOccurrencesState extends State<CreateEventOccurrences> {
  TextEditingController _timeStartController;
  TextEditingController _timeEndController;
  static DateTime now = DateTime.now();
  DateTime currentdate = DateTime(now.year, now.month, now.day);
  //
  DateTime _date = now;

  Color _todayButtonColor = ColorsPalette.accentColor;
  TextStyle _todayTextStyle = TextStyle(fontSize: 14.0, color: Colors.white);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildScaffold(context);
  }

  Widget calendarCarousel() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 0.0),
      child: CalendarCarousel<Event>(
        onDayPressed: (DateTime date, List<Event> events) {
          // this.setState(() => );
          setState(() {
            if (date == currentdate) {
              _todayTextStyle = TextStyle(fontSize: 14.0, color: Colors.white);
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

        /// null for not rendering any border, true for circular border, false for rectangular border
      ),
    );
  }

  /// Creates a Scaffold
  Widget _buildScaffold(context) {
    final _location = TextFormField(
      validator: (input) =>
          input.isEmpty ? 'Digite o local do seu evento' : null,
      // onSaved: (input) => emailValue = input,
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
          });
        }, currentTime: DateTime.now(), locale: LocaleType.pt);
      },
      child: Align(
        alignment: Alignment.center,
        child: AbsorbPointer(
          child: TextFormField(
            controller: _timeStartController,
            validator: (input) => input.isEmpty ? 'Início' : null,
            // onSaved: (input) => emailValue = input,
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
          print('confirm $date');
          print('change ${date.hour}:${date.minute}');
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
          // onSaved: (input) => emailValue = input,
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

    return Scaffold(
      appBar: _buildAppBar(context),
      backgroundColor: ColorsPalette.backgroundColorSnow,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: <Widget>[
                  Text(
                    "Ocorrências",
                    style: TextStyle(
                        color: ColorsPalette.textColorDark,
                        fontSize: 24,
                        fontWeight: FontWeight.w700),
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Text(
                      "Informe a data, o local e a duração do seu evento. Você pode adicionar quantas datas quiser!",
                      style: TextStyle(
                          color: ColorsPalette.textColorDark90,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                      textAlign: TextAlign.center,
                    ),
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
      bottomNavigationBar: Container(
        width: double.infinity,
        color: ColorsPalette.accentColor,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: GestureDetector(
            onTap: () {},
            child: Text(
              "CRIAR EVENTO",
              style: TextStyle(
                  color: ColorsPalette.textColorLight,
                  fontWeight: FontWeight.w700,
                  fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  ///
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
}