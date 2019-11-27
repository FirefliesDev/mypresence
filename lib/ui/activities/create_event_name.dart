import 'package:flutter/material.dart';
import 'package:mypresence/ui/activities/create_event_occurrences.dart';
import 'package:mypresence/utils/colors_palette.dart';
import 'package:mypresence/utils/transitions/fade_route.dart';

class CreateEventName extends StatefulWidget {
  @override
  _CreateEventNameState createState() => _CreateEventNameState();
}

class _CreateEventNameState extends State<CreateEventName> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _eventNameValue;

  @override
  Widget build(BuildContext context) {
    return _buildScaffold(context);
  }

  /// Creates a Scaffold
  Widget _buildScaffold(context) {
    final _name = TextFormField(
      validator: (input) =>
          input.isEmpty ? 'Digite um nome para o seu evento' : null,
      onSaved: (input) => _eventNameValue = input,
      decoration: InputDecoration(
        labelText: 'Escolha um nome',
        prefixIcon: Icon(
          Icons.bookmark_border,
          color: ColorsPalette.primaryColor,
        ),
      ),
    );

    return Scaffold(
      appBar: _buildAppBar(context),
      backgroundColor: ColorsPalette.backgroundColorSnow,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: <Widget>[
                    Text(
                      "Nomeie o seu evento",
                      style: TextStyle(
                          color: ColorsPalette.textColorDark,
                          fontSize: 24,
                          fontWeight: FontWeight.w700),
                      textAlign: TextAlign.center,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Text(
                        "Dê um nome ao seu evento para que ele seja encontrado facilmente.",
                        style: TextStyle(
                            color: ColorsPalette.textColorDark90,
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: _name,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      bottomSheet: Container(
        width: double.infinity,
        color: ColorsPalette.accentColor,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: GestureDetector(
            onTap: () {
              if (isValidForm()) {
                saveDataForm();
                Navigator.push(
                  context,
                  FadeRoute(
                    page: CreateEventOccurrences(
                      eventName: _eventNameValue,
                    ),
                  ),
                );
              }
            },
            child: Text(
              "PRÓXIMO",
              style: TextStyle(
                  color: ColorsPalette.textColorLight,
                  fontWeight: FontWeight.w700,
                  fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  ///
  Widget _buildAppBar(context) {
    return AppBar(
      title: Text(
        '',
        style: TextStyle(color: ColorsPalette.textColorLight),
      ),
      elevation: 0.0,
      backgroundColor: ColorsPalette.backgroundColorLight,
      leading: IconButton(
        icon: Icon(
          Icons.close,
          color: ColorsPalette.textColorDark,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      iconTheme: IconThemeData(color: ColorsPalette.textColorLight),
    );
  }

  ///
  bool isValidForm() {
    return _formKey.currentState.validate();
  }

  ///
  void saveDataForm() {
    _formKey.currentState.save();
  }
}
