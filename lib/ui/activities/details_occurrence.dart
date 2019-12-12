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

class DetailsOccurrence extends StatefulWidget {
  final Occurrence occurrence;
  final Event event;
  final VoidCallback onSignedOut;
  final FirebaseUser currentUser;

  DetailsOccurrence(
      {this.occurrence, this.event, this.onSignedOut, this.currentUser});

  @override
  _DetailsOccurrenceState createState() => _DetailsOccurrenceState();
}

class _DetailsOccurrenceState extends State<DetailsOccurrence> {
  GlobalKey _qrCodeImageKey = new GlobalKey();
  bool _showQrCode = false;
  String _qrCodeValue;
  static const channel = const MethodChannel('flutter.native/share');

  @override
  void initState() {
    super.initState();
    if (widget.occurrence.qrCode == "") {
      print('generated_database');
      _generateQrCode();
      // setState(() {
      //   this._showQrCode = false;
      // });
    } else {
      setState(() {
        // this._showQrCode = true;
        print('created qrcode widget');
        this._qrCodeValue =
            '${widget.occurrence.id}mypresence${widget.event.id}';

        print('EVENT => ${widget.event.id}');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Column(
              children: <Widget>[
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                        capitalize(Jiffy(widget.occurrence.date).yMMMMEEEEd),
                        style: TextStyle(
                          inherit: true,
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        )),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Card(
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              // leading: Icon(Icons.schedule),
                              title: Center(
                                child: Text(
                                  widget.occurrence.timeStart,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 22,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Icon(
                        Icons.schedule,
                        size: 32,
                      ),
                    ),
                    Expanded(
                      child: Card(
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              // leading: Icon(Icons.schedule),
                              title: Center(
                                child: Text(
                                  widget.occurrence.timeEnd,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 22,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
                  child: Text(
                    widget.occurrence.local,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
                  ),
                ),
                _buildQrCode(value: _qrCodeValue),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///
  Widget _buildAppBar() {
    return AppBar(
      title: Text(
        'Detalhes da Ocorrência',
        style: TextStyle(color: ColorsPalette.textColorLight),
      ),
      iconTheme: IconThemeData(color: ColorsPalette.textColorLight),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.delete_forever),
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Confirmar exclusão'),
                    content: Text(
                        'Você tem certeza que deseja excluir essa ocorrência?'),
                    actions: <Widget>[
                      FlatButton(
                        child: new Text(
                          "Cancelar",
                          style:
                              TextStyle(color: ColorsPalette.textColorDark90),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      FlatButton(
                        child: Text(
                          'Excluir',
                          style: TextStyle(color: Colors.red),
                        ),
                        onPressed: () {
                          FirebaseService.deleteEventOccurrences(
                              widget.event, widget.occurrence.id);

                          FirebaseService.getEventParticipants(widget.event.id)
                              .then((participants) async {
                            print(participants.length);
                            for (var item in participants) {
                              await FirebaseService.deleteOccurrenceGroupByDate(
                                  item.id, widget.event.id,
                                  occurrenceId: widget.occurrence.id);
                            }
                          });
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            FadeRoute(
                              page: EventDetails(
                                event: widget.event,
                                onSignedOut: widget.onSignedOut,
                                currentUser: widget.currentUser,
                              ),
                            ),
                          );
                        },
                      )
                    ],
                  );
                });
          },
        )
      ],
    );
  }

  /// Generate QR Code
  void _generateQrCode() {
    setState(() {
      this._showQrCode = true;
      this._qrCodeValue = '${widget.occurrence.id}mypresence${widget.event.id}';
    });
    Occurrence item = widget.occurrence;
    item.qrCode = _qrCodeValue;
    FirebaseService.updateEventOccurrence(widget.event.id, item);
  }

  /// Creates a QR Code
  Widget _buildQrCode({@required String value}) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: GestureDetector(
        onTap: _shareQrCode,
        child: RepaintBoundary(
          key: _qrCodeImageKey,
          child: Container(
            color: ColorsPalette.backgroundColorLight,
            child: QrImage(
              data: value,
              version: QrVersions.auto,
              size: 250,
              gapless: true,
            ),
          ),
          // ),
        ),
      ),
    );
  }

  //
  Future<void> _shareQrCode() async {
    try {
      RenderRepaintBoundary boundary =
          _qrCodeImageKey.currentContext.findRenderObject();
      var image = await boundary.toImage();
      ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();

      final tempDir = await getTemporaryDirectory();
      var file = await new File('${tempDir.path}/image.png').create();
      await file.writeAsBytes(pngBytes);

      await channel.invokeMethod('shareImage', {
        'path': 'image.png',
        'message':
            'Evento: ${widget.event.title} \nData: ${capitalize(Jiffy(widget.occurrence.date).MMMMEEEEd)}'
      });
    } catch (e) {
      print(e.toString());
    }
  }

  ///
  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
}
