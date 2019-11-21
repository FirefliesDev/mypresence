import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mypresence/authentication/base_auth.dart';
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
        body: Center(
          child: Text(widget.currentUser.displayName),
        ));
  }

  ///
  Widget _buildAppBar() {
    return AppBar(
      title: Text(
        'Home',
        style: TextStyle(color: ColorsPalette.textColorLight),
      ),
      actions: <Widget>[
        IconButton(
          onPressed: _signedOut,
          icon: Icon(Icons.exit_to_app),
          color: ColorsPalette.textColorDark,
        )
      ],
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
}
