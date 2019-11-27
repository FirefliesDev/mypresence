import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mypresence/authentication/base_auth.dart';
import 'package:mypresence/ui/widgets/custom_expansion_tile.dart' as cet;
import 'package:mypresence/ui/widgets/custom_list_tile_item.dart';
import 'package:mypresence/ui/widgets/list_details.dart';
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
            onPressed: () {}));
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
          eventName: 'First Event',
          eventTime: '14:00',
          colorHeader: ColorsPalette.primaryColorLight,
          colorEventName: ColorsPalette.backgroundColorLight,
          colorEventTime: ColorsPalette.backgroundColorLight,
          divider: false,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ListDetails()),
            );
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
