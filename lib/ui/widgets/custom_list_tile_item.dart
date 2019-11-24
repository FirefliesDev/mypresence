import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:mypresence/utils/colors_palette.dart';

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

  /// The participants count
  final int count;

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
      this.count,
      this.divider = true,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Card(
        elevation: 5,
        color: colorHeader,
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      eventName,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: colorEventName,
                      ),
                    ),
                    Stack(
                      alignment: AlignmentDirectional.center,
                      children: <Widget>[
                        Container(
                          width: 24,
                          height: 24,
                          decoration: new BoxDecoration(
                            color: ColorsPalette.accentColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        Text(
                          count.toString() == 'null' ? '0' : count.toString(),
                          style: TextStyle(
                              fontSize: 12,
                              color: ColorsPalette.textColorLight),
                        )
                      ],
                    )
                  ],
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Location',
                        style: TextStyle(
                          color: colorEventName,
                        ),
                      ),
                      Text(
                        eventTime,
                        style: TextStyle(
                          color: colorEventTime,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
