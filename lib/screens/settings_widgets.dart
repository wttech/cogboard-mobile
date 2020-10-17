import 'package:cogboardmobileapp/models/widget_model.dart';
import 'package:cogboardmobileapp/providers/settings_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cogboardmobileapp/models/settings_tab.dart';

class SettingsWidgets extends StatefulWidget {
  final List<WidgetType> widgets;

  SettingsWidgets(this.widgets);

  @override
  _SettingsWidgetsState createState() => _SettingsWidgetsState();
}

class _SettingsWidgetsState extends State<SettingsWidgets> {
  bool checkboxValue = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(vertical: 12),
          child: Text(
            "Widgets",
            style: TextStyle(
              color: Colors.white,
              fontSize: 19,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 12),
          child: Text(
            "Sort by",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 15,
            ),
          ),
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: OutlineButton(
                borderSide: BorderSide(
                  color: Colors.grey, //Color of the border
                  style: BorderStyle.solid, //Style of the border
                  width: 0.8, //width of the border
                ),
                textColor: Colors.white,
                splashColor: Colors.blue,
                onPressed: () {},
                child: Text("None"),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
            ),
            Expanded(
              child: OutlineButton(
                borderSide: BorderSide(
                  color: Colors.grey, //Color of the border
                  style: BorderStyle.solid, //Style of the border
                  width: 0.8, //width of the border
                ),
                textColor: Colors.white,
                splashColor: Colors.blue,
                onPressed: () {},
                child: Text("Name"),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
            ),
            Expanded(
              child: OutlineButton(
                borderSide: BorderSide(
                  color: Colors.grey, //Color of the border
                  style: BorderStyle.solid, //Style of the border
                  width: 0.8, //width of the border
                ),
                textColor: Colors.white,
                splashColor: Colors.blue,
                onPressed: () {},
                child: Text("Status"),
              ),
            ),
          ],
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 12),
          child: Text(
            "Visible widgets types",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 15,
            ),
          ),
        ),
        Column(
          children: widget.widgets.map((widget) {
            return Row(
              children: <Widget>[
                Expanded(
                  child: SwitchListTile(
                    title: Text(
                      widget.name,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    value: true,
                    onChanged: (bool value) {
                      setState(() {
                        value = true;
                      });
                    },
                    activeColor: Colors.blue,
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}
