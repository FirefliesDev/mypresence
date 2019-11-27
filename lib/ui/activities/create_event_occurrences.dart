import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:mypresence/utils/colors_palette.dart';

class CreateEventOccurrences extends StatefulWidget {
  @override
  _CreateEventOccurrencesState createState() => _CreateEventOccurrencesState();
}

class _CreateEventOccurrencesState extends State<CreateEventOccurrences> {
  static DateTime now = DateTime.now();
  DateTime currentdate = DateTime(now.year, now.month, now.day);
  //
  DateTime _date = now;

  Color _todayButtonColor = ColorsPalette.accentColor;
  TextStyle _todayTextStyle = TextStyle(fontSize: 14.0, color: Colors.white);
  @override
  Widget build(BuildContext context) {
    return _buildScaffold(context);
  }

  Widget calendarCarousel() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.0),
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

    final _timeStart = FlatButton(
        onPressed: () {
          DatePicker.showTimePicker(context, showTitleActions: true,
              onChanged: (date) {
            print('change $date');
          }, onConfirm: (date) {
            print('confirm $date');
          }, currentTime: DateTime.now(), locale: LocaleType.pt);
        },
        child: Text(
          'Start',
          style: TextStyle(color: Colors.blue),
        ));
    ;

    final _timeEnd = Text('End');

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
                    padding: const EdgeInsets.only(top: 15, bottom: 30),
                    child: _location,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[_timeStart, _timeEnd],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      bottomSheet: Container(
        width: double.infinity,
        color: ColorsPalette.accentColor,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: GestureDetector(
            onTap: () {},
            child: Text(
              "PRÓXIMO",
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
