import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:csv/csv.dart' as csv;

import '../helpers/db_helper.dart';

class CsvHelper {
	static const _keyTableName = 'TABLE_NAME';
	static const _keyTableColumns = 'TABLE_COLUMNS';

	static Future<bool> exportDbToCsv() async {
		final secondsSinceEpoch = (DateTime.now().millisecondsSinceEpoch / 1000).floor();

		final db = await DBHelper.database();
		// Need to convert our data into lists-of-lists. One per table.
		final tables = ['recipes', 'tags', 'mn_recipes_tags'];
		final csvLoL = <List<dynamic>>[];
		for (final tableName in tables) {
			final listMap = await db.query(tableName);
			final columnNames = listMap[0].keys.toList();
			
			csvLoL.add([_keyTableName, tableName]);
			csvLoL.add([_keyTableColumns, ...columnNames]);
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

	static Future<List<String>> getImportCsvList() async {
		final appDir = await syspaths.getApplicationDocumentsDirectory();

		final listToReturn = <String>[];

		final regExp = RegExp(r'.*\.csv');

		await for (final entity in appDir.list()) {
			final currPath = entity.path;
			if (regExp.matchAsPrefix(currPath) == null) {
				continue;
			}

			listToReturn.add(entity.path);
		}

		return listToReturn;
	}

	static Future<bool> importFromCsvFile(String csvAbsPath) async {
		File csvFile = File(csvAbsPath);

		const csvConvertor = csv.CsvToListConverter();

		String currentTable = '';
		final tableColumnNames = <String>[];
		int tableRecordLength = -1;

		final dataToImport = <String,List<Map<String,dynamic>>>{};

		csvFile.openRead().transform(utf8.decoder).transform(csvConvertor).listen((csvRow) {
			if (csvRow[0] == _keyTableName) {
				currentTable = csvRow[1] as String;
				dataToImport[currentTable] = <Map<String,dynamic>>[];
				tableColumnNames.clear();
				tableRecordLength = -1;
				return;
			}

			if (csvRow[0] == _keyTableColumns) {
				tableColumnNames.addAll(csvRow.sublist(1).map((e) => e.toString()));
				tableRecordLength = csvRow.length;
				return;
			}

			final dataRecord = <String,dynamic>{};
			for (var i = 0; i < tableRecordLength; i++ ) {
				dataRecord[tableColumnNames[i]] = csvRow[i];
			}

			dataToImport[currentTable]!.add(dataRecord);
		});

		print(dataToImport);
		
		return false;
	}
}