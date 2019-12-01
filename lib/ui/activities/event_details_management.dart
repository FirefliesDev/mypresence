import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:jiffy/jiffy.dart';
import 'package:mypresence/database/firebase_service.dart';
import 'package:mypresence/model/event.dart';
import 'package:mypresence/model/occurrence.dart';
import 'package:mypresence/ui/activities/create_event_occurrences.dart';
import 'package:mypresence/ui/widgets/custom_expansion_tile.dart' as cet;
import 'package:mypresence/ui/widgets/custom_list_tile_item.dart';
import 'package:mypresence/ui/activities/details_occurrence.dart';
import 'package:mypresence/utils/colors_palette.dart';
import 'package:mypresence/utils/transitions/fade_route.dart';

class EventDetails extends StatefulWidget {
  final Event event;
  final VoidCallback onSignedOut;
  final FirebaseUser currentUser;

  EventDetails({this.event, this.onSignedOut, this.currentUser});

  @override
  _EventDetailsState createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  List<Occurrence> _occurrences = new List();
  var _futureOccurrence;

  // TODO: List participants

  @override
  void initState() {
    super.initState();
    changeDefaultLocale();
    _futureOccurrence = FirebaseService.getEventOccurrences(widget.event.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(25, 25, 25, 10),
                child: Text(
                  widget.event == null ? 'My Event' : widget.event.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                child: Text(
                  'Palestra sobre design, onde iremos abordar sobre todos '
                  'os tipos de prototipação',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                ),
              ),
              cet.ExpansionTile(
                title: Container(
                  child: Text(
                    'Ocorrências',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 22,
                    ),
                  ),
                ),
                children: <Widget>[
                  FutureBuilder(
                    future: _futureOccurrence,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        _occurrences = snapshot.data;
                        // return Text('hey');
                        return _buildList();
                      } else {
                        return Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                ColorsPalette.primaryColor),
                          ),
                        );
                      }
                    },
                  )
                ],
              ),
              Divider(
                color: ColorsPalette.textColorDark50,
                indent: 15.0,
                endIndent: 15.0,
              ),
              cet.ExpansionTile(
                title: Container(
                  child: Text(
                    'Participantes',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 22,
                    ),
                  ),
                ),
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 7.5, horizontal: 15),
                          width: 50.0,
                          height: 50.0,
                          decoration: new BoxDecoration(
                            color: Colors.amber,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Nome",
                                style: TextStyle(
                                  inherit: true,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20,
                                ),
                              ),
                              Text(
                                "email",
                                style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  //REMOVER
                  Row(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 7.5, horizontal: 15),
                          width: 50.0,
                          height: 50.0,
                          decoration: new BoxDecoration(
                            color: Colors.amber,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Nome",
                                style: TextStyle(
                                  inherit: true,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20,
                                ),
                              ),
                              Text(
                                "email",
                                style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 7.5, horizontal: 15),
                          width: 50.0,
                          height: 50.0,
                          decoration: new BoxDecoration(
                            color: Colors.amber,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Nome",
                                style: TextStyle(
                                  inherit: true,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20,
                                ),
                              ),
                              Text(
                                "email",
                                style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: SpeedDial(
        marginRight: 18,
        marginBottom: 20,
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: IconThemeData(size: 22.0),
        closeManually: false,
        curve: Curves.bounceIn,
        overlayColor: Colors.black,
        overlayOpacity: 0.1,
        onOpen: () => print('OPENING DIAL'),
        onClose: () => print('DIAL CLOSED'),
        tooltip: 'Speed Dial',
        heroTag: 'speed-dial-hero-tag',
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 8.0,
        shape: CircleBorder(),
        children: [
          SpeedDialChild(
              child: Icon(Icons.person),
              backgroundColor: Colors.green,
              label: 'Novo Participante',
              labelStyle: TextStyle(fontSize: 18.0),
              onTap: () => print('add_participant')),
          SpeedDialChild(
            child: Icon(Icons.event),
            backgroundColor: Colors.blue,
            label: 'Nova Ocorrência',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () {
              Navigator.push(
                context,
                FadeRoute(
                  page: CreateEventOccurrences(
                    event: widget.event,
                    currentUser: widget.currentUser,
                    onSignedOut: widget.onSignedOut,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  ///
  void changeDefaultLocale() async {
    await Jiffy.locale("pt");
  }

  ///
  Widget _buildAppBar() {
    return AppBar(
      title: Text(
        'Gestão de Eventos',
        style: TextStyle(color: ColorsPalette.textColorLight),
      ),
      iconTheme: IconThemeData(color: ColorsPalette.textColorLight),
    );
  }

  ///
  Widget _buildList() {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      itemCount: _occurrences == null ? 0 : _occurrences.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: index == 0
              ? const EdgeInsets.all(0)
              : const EdgeInsets.fromLTRB(0, 5.0, 0, 0),
          child: ListTileItem(
            eventName: Jiffy(_occurrences[index].date).yMMMMd,
            eventTime: _occurrences[index].timeStart,
            location: _occurrences[index].local,
            colorHeader: ColorsPalette.primaryColorLight,
            colorEventName: ColorsPalette.backgroundColorLight,
            colorEventTime: ColorsPalette.backgroundColorLight,
            divider: false,
            showCount: false,
            onTap: () {
              Navigator.push(
                context,
                FadeRoute(
                  page: DetailsOccurrence(
                    occurrence: _occurrences[index],
                    event: widget.event,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}