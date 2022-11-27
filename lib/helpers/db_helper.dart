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
				await db.execute('CREATE TABLE recipes(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, displayId TEXT, name TEXT, complexity INTEGER, difficulty INTEGER, prepTime INTEGER, cookingTime INTEGER, servings TEXT)');
				await db.execute('CREATE TABLE images(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, listIndex INTEGER, imageType INTEGER, imageLocation TEXT, ownerId INTEGER NOT NULL)');
				await db.execute('CREATE TABLE tags(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, name TEXT)');
				await db.execute('CREATE TABLE mn_recipes_tags(recipeId INTEGER NOT NULL, tagId INTEGER NOT NULL)');
			},
			/*
			onConfigure: (db) async {
				await db.execute('PRAGMA foreign_keys = ON');
			},
			*/
			version: 1,
		);
	}

	static Future<bool> dbImportFullOverwrite (Map<String,List<Map<String,dynamic>>> dataToImport) async {
		final db = await DBHelper.database();
		final importOverwriteBatch = db.batch();

		final tablesToClear = ['mn_recipes_tags', 'recipes', 'images', 'tags'];

		// First, clear out all tables in the DB.
		for (final tableName in tablesToClear) {
			importOverwriteBatch.delete(tableName);
		}

		// Next, begin inserting the records into the tables, from the dataToImport.
		for (final tableName in dataToImport.keys) {
			for (final tableRecord in dataToImport[tableName]!) {
				importOverwriteBatch.insert(tableName, tableRecord);
			}
		}

		final batchResult = await importOverwriteBatch.commit();
		return true;
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

	static Future<void> mergeTwoTags(int tagIdAbsorber, int tagIdAbsorbed) async {
		final db = await DBHelper.database();
		final stmtBatch = db.batch();

		// Replace all instances of the 'absorbed' tag with the 'absorber' tag, in 'mn_recipes_tags' table
		stmtBatch.update('mn_recipes_tags', {
			'tagId': tagIdAbsorber,
		}, where: '"tagId" = ?', whereArgs: [tagIdAbsorbed]);

		// Delete the 'absorbed' tag from 'tags' table
		stmtBatch.delete('tags', where: '"id" = ?', whereArgs: [tagIdAbsorbed]);

		await stmtBatch.commit();
		return;
	}

	static Future<void> deleteRecipesById(Set<int> idSet) async {
		final db = await DBHelper.database();
		final stmtBatch = db.batch();

		final placeholderArrStr = List.filled(idSet.length, '?').join(',');
		final idList = idSet.toList();

		stmtBatch.delete('recipes', where: '"id" IN ($placeholderArrStr)', whereArgs: idList);
		stmtBatch.delete('images', where: '"ownerId" IN ($placeholderArrStr)', whereArgs: idList);
		stmtBatch.delete('mn_recipes_tags', where: '"recipeId" IN ($placeholderArrStr)', whereArgs: idList);

		await stmtBatch.commit();
		return;
	}

	static Future<void> deleteTagsById(Set<int> idSet) async {
		final db = await DBHelper.database();
		final stmtBatch = db.batch();

		final placeholderArrStr = List.filled(idSet.length, '?').join(',');

		stmtBatch.delete('tags', where: '"id" IN ($placeholderArrStr)', whereArgs: idSet.toList());
		stmtBatch.delete('mn_recipes_tags', where: '"tagId" IN ($placeholderArrStr)', whereArgs: idSet.toList());

		await stmtBatch.commit();
		return;
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

	static Future<bool> batchModifyMNRecipesTags(List<Map<String,int>> insertList, List<Map<String,int>> deleteList,) async {
		final db = await DBHelper.database();
		final stmtBatch = db.batch();

		for (final record in insertList) {
			stmtBatch.insert('mn_recipes_tags', record);
		}

		for (final record in deleteList) {
			stmtBatch.delete('mn_recipes_tags', where: '"recipeId" = ? AND "tagId" = ?', whereArgs: [record['recipeId'], record['tagId']]);
		}
		await stmtBatch.commit();
		return true;
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