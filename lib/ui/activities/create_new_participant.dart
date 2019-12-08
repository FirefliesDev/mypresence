import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mypresence/database/firebase_service.dart';
import 'package:mypresence/utils/colors_palette.dart';
import 'package:mypresence/model/user.dart';
import 'package:mypresence/ui/widgets/custom_expansion_tile.dart' as cet;

class CreateNewParticipant extends StatefulWidget {
  final String eventName;
  final String eventDescription;
  final VoidCallback onSignedOut;
  final FirebaseUser currentUser;

  CreateNewParticipant({
    this.eventName,
    this.eventDescription,
    this.currentUser,
    this.onSignedOut,
  });

  @override
  _CreateNewParticipantState createState() => _CreateNewParticipantState();
}

class _CreateNewParticipantState extends State<CreateNewParticipant> {
  List<User> _participants = new List();
  var _futureParticipants;

  //LÓGICA LISTA
  TextEditingController editingController = TextEditingController();
  final duplicateItems = List<String>.generate(1, (i) => "Item $i");
  var items = List<String>();

  @override
  void initState() {
    items.addAll(duplicateItems);
    super.initState();
    _futureParticipants = FirebaseService.getUsers();
  }

  void filterSearchResults(String query) {
    List<String> dummySearchList = List<String>();
    dummySearchList.addAll(duplicateItems);
    if (query.isNotEmpty) {
      List<String> dummyListData = List<String>();
      dummySearchList.forEach((item) {
        if (item.contains(query)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        items.clear();
        items.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        items.clear();
        items.addAll(duplicateItems);
      });
    }
  }

  void filterSearchResultsParticipants(String query) {
    List<String> participantsSearchList = List<String>();
    _participants.contains(query);
    for(var participant in _participants){
      participantsSearchList.add(participant.identifier);
      print(participant.identifier);

    }
    if(participantsSearchList.contains(query)){
      print("ACHEI");
    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Container(
        child: SafeArea(
          child: Column(
            children: <Widget>[
              TextField(
                onChanged: (value) {
                  filterSearchResultsParticipants(value);
                },
                controller: editingController,
                decoration: InputDecoration(
                  labelText: "Search",
                  hintText: "Search",
                  prefixIcon: Icon(Icons.search),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return new FutureBuilder(
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
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListParticipants() {
    final String _emptyPhotoURL =
        "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png";
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: _participants == null ? 0 : _participants.length,
      itemBuilder: (context, index) {
        return Padding(
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
        );
      },
    );
  }
}

Widget _buildAppBar() {
  return AppBar(
    title: Text(
      'Adicionar Novo Participante',
      style: TextStyle(color: ColorsPalette.textColorLight),
    ),
    iconTheme: IconThemeData(color: ColorsPalette.textColorLight),
  );
}
