import 'package:flutter/material.dart';
import 'package:mypresence/utils/colors_palette.dart';

class GoogleButton extends StatelessWidget {
  final String name;
  final double width;
  final VoidCallback onTap;

  GoogleButton({this.name, this.width, @required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width ?? double.infinity,
        decoration: BoxDecoration(
            border: Border.all(color: ColorsPalette.textColorDark50)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/images/google.png',
                height: 20.0,
              ),
              SizedBox(
                width: 8,
              ),
              Text(
                name ?? "Sign in with Google",
                style: TextStyle(
                    color: ColorsPalette.textColorDark,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              )
            ],
          ),
        ),
      ),
    );
  }
}
