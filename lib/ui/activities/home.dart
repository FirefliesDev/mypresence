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
            margin: new EdgeInsets.all(15.0),
            child: Column(
              children: _listOccurrencesWidgets(),
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
        'Home',
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

    list.add(Container(
      margin: new EdgeInsets.only(bottom: 10),
      color: ColorsPalette.backgroundColorCello,
      child: Container(
        child: cet.ExpansionTile(
          title: Container(
            child: Text(
              'Thursday, July 1',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          headerBackgroundColor: ColorsPalette.backgroundColorCello,
          backgroundColor: ColorsPalette.backgroundColorLight,
          iconColor: Colors.white,
          children: _listEventsWidgets(),
        ),
      ),
    ));

    list.add(Container(
      margin: new EdgeInsets.only(bottom: 10),
      color: ColorsPalette.backgroundColorCello,
      child: cet.ExpansionTile(
        title: Text(
          'Friday, July 2',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        headerBackgroundColor: ColorsPalette.backgroundColorCello,
        backgroundColor: ColorsPalette.backgroundColorLight,
        iconColor: Colors.white,
        children: _listEventsWidgets(),
      ),
    ));

    list.add(Container(
      margin: new EdgeInsets.only(bottom: 10),
      color: ColorsPalette.backgroundColorCello,
      child: cet.ExpansionTile(
        title: Text(
          'Saturday, July 3',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        headerBackgroundColor: ColorsPalette.backgroundColorCello,
        backgroundColor: ColorsPalette.backgroundColorLight,
        iconColor: Colors.white,
        children: _listEventsWidgets(),
      ),
    ));

    list.add(Container(
      margin: new EdgeInsets.only(bottom: 10),
      color: ColorsPalette.backgroundColorCello,
      child: cet.ExpansionTile(
        title: Text(
          'Monday, July 4',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        headerBackgroundColor: ColorsPalette.backgroundColorCello,
        backgroundColor: ColorsPalette.backgroundColorLight,
        iconColor: Colors.white,
        children: _listEventsWidgets(),
      ),
    ));
    return list;
  }

  /// List of Events (Widget)
  List<Widget> _listEventsWidgets() {
    List<Widget> list = new List();

    list.add(
      Container(
        margin: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 4.0),
        decoration: BoxDecoration(
          color: ColorsPalette.backgroundColorDanube,
          borderRadius: new BorderRadius.all(
            Radius.circular(5.0),
          ),
        ),
        child: Row(
          children: <Widget>[
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                margin: EdgeInsets.only(left: 15.0),
                width: 35.0,
                height: 35.0,
                decoration: new BoxDecoration(
                  color: Colors.amber,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '1',
                    style: TextStyle(
                      color: ColorsPalette.backgroundColorCello,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.topLeft,
                child: ListTileItem(
                  eventName: 'First Event',
                  eventTime: '7:00',
                  colorEventName: ColorsPalette.backgroundColorLight,
                  colorEventTime: ColorsPalette.backgroundColorLight,
                  divider: false,
                ),
              ),
            ),
          ],
        ),
      ),
    );

    list.add(
      Container(
        margin: EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
        decoration: BoxDecoration(
          color: ColorsPalette.backgroundColorDanube,
          borderRadius: new BorderRadius.all(
            Radius.circular(5.0),
          ),
        ),
        child: ListTileItem(
          colorHeader: Color(0xFFFFFF),
          eventName: 'Second Event',
          eventTime: '9:00',
          colorEventName: ColorsPalette.backgroundColorLight,
          colorEventTime: ColorsPalette.backgroundColorLight,
          divider: false,
        ),
      ),
    );

    list.add(
      Container(
        margin: EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 8.0),
        decoration: BoxDecoration(
          color: ColorsPalette.backgroundColorDanube,
          borderRadius: new BorderRadius.all(
            Radius.circular(5.0),
          ),
        ),
        child: ListTileItem(
          colorHeader: Color(0xFFFFFF),
          eventName: 'Third Event',
          eventTime: '11:00',
          colorEventName: ColorsPalette.backgroundColorLight,
          colorEventTime: ColorsPalette.backgroundColorLight,
          divider: false,
        ),
      ),
    );

    return list;
  }
}
