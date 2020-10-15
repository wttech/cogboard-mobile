import 'dart:convert';

import 'package:flutter/rendering.dart';

class Connection {
  final String url;
  final bool lastVisited;

  Connection({this.url, this.lastVisited});

  Map<String, dynamic> toJson() => {
        'url': url,
        'lastVisited': lastVisited,
      };

  factory Connection.fromJson(Map<String, dynamic> json) {
    return Connection(
      url: json['url'],
      lastVisited: json['lastVisited'],
    );
  }

  static String encodeConnections(List<Connection> connections) =>
      json.encode(connections
          .map<Map<String, dynamic>>((connection) => connection.toJson())
          .toList());

  static List<Connection> decodeConnections(String connections) =>
      (json.decode(connections) as List<dynamic>)
          .map<Connection>((connection) => Connection.fromJson(connection))
          .toList();
}
