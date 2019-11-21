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
      backgroundColor: ColorsPalette.backgroundColorLight,
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
          child: cet.ExpansionTile(
        title: Text(
          'Thursday, July 1',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        headerBackgroundColor: ColorsPalette.expansionParentHeaderColor,
        backgroundColor: ColorsPalette.backgroundColorLight,
        iconColor: Colors.white,
        children: _listEventsWidgets(),
      ),
    ));

    list.add(Container(
          
          margin: new EdgeInsets.only(bottom: 10),

          child: cet.ExpansionTile(
        title: Text(
          'Friday, July 2',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        headerBackgroundColor: ColorsPalette.expansionParentHeaderColor,
        backgroundColor: ColorsPalette.expansionParentHeaderColor,
        iconColor: Colors.white,
        children: _listEventsWidgets(),
      ),
    ));

    list.add(Container(
          margin: new EdgeInsets.only(bottom: 10),
          child: cet.ExpansionTile(
        title: Text(
          'Saturday, July 3',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        headerBackgroundColor: ColorsPalette.expansionParentHeaderColor,
        backgroundColor: ColorsPalette.expansionParentHeaderColor,
        iconColor: Colors.white,
        children: _listEventsWidgets(),
      ),
    ));

list.add(Container(
          margin: new EdgeInsets.only(bottom: 10),
          child: cet.ExpansionTile(
        title: Text(
          'Monday, July 4',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        headerBackgroundColor: ColorsPalette.expansionParentHeaderColor,
        backgroundColor: ColorsPalette.expansionParentHeaderColor,
        iconColor: Colors.white,
        children: _listEventsWidgets(),
      ),
    ));
    return list;
  }

  /// List of Events (Widget)
  List<Widget> _listEventsWidgets() {
    List<Widget> list = new List();

    list.add(ListTileItem(
      colorHeader: ColorsPalette.backgroundColorLightGray,
      eventName: 'First Event',
      eventTime: '7:00',
    ));

    list.add(ListTileItem(
      colorHeader: ColorsPalette.backgroundColorLight,
      eventName: 'Second Event',
      eventTime: '9:00',
    ));

    list.add(ListTileItem(
      colorHeader: ColorsPalette.backgroundColorLightGray,
      eventName: 'Third Event',
      eventTime: '11:00',
      divider: false,
    ));

    return list;
  }
}
