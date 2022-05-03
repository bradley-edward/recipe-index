import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';

class DBHelper {
	static Future<Database> database() async {
		final dbPath = await sql.getDatabasesPath();
		return sql.openDatabase(
			path.join(dbPath, 'collection_indexer.db'),
			onCreate: (db, version) async {
				await db.execute('CREATE TABLE recipes(id TEXT PRIMARY KEY, entryId TEXT, name TEXT)');
				await db.execute('CREATE TABLE images(id TEXT PRIMARY KEY, listIndex INTEGER, imageType INTEGER, imageLocation TEXT, ownerId TEXT, FOREIGN KEY(ownerId) REFERENCES recipes(id))');
			},
			version: 1,
		);
	}

	static Future<void> insert(String table, Map<String, Object> data) async {
		final db = await DBHelper.database();
		await db.insert(table, data, conflictAlgorithm: sql.ConflictAlgorithm.replace);
	}

	static Future<void> insertMany(String table, List<Map<String, Object>> data) async {
		final db = await DBHelper.database();
		var insertBatch = db.batch();
		for (var datum in data) {
			insertBatch.insert(table, datum, conflictAlgorithm: sql.ConflictAlgorithm.replace);
		}
		await insertBatch.commit();
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