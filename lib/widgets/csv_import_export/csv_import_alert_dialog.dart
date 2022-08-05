import 'package:flutter/material.dart';

class CsvImportAlertDialog extends StatelessWidget {
	final List<String> csvImportList;

	const CsvImportAlertDialog({
		required this.csvImportList,
		Key? key
	}) : super(key: key);

	@override
	Widget build(BuildContext context) {
		return AlertDialog(
			title: const Text('Import from CSV'),
			content: Container(
				width: 500,
				height: 500,
				child: ListView.builder(
					itemCount: csvImportList.length,
					itemBuilder: (ctx, index) {
						final currPath = csvImportList[index];

						final regExp = RegExp(r'[0-9]+\.csv');

						final timestamp = int.parse(regExp.firstMatch(currPath)![0]!.split('.')[0]);
						final fileDateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);

						return ElevatedButton(
							child: Text(fileDateTime.toString()),
							onPressed: () {},
						);
					}
				),
			)
		);
	}
}