import 'package:flutter/material.dart';
import 'package:mypresence/ui/widgets/google_button.dart';
import 'package:mypresence/utils/colors_palette.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String emailValue, passwordValue;
  bool isObscureText = true;

  @override
  Widget build(BuildContext context) {
    return _buildScaffold();
  }

  /// Creates a Scaffold
  Widget _buildScaffold() {
    final _title = Text(
      'MyPRESENCE',
      style: TextStyle(
          color: ColorsPalette.primaryColor,
          fontWeight: FontWeight.w700,
          fontSize: 24),
    );

    final _email = TextFormField(
      validator: (input) => input.isEmpty ? 'Digite um e-mail' : null,
      onSaved: (input) => emailValue = input,
      decoration: InputDecoration(
        labelText: 'E-mail',
        prefixIcon: Icon(
          Icons.mail_outline,
          color: ColorsPalette.primaryColor,
        ),
      ),
    );

    final _password = TextFormField(
      validator: (input) => input.isEmpty ? 'Digite uma senha' : null,
      onSaved: (input) => passwordValue = input,
      obscureText: isObscureText,
      decoration: InputDecoration(
          labelText: 'Senha',
          prefixIcon: Icon(
            Icons.lock_outline,
            color: ColorsPalette.primaryColor,
          ),
          suffixIcon: isObscureText
              ? IconButton(
                  onPressed: _toggleIcon,
                  icon: Icon(Icons.visibility_off),
                  color: ColorsPalette.primaryColor,
                )
              : IconButton(
                  onPressed: _toggleIcon,
                  icon: Icon(Icons.visibility),
                  color: ColorsPalette.primaryColor,
                )),
    );

    final _labelDontHaveAccount = Text(
      "Não tem conta?",
      style: TextStyle(color: ColorsPalette.textColorDark, fontSize: 14),
    );

    final _buttonSignUp = FlatButton(
      onPressed: () {},
      child: Text(
        'CADASTRE-SE',
        style: TextStyle(
            fontWeight: FontWeight.w700,
            color: ColorsPalette.primaryColor,
            fontSize: 14),
      ),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );

    final _label = Text(
      'ou',
      style: TextStyle(color: ColorsPalette.textColorDark, fontSize: 14),
    );

    final _body = Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 30.0, bottom: 15.0),
          child: _title,
        ),
        _email,
        _password,
        Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: _buildFlatButton(
              color: ColorsPalette.primaryColor,
              name: 'Entrar',
              onTap: signIn),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[_labelDontHaveAccount, _buttonSignUp],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Row(
            children: <Widget>[
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Divider(
                  color: ColorsPalette.textColorDark50,
                ),
              )),
              _label,
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Divider(
                    color: ColorsPalette.textColorDark50,
                  ),
                ),
              ),
            ],
          ),
        ),
        GoogleButton(
          name: 'Entrar com o Google',
          onTap: () {},
        ),
      ],
    );

    return Scaffold(
      backgroundColor: ColorsPalette.backgroundColorLight,
      body: SafeArea(
        child: SingleChildScrollView(
            child: Column(
          children: <Widget>[
            Container(
              height: 30,
              color: ColorsPalette.primaryColor,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0),
              child: Form(key: _formKey, child: _body),
            )
          ],
        )),
      ),
    );
  }

  /// Creates a flat button
  Widget _buildFlatButton(
      {String name, Color color, Color textColor, VoidCallback onTap}) {
    return SizedBox(
      width: double.infinity,
      child: RaisedButton(
          onPressed: onTap == null ? () {} : onTap,
          child: Text(
            name,
            style: TextStyle(color: textColor, fontSize: 16),
          ),
          textColor: ColorsPalette.textColorLight,
          color: color),
    );
  }

  ///
  Future<void> signIn() async {
    if (isValidForm()) {
      print('Valid form.');
    }
  }

  ///
  bool isValidForm() {
    return _formKey.currentState.validate();
  }

  ///
  void saveDataForm() {
    _formKey.currentState.save();
  }

  /// Called when the user press the icon eye
  void _toggleIcon() {
    setState(() {
      isObscureText = !isObscureText;
    });
  }
}
