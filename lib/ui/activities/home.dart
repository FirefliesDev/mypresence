import 'dart:collection';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jiffy/jiffy.dart';
import 'package:mypresence/authentication/base_auth.dart';
import 'package:mypresence/database/firebase_service.dart';
import 'package:mypresence/model/event.dart';
import 'package:mypresence/model/item.dart';
import 'package:mypresence/model/occurrence.dart';
import 'package:mypresence/model/user.dart';
import 'package:mypresence/ui/widgets/custom_expansion_tile.dart' as cet;
import 'package:mypresence/ui/widgets/custom_list_tile_item.dart';

import 'package:mypresence/ui/widgets/navigation_drawer.dart';
import 'package:mypresence/utils/colors_palette.dart';

class Home extends StatefulWidget {
  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final FirebaseUser currentUser;

  Home({this.auth, this.currentUser, this.onSignedOut});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _resultQrCode = "";
  List<Event> events = new List();
  Map<dynamic, dynamic> jsonOccurrenceByDate;
  List<Occurrence> occurrences = new List();

  @override
  void initState() {
    super.initState();
    // FirebaseService.updateParticipantEvents(Event(id: "-Lva7i4WI4HCTEgLZZoc"));
  }

  @override
  Widget build(BuildContext context) {
    return _buildScaffold();
  }

  /// Creates a Scaffold
  Widget _buildScaffold() {
    return Scaffold(
        backgroundColor: ColorsPalette.backgroundColorSnow,
        appBar: _buildAppBar(),
        drawer: NavigationDrawer(
          user: widget.currentUser,
          email: widget.currentUser.email,
          photoUrl: widget.currentUser.photoUrl,
          onSignedOut: _signedOut,
        ),
        body: StreamBuilder(
          stream:
              FirebaseService.getOccurrencesGroupByDate(widget.currentUser.uid),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final value = snapshot.data.snapshot.value as Map;
              jsonOccurrenceByDate = value;
              return _buildList();
            } else {
              return Center(
                child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(ColorsPalette.primaryColor),
                ),
              );
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
            elevation: 0.0,
            child: Icon(Icons.camera_alt),
            backgroundColor: ColorsPalette.accentColor,
            onPressed: () {
              _scanQrCode();
            }));
  }

  ///
  Widget _buildAppBar() {
    return AppBar(
      title: Text(
        'Meus Eventos',
        style: TextStyle(color: ColorsPalette.textColorLight),
      ),
      iconTheme: IconThemeData(color: ColorsPalette.textColorLight),
    );
  }

  ///
  Widget _buildList() {
    return ListView.builder(
      itemCount: jsonOccurrenceByDate == null ? 0 : jsonOccurrenceByDate.length,
      itemBuilder: (context, index) {
        List<Occurrence> occurences = new List();

        final sorted = new SplayTreeMap.from(jsonOccurrenceByDate, (a, b) {
          return a.toString().compareTo(b.toString());
        });

        sorted.entries.toList()[index].value.forEach((k, v) {
          Occurrence item = Occurrence.fromJson(v);
          occurences.add(item);
        });

        return Column(
          children: <Widget>[
            Container(
              child: cet.ExpansionTile(
                title: Container(
                  child: Text(
                    Jiffy(sorted.entries.toList()[index].key).MMMMEEEEd,
                    style: TextStyle(
                      color: ColorsPalette.textColorDark,
                    ),
                  ),
                ),
                headerBackgroundColor: ColorsPalette.accentColor,
                backgroundColor: Colors.white,
                iconColor: Colors.black,
                // children: <Widget>[Text('Testing performance')],
                children: _listEventsWidgets(itens: occurences),
                // _listEventsWidgets(itens: occurences),
              ),
            ),
            Divider(
              color: ColorsPalette.textColorDark90,
              height: 0,
            )
          ],
        );
      },
    );
  }

  ///
  List<Widget> _listEventsWidgets({List<Occurrence> itens}) {
    List<Widget> list = new List();
    for (var item in itens) {
      var eventId = substringAfter("mypresence", item.qrCode);
      list.add(FutureBuilder(
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Event event = snapshot.data;
            return Container(
              margin: EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
              child: ListTileItem(
                eventName: event.title,
                eventTime: item.timeStart,
                location: item.local,
                colorHeader: ColorsPalette.primaryColorLight,
                colorEventName: ColorsPalette.backgroundColorLight,
                colorEventTime: ColorsPalette.backgroundColorLight,
                divider: false,
                count: int.parse(event.countParticipants),
                onTap: () {
                  _showDialog(occurrence: item, event: event);
                },
              ),
            );
          } else {
            return Container();
          }
        },
        future: getEventsById(eventId),
      ));
    }
    return list;
  }

  ///
  Future getEventsById(String eventId) async {
    return await FirebaseService.getEventById(eventId);
  }

  ///
  void _signedOut() async {
    try {
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  //Dialog Eventos
  void _showDialog({Occurrence occurrence, Event event}) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: new Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: Text(
                    event.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 40),
                  child: Text(
                    event.descripton,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                  ),
                ),
                Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: Icon(
                            Icons.date_range,
                            color: Colors.indigo,
                            size: 24,
                          ),
                        ),
                        Text(
                          Jiffy(occurrence.date).MMMMEEEEd,
                          style: TextStyle(
                            inherit: true,
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      color: ColorsPalette.textColorDark50,
                      height: 20,
                      indent: 5.0,
                      endIndent: 5.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 5),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(right: 5),
                                  child: Icon(
                                    Icons.schedule,
                                    color: Colors.teal,
                                    size: 24,
                                  ),
                                ),
                                Column(
                                  children: <Widget>[
                                    Text(
                                      occurrence.timeStart,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 3),
                                  child: Text(
                                    'às',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                Column(
                                  children: <Widget>[
                                    Text(
                                      occurrence.timeEnd,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Divider(
                      color: ColorsPalette.textColorDark50,
                      height: 20,
                      indent: 5.0,
                      endIndent: 5.0,
                    ),
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: Icon(
                            Icons.location_on,
                            color: Colors.red,
                            size: 24,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            occurrence.local,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text("Fechar"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  /// Scan QR Code
  Future<void> _scanQrCode() async {
    try {
      String qrResult = await BarcodeScanner.scan();
      print('qrResult => ' + qrResult);

      final qrOccurrenceId = substringBefore("mypresence", qrResult);
      final qrEventId = substringAfter("mypresence", qrResult);
      final qrEvent = await FirebaseService.getEventById(qrEventId);
      final qrOccurrence =
          await FirebaseService.getOccurrenceById(qrEventId, qrOccurrenceId);

      print('qrOccurence => ' + qrOccurrence.local);

      setState(() {
        _resultQrCode = qrResult;
        print('result qr code ' + _resultQrCode);
      });
      User _user = User(
          id: widget.currentUser.uid,
          displayName: widget.currentUser.displayName,
          identifier: widget.currentUser.email,
          photoUrl: widget.currentUser.photoUrl,
          provider: 'Google');
      await _createEventParticipants(qrEvent, _user);
      await _createParticipantEvents(widget.currentUser.uid, qrEvent);
      await _createOccurrenceGroupByDate(widget.currentUser.uid, qrOccurrence);
      final _ocurrences = await FirebaseService.getEventOccurrences(qrEventId);
      await FirebaseService.createAttendanceSheet(_ocurrences, _user);

      FirebaseService.updateAttendanceSheet(qrOccurrenceId, _user.id);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          _resultQrCode = "Camera permission was denied";
        });
      } else {
        print("Unknown Error1: $e");
        setState(() {
          _resultQrCode = "Unknown Error: $e";
        });
      }
    } on FormatException {
      setState(() {
        _resultQrCode = "You pressed the back button before scanning anything";
      });
    } catch (e) {
      print("Unknown Error2: $e");
      setState(() {
        _resultQrCode = "Unknown Error: $e";
      });
    }
  }

  /// Create OwnerEvents
  Future<void> _createOccurrenceGroupByDate(
      String userId, Occurrence occurrence) async {
    await FirebaseService.createOccurrenceGroupByDate(userId, occurrence);
  }

  /// Create OwnerEvents
  Future<void> _createEventParticipants(Event event, User user) async {
    await FirebaseService.createEventParticipants(event, user);
  }

  /// Create ParticipantEvents
  Future<void> _createParticipantEvents(String userId, Event item) async {
    await FirebaseService.createParticipantEvents(userId, item);
  }

  String substringBefore(String delimiter, String text) {
    var index = text.indexOf(delimiter); // 13
    return text.substring(0, index);
  }

  String substringAfter(String delimiter, String text) {
    var index = text.indexOf(delimiter);
    return text.substring(index + delimiter.length, text.length);
  }
}
