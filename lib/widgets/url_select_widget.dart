import 'package:cogboardmobileapp/models/connection_model.dart';
import 'package:cogboardmobileapp/utils/shared_preferences_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class UrlSelect extends StatefulWidget {
  UrlSelect({Key key}) : super(key: key);

  @override
  _UrlSelectState createState() => _UrlSelectState();
}

class _UrlSelectState extends State<UrlSelect> {
  SharedPref sharedPref = SharedPref();
  List<Connection> _connections = List();
  Connection _connection = new Connection(url: "Dupa", lastVisited: false);
  String _value = 'Dupa';

  loadConnections() async {
    try {
      _connections.add(new Connection(url: "test.com", lastVisited: false));
      await sharedPref.save(
          "connections", Connection.encodeConnections(_connections));

      _connections =
          Connection.decodeConnections(await sharedPref.read("connections"));

      print("Connections: " + _connections.toString());
    } catch (Excepetion) {
      Scaffold.of(context).showSnackBar(SnackBar(
          content: new Text("Error!"),
          duration: const Duration(milliseconds: 500)));
    }
  }

  loadSharedPrefs() async {
    try {
      await sharedPref.save("Java", "To Gówno");
      print(await sharedPref.read("Java"));
    } catch (Excepetion) {
      Scaffold.of(context).showSnackBar(SnackBar(
          content: new Text("Error!"),
          duration: const Duration(milliseconds: 500)));
    }
  }

  @override
  Widget build(BuildContext context) {
    _connections.add(new Connection(url: "Dupa", lastVisited: false));
    loadSharedPrefs();
    loadConnections();

    return Container(
      child: new DropdownButton<Connection>(
        value: _connection,
        items: _connections.map((Connection c) {
          return new DropdownMenuItem(
            child: new Text(c.url),
            value: c,
          );
        }).toList(),
        onChanged: (c) => setState(() => _connection = c),
      ),
    );
  }
}
