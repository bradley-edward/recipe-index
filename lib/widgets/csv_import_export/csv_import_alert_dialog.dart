import 'package:flutter/material.dart';

class CsvImportAlertDialog extends StatefulWidget {
	final List<String> csvImportList;

	const CsvImportAlertDialog({
		required this.csvImportList,
		Key? key
	}) : super(key: key);

	@override
	State<CsvImportAlertDialog> createState() => _CsvImportAlertDialogState();
}

class _CsvImportAlertDialogState extends State<CsvImportAlertDialog> {
	int _selectedIdx = -1;

	@override
	Widget build(BuildContext context) {
		final appNav = Navigator.of(context);

		return AlertDialog(
			title: const Text('Import from CSV'),
			content: Container(
				width: 500,
				height: 500,
				child: ListView.builder(
					itemCount: widget.csvImportList.length,
					itemBuilder: (ctx, index) {
						final currPath = widget.csvImportList[index];

						final regExp = RegExp(r'[0-9]+\.csv');

						final timestamp = int.parse(regExp.firstMatch(currPath)![0]!.split('.')[0]);
						final fileDateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);

						return ElevatedButton(
							child: Text(fileDateTime.toString()),
							onPressed: () {
								setState(() {
									_selectedIdx = index;
								});
							},
							style: ButtonStyle(
								backgroundColor: _selectedIdx == index
								? MaterialStateProperty.all(Colors.green)
								: MaterialStateProperty.all(Theme.of(context).primaryColor),
							),
						);
					}
				),
			),
			actions: <Widget>[
				TextButton(
					onPressed: () {
						appNav.pop(-1);
					},
					child: const Text('Cancel'),
				),
				TextButton(
					onPressed: _selectedIdx != -1
					? () {
						appNav.pop(_selectedIdx);
					}
					: null,
					child: const Text('Import Selected'),
				),
			],
		);
	}
}