import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/models/task.dart';

class DBHelper {
  static Database? _db;

  static const int _version = 1;
  static const String _tableName = 'tasks';

  static Future<void> initialization() async {
    if (_db != null) {
      debugPrint('not null db');
      return;
    } else {
      try {
        String path = '${await getDatabasesPath()}task.db';
        debugPrint('in database path');
        _db = await openDatabase(
          path,
          version: _version,
          onCreate: (Database db, int version) async {
            debugPrint('creatinganew one');
            await db.execute(
              'CREATE TABLE $_tableName('
              'id INTEGER PRIMARY KEY AUTOINCREMENT, '
              'title STRING,note TEXT,date STRING, '
              'startTime STRING,endTime STRING, '
              'remind INTEGER,repeat STRING, '
              'color INTEGER, '
              'isCompleted INTEGER) ',
            );
          },
        );
      } catch (e) {
        print(e);
      }
    }
  }

  static Future<int> insert(Task? task) async {
    print('Insert');
    return await _db!.insert(_tableName, task!.toMap());
  }

  static Future<int> delete(Task task) async {
    print('Delete');
    return await _db!.delete(_tableName, where: 'id=?', whereArgs: [task.id]);
  }

  static Future<List<Map<String, dynamic?>>> query() async {
    print('Query');
    return await _db!.query(_tableName);
  }

  static Future<int> update(int id) async {
    print('Update');
    return await _db!.rawUpdate(
        'UPDATE $_tableName SET isCompleted = ?  WHERE id = ?', [1, id]);
  }
// Get a location using getDatabasesPath

// Delete the database
// await deleteDatabase(path);

// // open the database
// Database database = await openDatabase(path, version: 1,
//     onCreate: (Database db, int version) async {
//   // When creating the db, create the table
//   await db.execute(
//       'CREATE TABLE Test (id INTEGER PRIMARY KEY, name TEXT, value INTEGER, num REAL)');
// });

// // Insert some records in a transaction
// await database.transaction((txn) async {
//   int id1 = await txn.rawInsert(
//       'INSERT INTO Test(name, value, num) VALUES("some name", 1234, 456.789)');
//   print('inserted1: $id1');
//   int id2 = await txn.rawInsert(
//       'INSERT INTO Test(name, value, num) VALUES(?, ?, ?)',
//       ['another name', 12345678, 3.1416]);
//   print('inserted2: $id2');
// });

// // Update some record
// int count = await database.rawUpdate(
//     'UPDATE Test SET name = ?, value = ? WHERE name = ?',
//     ['updated name', '9876', 'some name']);
// print('updated: $count');

// // Get the records
// List<Map> list = await database.rawQuery('SELECT * FROM Test');
// List<Map> expectedList = [
//   {'name': 'updated name', 'id': 1, 'value': 9876, 'num': 456.789},
//   {'name': 'another name', 'id': 2, 'value': 12345678, 'num': 3.1416}
// ];
// print(list);
// print(expectedList);
// assert(const DeepCollectionEquality().equals(list, expectedList));

// // Count the records
// count = Sqflite
//     .firstIntValue(await database.rawQuery('SELECT COUNT(*) FROM Test'));
// assert(count == 2);

// // Delete a record
// count = await database
//     .rawDelete('DELETE FROM Test WHERE name = ?', ['another name']);
// assert(count == 1);

// // Close the database
// await database.close();
//   }

}
