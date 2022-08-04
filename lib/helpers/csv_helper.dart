import 'dart:io';

import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:csv/csv.dart' as csv;

import '../helpers/db_helper.dart';

class CsvHelper {
	static Future<bool> exportDbToCsv() async {
		final secondsSinceEpoch = (DateTime.now().millisecondsSinceEpoch / 1000).floor();

		final db = await DBHelper.database();
		// Need to convert our data into lists-of-lists. One per table.
		final tables = ['recipes', 'tags', 'mn_recipes_tags'];
		final csvLoL = <List<dynamic>>[];
		for (final tableName in tables) {
			final listMap = await db.query(tableName);
			final columnNames = listMap[0].keys.toList();
			
			csvLoL.add(['tableName', tableName]);
			csvLoL.add(columnNames);
			for (final record in listMap) {
				csvLoL.add(columnNames.map((col) => record[col]).toList());
			}
		}

		final csvString = const csv.ListToCsvConverter().convert(csvLoL);

		final csvFileName = 'recipeTagindexer_DbSave_$secondsSinceEpoch.csv';

		try {
			final appDir = await syspaths.getApplicationDocumentsDirectory();
			File file = File('${appDir.path}/$csvFileName');
			await file.writeAsString(csvString);
		} catch (error) {
			return false;
		}

		return true;
	}
}