import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mypresence/database/firebase_service.dart';
import 'package:mypresence/model/event.dart';
import 'package:mypresence/ui/activities/create_event_name.dart';
import 'package:mypresence/ui/activities/event_details_management.dart';
import 'package:mypresence/ui/widgets/custom_list_tile_item.dart';
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
  List<Event> events = new List();
  var _future;

  @override
  void initState() {
    super.initState();
    _future = FirebaseService.getEvents();
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
        body: FutureBuilder(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              events = snapshot.data;
              print(events);
              return _buildList();
            } else {
              return Center(
                child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(ColorsPalette.primaryColor),
                ),
              );
            }
          },
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

  ///
  Widget _buildList() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      itemCount: events == null ? 0 : events.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(0, 5.0, 0, 0),
          child: ListTileItem(
            eventName: events[index].title,
            colorHeader: ColorsPalette.primaryColorLight,
            colorEventName: ColorsPalette.backgroundColorLight,
            colorEventTime: ColorsPalette.backgroundColorLight,
            divider: false,
            onTap: () {
              print('Clicked -> ${events[index].toJson()}');
              Navigator.push(
                context,
                FadeRoute(
                  page: EventDetails(
                    event: events[index],
                    currentUser: widget.currentUser,
                    onSignedOut: widget.onSignedOut,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
