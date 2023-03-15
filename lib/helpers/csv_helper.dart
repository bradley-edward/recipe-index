import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:path/path.dart' as path;
import 'package:csv/csv.dart' as csv;

import '../helpers/db_helper.dart';
import './date_helper.dart';
import '../models/entry_image.dart';

class CsvHelper {
	static const _keyTableName = 'TABLE_NAME';
	static const _keyTableColumns = 'TABLE_COLUMNS';
  static const _localImagesFolderName = 'images_local';

	static Future<bool> exportDbToCsv({bool useExternalStorage = false}) async {
    String? chosenDir = '';
    if (useExternalStorage) {
      chosenDir = await FilePicker.platform.getDirectoryPath();
      if (chosenDir == null) return false;
    } else {
      chosenDir = (await syspaths.getApplicationDocumentsDirectory()).path;
    }

		final secondsSinceEpoch = (DateTime.now().millisecondsSinceEpoch / 1000).floor();

    final imagesLocalDirAbsPath = '$chosenDir/${_localImagesFolderName}_$secondsSinceEpoch';

    // Modify 'timestampLastExport' of all 'recipes'.
    DBHelper.updateRecipeLastDateExportAll();

		final db = await DBHelper.database();
		// Need to convert our data into lists-of-lists. One per table.
		final tables = ['recipes', 'tags', 'mn_recipes_tags'];
		final csvLoL = <List<dynamic>>[];
		for (final tableName in tables) {
			final listMap = await db.query(tableName);

			if (listMap.isEmpty) continue;

			final columnNames = listMap[0].keys.toList();
			
			csvLoL.add([_keyTableName, tableName]);
			csvLoL.add([_keyTableColumns, ...columnNames]);
			for (final record in listMap) {
				csvLoL.add(['', ...columnNames.map((col) => record[col]).toList()]);
			}
		}

		// Export images
		final imageList = await db.query('images');
		if (imageList.isNotEmpty) {
      if (imageList.any((record) => (record['imageType'] as int) == ImageType.onPhone.index)) {
        Directory(imagesLocalDirAbsPath).createSync();
      }

			final columnNames = imageList[0].keys.toList();

			csvLoL.add([_keyTableName, 'images']);
			csvLoL.add([_keyTableColumns, ...columnNames]);

			for (final record in imageList) {
				if ((record['imageType'] as int) == ImageType.fromInternet.index) {
					csvLoL.add(columnNames.map((col) => record[col]).toList());
				} else if ((record['imageType'] as int) == ImageType.onPhone.index) {
          csvLoL.add(['', ...columnNames.map((col) {
            if (col == 'imageLocation') {
              final imageFilePath = (record[col] as String);
              final imageFileName = path.basename(imageFilePath);
              File(imageFilePath).copySync('$imagesLocalDirAbsPath/$imageFileName');

              return imageFileName;
            }
            return record[col];
          }).toList()]);
        }
			}
		}

		if (csvLoL.isEmpty) return false;

		final csvString = const csv.ListToCsvConverter().convert(csvLoL);

		final csvFilePath = '$chosenDir/$secondsSinceEpoch.csv';

		try {
			File file = File(csvFilePath);
			await file.writeAsString(csvString);
		} catch (error) {
			return false;
		}

		return true;
	}

  static Future<String?> importFromArchiveFolder() async {
    String? archiveFolderAbsPath = await FilePicker.platform.getDirectoryPath(
      dialogTitle: 'Select archive folder to use for import'
    );
    if (archiveFolderAbsPath == null) return '';

    // getDirectoryPath fails to detect the CSV data file and I don't know why,
    // so selecting the CSV file with pickFiles here is a necessity.
    FilePickerResult? csvFilePickResult = await FilePicker.platform.pickFiles(
      initialDirectory: archiveFolderAbsPath,
      dialogTitle: 'Select the CSV file to use for import',
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );
    if (csvFilePickResult == null) return '';
    final csvFileAbsPath = csvFilePickResult.paths.first;
    if (csvFileAbsPath == null) return 'failed to find CSV file to import from!';
    final csvFileName = path.basenameWithoutExtension(csvFileAbsPath);

    final File csvFile = File(csvFileAbsPath);

    final appDirAbsolutePath = (await syspaths.getApplicationDocumentsDirectory()).absolute.path;
    final localImagesDestDirPath = '$appDirAbsolutePath/${EntryImage.localImagesDirName}';
    final localImagesDestDir = Directory(localImagesDestDirPath);
    if (localImagesDestDir.existsSync()) {
      localImagesDestDir.deleteSync(recursive: true);
    }
    localImagesDestDir.createSync(recursive: true);

    // Import the CSV file's data.
    if (! await importFromCsvFile(csvFile.absolute.path, localImagesDestDirPath)) {
      return 'Importing CSV data to directory failed!';
    }

    // Import the local images.
    try {
      final imagesDir = Directory('$archiveFolderAbsPath/${_localImagesFolderName}_$csvFileName');
      if (imagesDir.existsSync()) {
        for (final imageFile in imagesDir.listSync()) {
          await (imageFile as File).copy('$localImagesDestDirPath/${path.basename(imageFile.path)}');
        }
      }
    } catch (exception) {
      return 'Failed to import local images [$exception]';
    }

    return null;
  }

	static Future<bool> importFromCsvFile(String csvAbsPath, String imagesDestPath) async {
		File csvFile = File(csvAbsPath);

		const csvConvertor = csv.CsvToListConverter(
			shouldParseNumbers: false
		);

		String currentTable = '';
		final tableColumnNames = <String>[];
		int tableRecordLength = -1;

		final dataToImport = <String,List<Map<String,dynamic>>>{};

		await csvFile.openRead().transform(utf8.decoder).transform(csvConvertor).listen((csvRow) {
			if (csvRow[0] == _keyTableName) {
				currentTable = csvRow[1] as String;
				dataToImport[currentTable] = <Map<String,dynamic>>[];
				tableColumnNames.clear();
				tableRecordLength = -1;
				return;
			}

			if (csvRow[0] == _keyTableColumns) {
				tableColumnNames.addAll(csvRow.sublist(1).map((e) => e.toString()));
				tableRecordLength = tableColumnNames.length;
				return;
			}

			final dataRecord = <String,dynamic>{};
			for (var i = 1; i <= tableRecordLength; i++ ) {
				dataRecord[tableColumnNames[i-1]] = csvRow[i];
			}

			dataToImport[currentTable]!.add(dataRecord);
		}).asFuture();

    // Modify 'timestampLastImport' of all imported entries.
    if (dataToImport.containsKey('recipes')) {
      for (var i = 0, ilen = dataToImport['recipes']!.length; i < ilen ; i++) {
        dataToImport['recipes']![i]['timestampLastImport'] = nowSecondsEpoch();
      }
    }

    if (dataToImport.containsKey('images')) {
      for (var i = 0, ilen = dataToImport['images']!.length; i < ilen ; i++) {
        if (int.tryParse(dataToImport['images']![i]['imageType']) == ImageType.onPhone.index) {
          final imgFileName = dataToImport['images']![i]['imageLocation'];
          dataToImport['images']![i]['imageLocation'] = '$imagesDestPath/$imgFileName';
        }
      }
    }

		final didSucceed = DBHelper.dbImportFullOverwrite(dataToImport);
		return didSucceed;
	}
}