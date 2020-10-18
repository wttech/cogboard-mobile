import 'dart:convert';

class Connection {
  final String url;
  final bool lastVisited;
  final String name;

  Connection({this.url, this.lastVisited, this.name});

  Map<String, dynamic> toJson() => {
        'url': url,
        'lastVisited': lastVisited,
        'name': name,
      };

  factory Connection.fromJson(Map<String, dynamic> json) {
    return Connection(
      url: json['url'],
      lastVisited: json['lastVisited'],
      name: json['name'],
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
