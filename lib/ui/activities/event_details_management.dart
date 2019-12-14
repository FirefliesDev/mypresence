import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jiffy/jiffy.dart';
import 'package:mypresence/database/firebase_service.dart';
import 'package:mypresence/model/event.dart';
import 'package:mypresence/model/occurrence.dart';
import 'package:mypresence/model/user.dart';
import 'package:mypresence/ui/activities/create_event_occurrences.dart';
import 'package:mypresence/ui/activities/create_new_participant.dart';
import 'package:mypresence/ui/activities/home_event_management.dart';
import 'package:mypresence/ui/widgets/custom_expansion_tile.dart' as cet;
import 'package:mypresence/ui/widgets/custom_list_tile_item.dart';
import 'package:mypresence/ui/activities/details_occurrence.dart';
import 'package:mypresence/utils/colors_palette.dart';
import 'package:mypresence/utils/transitions/fade_route.dart';
import 'package:mypresence/utils/transitions/slide_route.dart';

import 'dart:convert';

enum Action { edit, delete }

class EventDetails extends StatefulWidget {
  final Event event;
  final VoidCallback onSignedOut;
  final FirebaseUser currentUser;

  EventDetails({this.event, this.onSignedOut, this.currentUser});

  @override
  _EventDetailsState createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  List<Occurrence> _occurrences = new List();
  List<User> _participants = new List();
  User _tempParticipant;
  int _tempIndex;
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descController = TextEditingController();
  var _futureOccurrence;
  var _futureParticipants;

  // TODO: List participants

  @override
  void initState() {
    super.initState();
    changeDefaultLocale();
    _futureOccurrence = FirebaseService.getEventOccurrences(widget.event.id);
    _futureParticipants = FirebaseService.getEventParticipants(widget.event.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(25, 25, 25, 10),
                child: Text(
                  widget.event == null ? 'My Event' : widget.event.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                child: Text(
                  widget.event.descripton,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                ),
              ),
              cet.ExpansionTile(
                title: Container(
                  child: Text(
                    'Ocorrências',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                ),
                children: <Widget>[
                  FutureBuilder(
                    future: _futureOccurrence,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        _occurrences = snapshot.data;
                        // return Text('hey');
                        return _buildList();
                      } else {
                        return Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                ColorsPalette.primaryColor),
                          ),
                        );
                      }
                    },
                  )
                ],
              ),
              Divider(
                color: ColorsPalette.textColorDark50,
                indent: 15.0,
                endIndent: 15.0,
              ),
              cet.ExpansionTile(
                title: Container(
                  child: Text(
                    'Participantes',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                ),
                children: <Widget>[
                  FutureBuilder(
                    future: _futureParticipants,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        _participants = snapshot.data;
                        if (_participants != null) {
                          _participants.sort((a, b) {
                            return a.displayName
                                .toLowerCase()
                                .compareTo(b.displayName.toLowerCase());
                          });
                        }
                        return _buildListParticipants();
                      } else {
                        return Container();
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: SpeedDial(
        marginRight: 18,
        marginBottom: 20,
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: IconThemeData(size: 22.0),
        closeManually: false,
        curve: Curves.bounceIn,
        overlayColor: Colors.black,
        overlayOpacity: 0.1,
        onOpen: () => print('OPENING DIAL'),
        onClose: () => print('DIAL CLOSED'),
        tooltip: 'Speed Dial',
        heroTag: 'speed-dial-hero-tag',
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 8.0,
        shape: CircleBorder(),
        children: [
          SpeedDialChild(
              child: Icon(Icons.person),
              backgroundColor: Colors.green,
              label: 'Novo Participante',
              labelStyle: TextStyle(fontSize: 18.0),
              onTap: () {
                Navigator.push(
                  context,
                  FadeRoute(
                    page: CreateNewParticipant(

                    ),
                  ),
                );
              }),
          SpeedDialChild(
            child: Icon(Icons.event),
            backgroundColor: Colors.blue,
            label: 'Nova Ocorrência',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () {
              Navigator.push(
                context,
                FadeRoute(
                  page: CreateEventOccurrences(
                    event: widget.event,
                    currentUser: widget.currentUser,
                    onSignedOut: widget.onSignedOut,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  ///
  void changeDefaultLocale() async {
    await Jiffy.locale("pt");
  }

  ///
  Widget _buildAppBar() {
    return AppBar(
      title: Text(
        widget.event.title,
        style: TextStyle(color: ColorsPalette.textColorLight),
      ),
      iconTheme: IconThemeData(color: ColorsPalette.textColorLight),
      actions: <Widget>[
        PopupMenuButton<Action>(
          onSelected: (Action result) async {
            switch (result) {
              case Action.edit:
                _titleController.text = widget.event.title;
                _descController.text = widget.event.descripton;

                var retValue = await showDialog(
                    context: context,
                    builder: (_) {
                      return MyDialog(
                        event: widget.event,
                        titleController: _titleController,
                        descController: _descController,
                      );
                    });
                if (retValue != null) {
                  Map map = json.decode(retValue);
                  setState(() {
                    widget.event.title = map['title'];
                    widget.event.descripton = map['description'];
                  });
                }
                break;
              case Action.delete:
                String result = await FirebaseService.deleteEvent(widget.event);
                if (result == "success") {
                  Navigator.pop(context);

                  Navigator.push(
                    context,
                    FadeRoute(
                      page: HomeEventManagement(
                        onSignedOut: widget.onSignedOut,
                        currentUser: widget.currentUser,
                      ),
                    ),
                  );

                  Fluttertoast.showToast(
                      msg: "Evento excluído",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIos: 1,
                      fontSize: 16.0);
                } else {
                  print(result);
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Aviso'),
                          content: Text(result),
                          actions: <Widget>[
                            FlatButton(
                              child: Text('Ok',
                                  style: TextStyle(
                                      color: ColorsPalette.textColorDark,
                                      fontWeight: FontWeight.w700)),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            )
                          ],
                        );
                      });
                }
                break;
              default:
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<Action>>[
            const PopupMenuItem<Action>(
              value: Action.edit,
              child: Text('Editar'),
            ),
            PopupMenuDivider(
              height: 10,
            ),
            const PopupMenuItem<Action>(
              value: Action.delete,
              child: Text('Excluir'),
            ),
          ],
        ),
      ],
    );
  }

  ///
  Widget _buildListParticipants() {
    List<Occurrence> _tmpOccurrences = [];
    final String _emptyPhotoURL =
        "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png";
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: _participants == null ? 0 : _participants.length,
      itemBuilder: (context, index) {
        return Dismissible(
          key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
          direction: DismissDirection.endToStart,
          background: Container(
            color: Colors.red,
            alignment: Alignment(0.9, 0),
            child: Icon(
              Icons.delete_forever,
              color: ColorsPalette.background,
            ),
          ),
          onDismissed: (direction) async {
            _tempParticipant = _participants[index];
            _tempIndex = index;

            final _snack = SnackBar(
              content: Text('Participante removido com sucesso.'),
              duration: Duration(seconds: 3),
              action: SnackBarAction(
                label: 'Desfazer',
                onPressed: () async {
                  await FirebaseService.createEventParticipants(
                      widget.event, _tempParticipant);
                  await FirebaseService.createParticipantEvents(
                      _tempParticipant.id, widget.event);
                  for (var occurrence in _tmpOccurrences) {
                    await FirebaseService.createOccurrenceGroupByDate(
                        _tempParticipant.id, occurrence);
                  }
                  setState(() {
                    _participants.insert(_tempIndex, _tempParticipant);
                  });
                },
              ),
            );

            // Delete from List
            _participants.removeAt(index);

            await FirebaseService.deleteEventParticipants(
                widget.event, _tempParticipant.id);
            await FirebaseService.deleteParticipantEvents(
                _tempParticipant.id, widget.event.id);
            _tmpOccurrences = await FirebaseService.deleteOccurrenceGroupByDate(
                _tempParticipant.id, widget.event.id);

            print('DATA DELETED !');

            Scaffold.of(context).removeCurrentSnackBar();
            Scaffold.of(context).showSnackBar(_snack);
          },
          child: Padding(
            padding: index == 0
                ? const EdgeInsets.all(0)
                : const EdgeInsets.fromLTRB(0, 5.0, 0, 0),
            child: Column(
              children: <Widget>[
                _participants == null
                    ? Text('Nenhum participante encontrado.')
                    : Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 20),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: CircleAvatar(
                                radius: 25.0,
                                backgroundColor:
                                    ColorsPalette.backgroundColorLight,
                                backgroundImage: NetworkImage(
                                    _participants[index].photoUrl != null
                                        ? _participants[index].photoUrl
                                        : _emptyPhotoURL),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    _participants[index].displayName,
                                    style: TextStyle(
                                      inherit: true,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18,
                                    ),
                                  ),
                                  Text(
                                    _participants[index].identifier,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                Divider(
                  indent: 30,
                  endIndent: 30,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  ///
  Widget _buildList() {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      itemCount: _occurrences == null ? 0 : _occurrences.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: index == 0
              ? const EdgeInsets.all(0)
              : const EdgeInsets.fromLTRB(0, 5.0, 0, 0),
          child: ListTileItem(
            eventName: Jiffy(_occurrences[index].date).yMMMMd,
            eventTime: _occurrences[index].timeStart,
            location: _occurrences[index].local,
            colorHeader: ColorsPalette.primaryColorLight,
            colorEventName: ColorsPalette.backgroundColorLight,
            colorEventTime: ColorsPalette.backgroundColorLight,
            divider: false,
            showCount: false,
            onTap: () {
              Navigator.push(
                context,
                SlideLeftRoute(
                  page: DetailsOccurrence(
                      occurrence: _occurrences[index],
                      event: widget.event,
                      onSignedOut: widget.onSignedOut,
                      currentUser: widget.currentUser),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class MyDialog extends StatefulWidget {
  final Event event;
  final TextEditingController titleController;
  final TextEditingController descController;

  MyDialog({this.event, this.titleController, this.descController});

  @override
  _MyDialogState createState() => _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {
  @override
  Widget build(BuildContext context) {
    /// Name
    final _name = TextField(
      controller: widget.titleController,
      decoration: InputDecoration(
        labelText: 'Nome',
      ),
      onChanged: (text) {
        if (text.length == 0) {
          setState(() {});
        } else {
          setState(() {});
        }
      },
    );

    /// Description
    final _description = TextFormField(
        controller: widget.descController,
        decoration: InputDecoration(
          labelText: 'Descrição',
        ),
        onChanged: (text) {
          if (text.length == 0) {
            setState(() {});
          } else {
            setState(() {});
          }
        });

    final _btnCancel = FlatButton(
      child: new Text("Cancelar",
          style: TextStyle(color: ColorsPalette.textColorDark90)),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    final _btnEdit = FlatButton(
      child: new Text('Editar',
          style: TextStyle(
              color: ColorsPalette.textColorDark, fontWeight: FontWeight.w700)),
      onPressed: (widget.titleController.text.isEmpty ||
              widget.descController.text.isEmpty)
          ? null
          : () {
              widget.event.title = widget.titleController.text;
              widget.event.descripton = widget.descController.text;

              FirebaseService.updateEvent(widget.event);
              FirebaseService.updateOwnerEvent(widget.event);
              FirebaseService.updateParticipantEvents(widget.event);

              Map<String, dynamic> result = new Map();
              result['title'] = widget.titleController.text;
              result['description'] = widget.descController.text;

              Navigator.pop(context, json.encode(result));

              Fluttertoast.showToast(
                  msg: "Evento atualizado",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIos: 1,
                  fontSize: 16.0);
            },
    );

    return AlertDialog(
      title: Center(child: Text("Editar evento")),
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _name,
            _description,
          ],
        ),
      ),
      actions: <Widget>[_btnCancel, _btnEdit],
    );
  }
}
