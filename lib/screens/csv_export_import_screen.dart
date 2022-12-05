import 'package:flutter/material.dart';

import '../widgets/main_drawer.dart';
import '../helpers/csv_helper.dart';

Future<void> exportDbToCsvFile(BuildContext ctx, {bool useExternalStorage = false}) async {
	final didSucceed = await CsvHelper.exportDbToCsv(useExternalStorage: useExternalStorage);

	final msnger = ScaffoldMessenger.of(ctx);

	msnger.hideCurrentSnackBar();
	ScaffoldMessenger.of(ctx).showSnackBar(
		SnackBar(
			content: Text(didSucceed ? 'CSV Export successfully saved!' : 'Failed to save CSV export'),
			backgroundColor: didSucceed ? Colors.black54 : Theme.of(ctx).errorColor,
		)
	);
}

Future<void> _csvImportFilePicker(BuildContext ctx) async {
  final errorMsg = await CsvHelper.importFromArchiveFolder();
  if (errorMsg == null) {
    Navigator.of(ctx).pushReplacementNamed('/');
  } else {
    if (errorMsg == '') return;

    final msnger = ScaffoldMessenger.of(ctx);

    msnger.hideCurrentSnackBar();
    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(
        content: Text('FAIL! [$errorMsg]'),
        backgroundColor: Theme.of(ctx).errorColor,
      )
    );
  }
}

class CsvExportImportScreen extends StatelessWidget {
	static const routeName = '/csv-export-import';

	const CsvExportImportScreen({ Key? key }) : super(key: key);

	@override
	Widget build(BuildContext context) {

		return Scaffold(
			appBar: AppBar(
				title: const Text('CSV Export/Import'),
				elevation: 0,
			),
			drawer: MainDrawer(),
			body: Center(
				child: Column(
					crossAxisAlignment: CrossAxisAlignment.center,
					mainAxisAlignment: MainAxisAlignment.center,
					children: <Widget>[
						ElevatedButton(
							onPressed: () { exportDbToCsvFile(context, useExternalStorage: true); },
							child: const Text('Export Data to CSV'),
						),
						const SizedBox(height: 20,),
						ElevatedButton(
							onPressed: () { _csvImportFilePicker(context); },
							child: const Text('Import Data from CSV'),
						),
					],
				),
			),
		);
	}
}