import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:jiffy/jiffy.dart';
import 'package:mypresence/database/firebase_service.dart';
import 'package:mypresence/model/event.dart';
import 'package:mypresence/model/occurrence.dart';
import 'package:mypresence/utils/colors_palette.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class DetailsOccurrence extends StatefulWidget {
  final Occurrence occurrence;
  final Event event;

  DetailsOccurrence({this.occurrence, this.event});

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
      setState(() {
        this._showQrCode = false;
      });
    } else {
      setState(() {
        this._showQrCode = true;
        this._qrCodeValue = '${widget.occurrence.id}mypresence';
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

                // Row(
                //   children: <Widget>[
                //     Expanded(
                //       child: Card(
                //         child: Column(
                //           children: <Widget>[
                //             ListTile(
                //               leading: Icon(Icons.schedule),
                //               title: Text(
                //                 capitalize(Jiffy(widget.occurrence.date).MMMEd),
                //                 // Jiffy(widget.occurrence.date).yMMMMd,
                //                 // widget.occurrence.date,
                //                 style: TextStyle(
                //                   inherit: true,
                //                   fontWeight: FontWeight.w400,
                //                   fontSize: 16,
                //                 ),
                //               ),
                //               subtitle: Text(
                //                 widget.occurrence.timeStart,
                //                 style: TextStyle(
                //                   fontWeight: FontWeight.w800,
                //                   fontSize: 22,
                //                 ),
                //               ),
                //             )
                //           ],
                //         ),
                //       ),
                //       // child: Container(
                //       //   margin: EdgeInsets.fromLTRB(15, 15, 3, 5),
                //       //   height: 80.0,
                //       //   child: Row(
                //       //     children: <Widget>[
                //       //       Container(
                //       //           margin: EdgeInsets.symmetric(horizontal: 15),
                //       //           width: 30.0,
                //       //           height: 30.0,
                //       //           child: Icon(Icons.schedule)),
                //       //       Column(
                //       //         mainAxisAlignment: MainAxisAlignment.center,
                //       //         crossAxisAlignment: CrossAxisAlignment.start,
                //       //         children: <Widget>[
                //       //           Text(
                //       //             capitalize(Jiffy(widget.occurrence.date).MMMEd),
                //       //             // Jiffy(widget.occurrence.date).yMMMMd,
                //       //             // widget.occurrence.date,
                //       //             style: TextStyle(
                //       //               inherit: true,
                //       //               fontWeight: FontWeight.w400,
                //       //               fontSize: 16,
                //       //             ),
                //       //           ),
                //       //           Text(
                //       //             widget.occurrence.timeStart,
                //       //             style: TextStyle(
                //       //               fontWeight: FontWeight.w800,
                //       //               fontSize: 22,
                //       //             ),
                //       //           ),
                //       //         ],
                //       //       ),
                //       //     ],
                //       //   ),
                //       //   decoration: new BoxDecoration(color: Colors.black12),
                //       // ),
                //     ),
                //     Expanded(
                //       child: Container(
                //         margin: EdgeInsets.fromLTRB(3, 15, 15, 5),
                //         height: 80.0,
                //         child: Row(
                //           children: <Widget>[
                //             Container(
                //               margin: EdgeInsets.symmetric(horizontal: 15),
                //               width: 30.0,
                //               height: 30.0,
                //               child: Icon(Icons.schedule),
                //             ),
                //             Column(
                //               mainAxisAlignment: MainAxisAlignment.center,
                //               crossAxisAlignment: CrossAxisAlignment.start,
                //               children: <Widget>[
                //                 Text(
                //                   capitalize(Jiffy(widget.occurrence.date).MMMEd),
                //                   style: TextStyle(
                //                     inherit: true,
                //                     fontWeight: FontWeight.w400,
                //                     fontSize: 16,
                //                   ),
                //                 ),
                //                 Text(
                //                   widget.occurrence.timeEnd,
                //                   style: TextStyle(
                //                     fontWeight: FontWeight.w800,
                //                     fontSize: 22,
                //                   ),
                //                 ),
                //               ],
                //             ),
                //           ],
                //         ),
                //         decoration: new BoxDecoration(color: Colors.black12),
                //       ),
                //     ),
                //   ],
                // ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
                  child: Text(
                    widget.occurrence.local,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
                  ),
                ),
                Visibility(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: ButtonTheme(
                      minWidth: 200.0,
                      height: 45.0,
                      child: RaisedButton(
                        onPressed: _generateQrCode,
                        color: ColorsPalette.accentColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                        ),
                        child: const Text('Gerar QRCode',
                            style:
                                TextStyle(fontSize: 20, color: Colors.white)),
                      ),
                    ),
                  ),
                  visible: !_showQrCode,
                ),
                Visibility(
                  child: _buildQrCode(value: _qrCodeValue),
                  visible: _showQrCode,
                ),
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

      print('${tempDir.path}/image.png');
//intent.putExtra(Intent.EXTRA_TEXT, "Evento: " + event.name + "\nData: " + data)
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
