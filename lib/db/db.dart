import 'dart:async';

import 'package:cogboardmobileapp/models/connection.model.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ApplicationDatabase {
  static Database _db;
  static int get _version => 1;

  static Future<void> init() async {
    if (_db != null) {
      return;
    }

    try {
      _db = await openDatabase(
        join(await getDatabasesPath(), 'db.sqlite'),
        onCreate: (db, version) {
          return db.execute(
            'CREATE TABLE connections(id INTEGER PRIMARY KEY, url STRING, lastVisited BOOLEAN)',
          );
        },
        version: _version,
      );
    } catch (e) {
      print(e);
    }
  }

  static Future<void> insertConnection(Connection c) async {
    if (_db == null) {
      return;
    }

    await _db.insert('connections', c.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    debugPrint('[DB] Inserted new connection to DB');
  }

  static Future<List<Connection>> fetchConnections() async {
    if (_db == null) {
      return [];
    }

    final List<Map<String, dynamic>> connections =
        await _db.query('connections');

    debugPrint('[DB] Fetched connections');

    return List.generate(
        connections.length,
        (i) => Connection(
              id: connections[i]['id'],
              url: connections[i]['url'],
              lastVisited: connections[i]['lastVisited'],
            ));
  }
}
