import 'package:cogboardmobileapp/providers/settings_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cogboardmobileapp/models/settings_tab.dart';

class SettingsHints extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 32),
      margin: EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(vertical: 12),
            child: Text(
              "Hints",
              style: TextStyle(
                color: Colors.white,
                fontSize: 19,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 12),
            child: Text(
              "Show hints",
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
                  child: Text("On"),
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
                  child: Text("Off"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
