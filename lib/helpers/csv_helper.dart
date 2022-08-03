import 'package:file_picker/file_picker.dart';
import 'package:csv/csv.dart' as csv;

import '../helpers/db_helper.dart';

class CsvHelper {
	static Future<bool> exportDbToCsv() async {
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
		
		String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

		if (selectedDirectory == null) {
			return false;
		}

		final dtNow = DateTime.now();

		final csvFileName = 'recipeTagindexer_DbSave_${(dtNow.millisecondsSinceEpoch / 1000).floor()}.csv';
		final csvSavePath = '$selectedDirectory/$csvFileName';

		return true;
	}
}