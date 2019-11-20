import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mypresence/ui/activities/sign_in.dart';
import 'package:mypresence/utils/colors_palette.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: ColorsPalette.primaryColorDark, // status bar color
  ));
  runApp(
    MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primaryColor: ColorsPalette.primaryColor,
            cursorColor: ColorsPalette.primaryColor),
        home: SignIn()),
  );
}
