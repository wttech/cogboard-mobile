import 'package:cogboardmobileapp/models/connection_model.dart';
import 'package:cogboardmobileapp/providers/settings_provider.dart';
import 'package:cogboardmobileapp/utils/shared_preferences_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class UrlSelect extends StatefulWidget {
  UrlSelect({Key key}) : super(key: key);

  @override
  _UrlSelectState createState() => _UrlSelectState();
}

class _UrlSelectState extends State<UrlSelect> {
  SharedPref sharedPref = SharedPref();
  int _connection;
  List<Connection> _connections = List();

  int getLastVisitedConnection(List<Connection> connections) {
    if (connections == null) {
      return null;
    }
    for (Connection c in connections) {
      if (c.lastVisited) {
        // TODO return lastVisited
        return 0;
      }
    }
    return 0;
  }

  @override
  void initState() {
    super.initState();
    loadConnections();
  }

  Future<void> loadConnections() async {
    try {
      final settingsProvider =
          Provider.of<SettingsProvider>(context, listen: false);
      await settingsProvider.fetchConnections();
      int c = getLastVisitedConnection(settingsProvider.connections);

      setState(() {
        _connections = settingsProvider.connections;
        _connection = c;
      });
    } catch (Exception) {
      print("No connections fetched");
    }
  }

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);

    if (_connections != null && _connections.length > 0) {
      return Container(
        width: 150,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          // borderRadius: BorderRadius.circular(10),
        ),
        child: new Theme(
          data: Theme.of(context).copyWith(
            canvasColor: Colors.white,
          ),
          child: new DropdownButton<int>(
            value: _connection,
            underline: Container(),
            isExpanded: true,
            items: _connections.map((Connection c) {
              return new DropdownMenuItem(
                child: new Text(c.url),
                value: _connections.indexOf(c),
              );
            }).toList(),
            onChanged: (c) => setState(() {
              _connection = c;
              settingsProvider.setCurrentConnection(_connections[c]);
            }),
          ),
        ),
      );
    } else {
      return Container(
        child: Text(
          "There are no Connections saved.",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      );
    }
  }
}
