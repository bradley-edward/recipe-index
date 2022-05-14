import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';
import 'dart:convert' as convert;
import 'package:encrypt/encrypt.dart' as encrypt;

class DBHelper {
	static const _backupKey = 'fyUNIYWM()*(*(KIOHRWOP)WR))BN%)R';

	static Future<Database> database() async {
		final dbPath = await sql.getDatabasesPath();
		return sql.openDatabase(
			path.join(dbPath, 'collection_indexer.db'),
			onCreate: (db, version) async {
				await db.execute('CREATE TABLE recipes(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, name TEXT, complexity INTEGER, difficulty INTEGER, prepTime INTEGER, cookingTime INTEGER, servings INTEGER)');
				await db.execute('CREATE TABLE images(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, listIndex INTEGER, imageType INTEGER, imageLocation TEXT, ownerId INTEGER NOT NULL, FOREIGN KEY(ownerId) REFERENCES recipes(id))');
			},
			version: 1,
		);
	}

	static Future<int> insert(String table, Map<String, Object> data) async {
		final db = await DBHelper.database();
		final insertedRecordId = await db.insert(table, data, conflictAlgorithm: sql.ConflictAlgorithm.replace);
		return insertedRecordId;
	}

	static Future<List<Object?>> insertMany(String table, List<Map<String, Object>> data) async {
		final db = await DBHelper.database();
		final insertBatch = db.batch();
		for (var datum in data) {
			insertBatch.insert(table, datum, conflictAlgorithm: sql.ConflictAlgorithm.replace);
		}
		final insertResults = await insertBatch.commit();	// Contains a list of IDs of the newly inserted records.
		return insertResults;
	}

	static Future<void> update(String table, Map<String, Object> data) async {
		final db = await DBHelper.database();
		await db.update(table, data, where: '"id" = ?', whereArgs: [data['id'],]);
	}

	static Future<void> deleteById(String table, int id) async {
		final db = await DBHelper.database();
		int deletedCount = await db.delete(table, where: '"id" = ?', whereArgs: [id]);
	}

	static Future<void> deleteWhere(String table, String whereStr, List<Object?>? whereArr) async {
		final db = await DBHelper.database();
		int deletedCount = await db.delete(table, where: whereStr, whereArgs: whereArr);
	}

	static Future<Map<String,List<Object?>>> batchStmts(String table, List<Map<String,Object>> insertList, List<Map<String,dynamic>> updateList, Set<int> deleteIdSet) async {
		final db = await DBHelper.database();
		final stmtBatch = db.batch();

		final Map<String,List<Object?>> returnPayload = {
			'insertResults': [],
		};

		if (insertList.isNotEmpty) {
			final insertResults = await insertMany(table, insertList);
			returnPayload['insertResults'] = insertResults;
		}

		for (var updateItem in updateList) {
			stmtBatch.update(table, updateItem, where: '"id" = ?', whereArgs: [updateItem['id']]);
		}
		for (var deleteId in deleteIdSet) {
			stmtBatch.delete(table, where: '"id" = ?', whereArgs: [deleteId]);
		}
		await stmtBatch.commit();
		return returnPayload;
	}

	static Future<List<Map<String, dynamic>>> getData(String table) async {
		final db = await DBHelper.database();
		return db.query(table);
	}

	Future clearAllTables() async {
		try {
			final db = await DBHelper.database();
			for (String table in ['recipes']) {
				await db.delete(table);
				await db.rawQuery("DELETE FROM sqlite_sequence where name='$table'");
			}
		} catch(e) {
			print('Something went wrong with clearing all tables!');
			print(e.toString());
		}
	}

	static Future<String> generateBackup({bool isEncrypted = true}) async {
		final db = await DBHelper.database();
		final List<List<Map<String, Object?>>> data = [];
		final List tables = ['recipes'];

		for (final tableName in tables) {
			final listMap = await db.query(tableName);
			data.add(listMap);
		}
		final List backups = [tables, data];

		String json = convert.jsonEncode(backups);

		if (!isEncrypted) return json;

		final key = encrypt.Key.fromUtf8(_backupKey);
		final iv = encrypt.IV.fromLength(16);
		final encrypter = encrypt.Encrypter(encrypt.AES(key));
		final encrypted = encrypter.encrypt(json, iv: iv);

		return encrypted.base64;
	}

	static Future<void> restoreBackup(String backup, { bool isEncrypted = true }) async {
		final db = await DBHelper.database();

		final Batch batch = db.batch();

		final key = encrypt.Key.fromUtf8(_backupKey);
		final iv = encrypt.IV.fromLength(16);
		final encrypter = encrypt.Encrypter(encrypt.AES(key));

		List json = convert.jsonDecode(isEncrypted ? encrypter.decrypt64(backup, iv: iv) : backup);

		for (var i = 0, ilen = json[0].length; i < ilen; i++) {
			for (var j = 0, jlen = json[1].length; j < jlen; j++) {
				batch.insert(json[0][i],json[1][i][j]);
			}
		}

		await batch.commit(continueOnError: false, noResult: true);
	}
}