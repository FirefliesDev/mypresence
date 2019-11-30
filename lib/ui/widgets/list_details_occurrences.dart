import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

// import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:mypresence/ui/widgets/custom_expansion_tile.dart' as cet;
import 'package:mypresence/utils/colors_palette.dart';

class ListDetailsOccurrences extends StatefulWidget {
  @override
  _ListDetailsOccurrencesState createState() => _ListDetailsOccurrencesState();
}

class _ListDetailsOccurrencesState extends State<ListDetailsOccurrences> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(15, 15, 3, 5),
                    height: 80.0,
                    child: Row(
                      children: <Widget>[
                        Container(
                            margin: EdgeInsets.symmetric(horizontal: 15),
                            width: 30.0,
                            height: 30.0,
                            child: Icon(Icons.schedule)),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Fri, Nov 29",
                              style: TextStyle(
                                inherit: true,
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              "17:00",
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 22,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    decoration: new BoxDecoration(color: Colors.black12),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(3, 15, 15, 5),
                    height: 80.0,
                    child: Row(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 15),
                          width: 30.0,
                          height: 30.0,
                          child: Icon(Icons.schedule),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Fri, Nov 29",
                              style: TextStyle(
                                inherit: true,
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              "20:00",
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 22,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    decoration: new BoxDecoration(color: Colors.black12),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
              child: Text(
                'Brasília, Águas Claras - UCB - 201',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(25),
              child: Container(
                height: 250,
                width: 250,
                decoration: new BoxDecoration(
                  color: Colors.black45,
                  shape: BoxShape.rectangle,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ButtonTheme(
                minWidth: 200.0,
                height: 45.0,
                child: RaisedButton(
                  onPressed: () {},
                  color: ColorsPalette.accentColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(25.0),
                  ),
                  child: const Text('Gerar QRCode',
                      style: TextStyle(fontSize: 20, color: Colors.white)),
                ),
              ),
            ),
          ],
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
}
