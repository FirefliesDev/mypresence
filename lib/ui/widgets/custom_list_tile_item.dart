import 'package:flutter/material.dart';

/// Creates a custom list item to be used in the expansion tile (children)
class ListTileItem extends StatelessWidget {
  /// The color to display the item header
  final Color colorHeader;

  /// A text to represent the event name
  final String eventName;

  ///The color to display the event name
  final Color colorEventName;

  /// A text to represent the event time
  final String eventTime;

  /// The color to display the event time
  final Color colorEventTime;

  /// A divider to be added bellow the item
  final bool divider;

  /// Callback funcion to handle click actions
  final VoidCallback onTap;

  ListTileItem(
      {this.colorHeader,
      this.eventName,
      this.colorEventName,
      this.colorEventTime,
      this.eventTime,
      this.divider = true,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: colorHeader,
        child: Column(
          children: <Widget>[
            ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    eventName,
                    style: TextStyle(
                      color: colorEventName,
                    ),
                  ),
                  Text(
                    eventTime,
                    style: TextStyle(
                      color: colorEventTime,
                    ),
                  ),
                ],
              ),
              // trailing: Icon(Icons.delete),
              onTap: onTap,
            ),
            divider ? Divider(color: Colors.black, height: 0,) : SizedBox(height: 0,)
          ],
        ));
  }
}