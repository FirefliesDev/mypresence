import 'dart:collection';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:jiffy/jiffy.dart';
import 'package:mypresence/database/firebase_service.dart';
import 'package:mypresence/model/event.dart';
import 'package:mypresence/model/occurrence.dart';
import 'package:mypresence/model/user.dart';
import 'package:mypresence/ui/activities/event_details_management.dart';
import 'package:mypresence/utils/colors_palette.dart';
import 'package:mypresence/utils/transitions/fade_route.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class AttendancesSheet extends StatefulWidget {
  final Occurrence occurrence;
  final Event event;
  final VoidCallback onSignedOut;
  final FirebaseUser currentUser;

  AttendancesSheet(
      {this.occurrence, this.event, this.onSignedOut, this.currentUser});

  @override
  _AttendancesSheetState createState() => _AttendancesSheetState();
}

class _AttendancesSheetState extends State<AttendancesSheet> {
  static const channel = const MethodChannel('flutter.native/share');
  Map<dynamic, dynamic> jsonAttendanceSheet;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: StreamBuilder(
        stream: FirebaseService.getAttendanceSheet(widget.occurrence.id),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final value = snapshot.data.snapshot.value as Map;
            jsonAttendanceSheet = value;
            return _buildAttendancesSheet();
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
    );
  }

  Widget _buildAttendancesSheet() {
    final String _emptyPhotoURL =
        "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png";
    return ListView.builder(
      itemCount: jsonAttendanceSheet == null ? 0 : jsonAttendanceSheet.length,
      itemBuilder: (context, index) {
        List<User> _participants = List();
        final sorted = new SplayTreeMap.from(jsonAttendanceSheet, (a, b) {
          return a.toString().compareTo(b.toString());
        });

        sorted.forEach((k, v) {
          User user = User.fromJson(v);
          user.present = v['present'];
          _participants.add(user);
        });

        print(jsonAttendanceSheet);
        return Padding(
          padding: index == 0
              ? const EdgeInsets.all(0)
              : const EdgeInsets.fromLTRB(0, 5.0, 0, 0),
          child: Column(
            children: <Widget>[
              _participants == null
                  ? Text('Nenhum participante encontrado.')
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 20),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: CircleAvatar(
                              radius: 25.0,
                              backgroundColor:
                                  ColorsPalette.backgroundColorLight,
                              backgroundImage: NetworkImage(
                                  _participants[index].photoUrl != null
                                      ? _participants[index].photoUrl
                                      : _emptyPhotoURL),
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
                                  _participants[index].displayName,
                                  style: TextStyle(
                                    inherit: true,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  _participants[index].identifier,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: 50,
                          width: 0.3,
                          color: ColorsPalette.textColorDark50,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 0),
                          child: _participants[index].present == true
                              ? Icon(
                                  Icons.sentiment_very_satisfied,
                                  color: Colors.green,
                                )
                              : Icon(
                                  Icons.sentiment_very_dissatisfied,
                                  color: Colors.red,
                                ),
                        ),
                      ],
                    ),
              Divider(
                indent: 30,
                endIndent: 30,
              ),
            ],
          ),
        );
      },
    );
  }

  ///
  Widget _buildAppBar() {
    return AppBar(
      title: Text(
        'Lista de presença',
        style: TextStyle(color: ColorsPalette.textColorLight),
      ),
      iconTheme: IconThemeData(color: ColorsPalette.textColorLight),
    );
  }

  ///
  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
}
