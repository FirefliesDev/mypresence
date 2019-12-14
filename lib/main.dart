import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mypresence/authentication/authentication.dart';
import 'package:mypresence/utils/colors_palette.dart';
import 'package:mypresence/utils/root_activities.dart';

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
      home: RootActivities(Authentication()),
    ),
  );
}
