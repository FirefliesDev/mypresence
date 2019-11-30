import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:mypresence/authentication/base_auth.dart';
import 'package:mypresence/ui/activities/home.dart';
import 'package:mypresence/ui/activities/sign_in.dart';
import 'package:mypresence/ui/widgets/list_details.dart';

enum AuthStatus { signIn, notSignIn }

class RootActivities extends StatefulWidget {
  final BaseAuth auth;
  RootActivities(this.auth);
  @override
  _RootActivitiesState createState() => _RootActivitiesState();
}

class _RootActivitiesState extends State<RootActivities> {
  AuthStatus _authStatus = AuthStatus.notSignIn;
  FirebaseUser _user;

  @override
  void initState() {
    super.initState();
    widget.auth.currentUser().then((user) {
      setState(() {
        _authStatus = user == null ? AuthStatus.notSignIn : AuthStatus.signIn;
        _user = user;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (_authStatus) {
      case AuthStatus.signIn:
        // return ListDetails();
        return Home(
            auth: widget.auth, onSignedOut: _signedOut, currentUser: _user);
      default:
        return SignIn(auth: widget.auth, onSignedIn: _signedIn);
    }
  }

  void _signedIn(FirebaseUser user) {
    setState(() {
      _authStatus = AuthStatus.signIn;
      _user = user;
    });
  }

  void _signedOut() {
    setState(() {
      _authStatus = AuthStatus.notSignIn;
      _user = null;
    });
  }
}
