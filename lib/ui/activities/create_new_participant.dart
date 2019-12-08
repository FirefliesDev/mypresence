import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mypresence/utils/colors_palette.dart';
import 'package:mypresence/utils/transitions/fade_route.dart';

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
  //LÓGICA LISTA
  TextEditingController editingController = TextEditingController();
  final duplicateItems = List<String>.generate(11, (i) => "Item $i");
  var items = List<String>();

  @override
  void initState() {
    items.addAll(duplicateItems);
    super.initState();
  }

  void filterSearchResults(String query) {
    List<String> dummySearchList = List<String>();
    dummySearchList.addAll(duplicateItems);
    if(query.isNotEmpty) {
      List<String> dummyListData = List<String>();
      dummySearchList.forEach((item) {
        if(item.contains(query)) {
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
                  filterSearchResults(value);
                },
                controller: editingController,
                decoration: InputDecoration(
                  labelText: "Search",
                  hintText: "Search",
                  prefixIcon: Icon(Icons.search),
                ),
              ),
              Expanded(
                child:
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text('${items[index]}'),
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
