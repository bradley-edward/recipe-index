import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';

class DBHelper {
	static Future<Database> database() async {
		final dbPath = await sql.getDatabasesPath();
		return sql.openDatabase(
			path.join(dbPath, 'collection_indexer.db'),
			onCreate: (db, version) {
				return db.execute('CREATE TABLE recipes(id TEXT PRIMARY KEY, entryId TEXT, name TEXT)');
			},
			version: 1,
		);
	}

	static Future<void> insert(String table, Map<String, Object> data) async {
		final db = await DBHelper.database();
		await db.insert(table, data, conflictAlgorithm: sql.ConflictAlgorithm.replace);
	}

	static Future<void> update(String table, Map<String, Object> data) async {
		final db = await DBHelper.database();
		await db.update(table, data, where: '"id" = ?', whereArgs: [data['id'],]);
	}

	static Future<List<Map<String, dynamic>>> getData(String table) async {
		final db = await DBHelper.database();
		return db.query(table);
	}
}