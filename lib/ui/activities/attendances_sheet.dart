import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:jiffy/jiffy.dart';
import 'package:mypresence/database/firebase_service.dart';
import 'package:mypresence/model/event.dart';
import 'package:mypresence/model/occurrence.dart';
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
  GlobalKey _qrCodeImageKey = new GlobalKey();
  bool _showQrCode = false;
  String _qrCodeValue;
  static const channel = const MethodChannel('flutter.native/share');

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
          child: SafeArea(
        child: Text('List will be printed here'),
      )),
    );
  }

  // Widget _buildAttendancesSheet() {
  //   return ListView.builder(
  //     itemBuilder: (BuildContext context, int index) {
  //       return Padding(
  //         padding: index == 0
  //             ? const EdgeInsets.all(0)
  //             : const EdgeInsets.fromLTRB(0, 5.0, 0, 0),
  //         child: Column(
  //           children: <Widget>[
  //             _participants == null
  //                 ? Text('Nenhum participante encontrado.')
  //                 : Row(
  //                     children: <Widget>[
  //                       Padding(
  //                         padding: const EdgeInsets.symmetric(
  //                             vertical: 8, horizontal: 20),
  //                         child: Align(
  //                           alignment: Alignment.topLeft,
  //                           child: CircleAvatar(
  //                             radius: 25.0,
  //                             backgroundColor:
  //                                 ColorsPalette.backgroundColorLight,
  //                             backgroundImage: NetworkImage(
  //                                 _participants[index].photoUrl != null
  //                                     ? _participants[index].photoUrl
  //                                     : _emptyPhotoURL),
  //                           ),
  //                         ),
  //                       ),
  //                       Expanded(
  //                         child: Align(
  //                           alignment: Alignment.topLeft,
  //                           child: Column(
  //                             crossAxisAlignment: CrossAxisAlignment.start,
  //                             children: <Widget>[
  //                               Text(
  //                                 _participants[index].displayName,
  //                                 style: TextStyle(
  //                                   inherit: true,
  //                                   fontWeight: FontWeight.w500,
  //                                   fontSize: 18,
  //                                 ),
  //                               ),
  //                               Text(
  //                                 _participants[index].identifier,
  //                                 style: TextStyle(
  //                                   fontWeight: FontWeight.w300,
  //                                   fontSize: 14,
  //                                 ),
  //                               ),
  //                             ],
  //                           ),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //             Divider(
  //               indent: 30,
  //               endIndent: 30,
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

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
