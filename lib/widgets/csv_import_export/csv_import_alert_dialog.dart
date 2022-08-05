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
						return ListTile(
							title: Text(csvImportList[index]),
						);
					}
				),
			)
		);
	}
}