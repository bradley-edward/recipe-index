import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';

class DBHelper {
	static Future<Database> database() async {
		final dbPath = await sql.getDatabasesPath();
		return sql.openDatabase(
			path.join(dbPath, 'collection_indexer.db'),
			onCreate: (db, version) async {
				await db.execute('CREATE TABLE recipes(id TEXT PRIMARY KEY, entryId TEXT, name TEXT, complexity INTEGER, difficulty INTEGER)');
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
		final insertBatch = db.batch();
		for (var datum in data) {
			insertBatch.insert(table, datum, conflictAlgorithm: sql.ConflictAlgorithm.replace);
		}
		await insertBatch.commit();
	}

	static Future<void> update(String table, Map<String, Object> data) async {
		final db = await DBHelper.database();
		await db.update(table, data, where: '"id" = ?', whereArgs: [data['id'],]);
	}

	static Future<void> deleteById(String table, String id) async {
		final db = await DBHelper.database();
		int deletedCount = await db.delete(table, where: '"id" = ?', whereArgs: [id]);
	}

	static Future<void> deleteWhere(String table, String whereStr, List<Object?>? whereArr) async {
		final db = await DBHelper.database();
		int deletedCount = await db.delete(table, where: whereStr, whereArgs: whereArr);
	}

	static Future<void> batchStmts(String table, List<Map<String,dynamic>> insertList, List<Map<String,dynamic>> updateList, Set<String> deleteIdSet) async {
		final db = await DBHelper.database();
		final stmtBatch = db.batch();
		for (var insertItem in insertList) {
			stmtBatch.insert(table, insertItem, conflictAlgorithm: sql.ConflictAlgorithm.replace);
		}
		for (var updateItem in updateList) {
			stmtBatch.update(table, updateItem, where: '"id" = ?', whereArgs: [updateItem['id']]);
		}
		for (var deleteId in deleteIdSet) {
			stmtBatch.delete(table, where: '"id" = ?', whereArgs: [deleteId]);
		}
		await stmtBatch.commit();
	}

	static Future<List<Map<String, dynamic>>> getData(String table) async {
		final db = await DBHelper.database();
		return db.query(table);
	}
}