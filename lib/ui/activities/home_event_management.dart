import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mypresence/authentication/authentication.dart';
import 'package:mypresence/ui/activities/create_event_name.dart';
import 'package:mypresence/ui/widgets/navigation_drawer.dart';
import 'package:mypresence/utils/colors_palette.dart';
import 'package:mypresence/utils/transitions/fade_route.dart';
import 'package:mypresence/utils/transitions/slide_route.dart';

class HomeEventManagement extends StatefulWidget {
  final VoidCallback onSignedOut;
  final FirebaseUser currentUser;

  HomeEventManagement({this.currentUser, this.onSignedOut});

  @override
  _HomeEventManagementState createState() => _HomeEventManagementState();
}

class _HomeEventManagementState extends State<HomeEventManagement> {
  // FirebaseUser _currentUser;
  // VoidCallback _onSignedOut;
  // @override
  // void initState() async {
  //   super.initState();
  //   final user = await Authentication().currentUser();
  //   this._currentUser = user;
  //   _onSignedOut = () {};
  // }

  @override
  Widget build(BuildContext context) {
    return _buildScaffold();
  }

  /// Creates a Scaffold
  Widget _buildScaffold() {
    return Scaffold(
        backgroundColor: ColorsPalette.backgroundColorSnow,
        appBar: _buildAppBar(),
        body: SingleChildScrollView(
          child: Center(
            child: Text(
              "My List",
              textAlign: TextAlign.center,
            ),
          ),
        ),
        drawer: NavigationDrawer(
          user: widget.currentUser,
          email: widget.currentUser.email,
          photoUrl: widget.currentUser.photoUrl,
          onSignedOut: widget.onSignedOut,
        ),
        floatingActionButton: FloatingActionButton(
            elevation: 0.0,
            child: Icon(Icons.add),
            backgroundColor: ColorsPalette.accentColor,
            onPressed: () {
              Navigator.push(
                context,
                SlideTopRoute(
                  page: CreateEventName(
                    currentUser: widget.currentUser,
                    onSignedOut: widget.onSignedOut,
                  ),
                ),
              );
            }));
  }

  ///
  Widget _buildAppBar() {
    return AppBar(
      title: Text(
        'Gestão de Eventos',
        style: TextStyle(color: ColorsPalette.textColorLight),
      ),
      iconTheme: IconThemeData(color: ColorsPalette.textColorLight),
    );
  }
}
