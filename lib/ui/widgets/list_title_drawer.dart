import 'package:flutter/material.dart';
import 'package:mypresence/utils/colors_palette.dart';

class ListTitleDrawer extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  ListTitleDrawer({@required this.text, this.icon, this.color, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: icon != null
          ? Text(
              text,
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
            )
          : Text(
              text,
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
            ),
      leading: icon != null
          ? Icon(
              icon,
              color: ColorsPalette.textColorDark,
            )
          : null,
      onTap: onTap ?? () {},
    );
  }
}
