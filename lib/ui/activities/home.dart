import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mypresence/authentication/base_auth.dart';
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
  //Dialog Eventos
  void _showDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Row(
              children: <Widget>[
                Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 25,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Text("T12 - B202"),
                  ),
                ),
                Expanded(
                  child: Row(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: Icon(Icons.schedule,
                            color: ColorsPalette.primaryColor, size: 22),
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
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            "17:00",
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
            content: new Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    'Palestra - Projeto Ágil',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    'Palestra sobre design, onde iremos abordar sobre todos '
                    'os tipos de prototipação',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: new Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
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
        body: SingleChildScrollView(
          child: Container(
            child: Container(
              // margin: new EdgeInsets.all(0.0),
              child: Column(
                children: _listOccurrencesWidgets(),
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
            elevation: 0.0,
            child: Icon(Icons.camera_alt),
            backgroundColor: ColorsPalette.accentColor,
            onPressed: () {
              print('Clicked');
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
  void _signedOut() async {
    try {
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  /// List of Occurrences (Widget)
  List<Widget> _listOccurrencesWidgets() {
    List<Widget> list = new List();
    list.add(
      Container(
        // margin: new EdgeInsets.only(bottom: 10),
        color: ColorsPalette.backgroundColorSnow,
        child: Column(
          children: <Widget>[
            Container(
              child: cet.ExpansionTile(
                title: Container(
                  child: Text(
                    'Thursday, July 1',
                    style: TextStyle(
                      color: ColorsPalette.textColorDark,
                    ),
                  ),
                ),
                headerBackgroundColor: ColorsPalette.accentColor,
                backgroundColor: Colors.white,
                iconColor: Colors.black,
                children: _listEventsWidgets(),
              ),
            ),
            Divider(
              color: ColorsPalette.textColorDark90,
              height: 0,
            )
          ],
        ),
      ),
    );

    list.add(
      Container(
        // margin: new EdgeInsets.only(bottom: 10),
        color: ColorsPalette.backgroundColorSnow,
        child: Column(
          children: <Widget>[
            Container(
              child: cet.ExpansionTile(
                title: Container(
                  child: Text(
                    'Thursday, July 1',
                    style: TextStyle(
                      color: ColorsPalette.textColorDark,
                    ),
                  ),
                ),
                headerBackgroundColor: ColorsPalette.accentColor,
                backgroundColor: Colors.white,
                iconColor: Colors.black,
                children: _listEventsWidgets(),
              ),
            ),
            Divider(
              color: ColorsPalette.textColorDark90,
              height: 0,
            )
          ],
        ),
      ),
    );

    return list;
  }

  /// List of Events (Widget)
  List<Widget> _listEventsWidgets() {
    List<Widget> list = new List();

    list.add(
      Container(
        margin: EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
        child: ListTileItem(
          eventName: 'First Event Thiago',
          eventTime: '14:00',
          location: 'location',
          colorHeader: ColorsPalette.primaryColorLight,
          colorEventName: ColorsPalette.backgroundColorLight,
          colorEventTime: ColorsPalette.backgroundColorLight,
          divider: false,
          onTap: () {
            print('Clicked');

            // Navigator.push(
            //   context,
            //   FadeRoute(
            //     page: EventDetails(),
            //   ),
            // );
            _showDialog();
          },
        ),
      ),
    );

    list.add(
      Container(
        margin: EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
        child: ListTileItem(
          eventName: 'Second Event',
          eventTime: '14:00',
          location: 'location',
          count: 35,
          colorHeader: ColorsPalette.primaryColorLight,
          colorEventName: ColorsPalette.backgroundColorLight,
          colorEventTime: ColorsPalette.backgroundColorLight,
          divider: false,
        ),
      ),
    );

    return list;
  }
}
