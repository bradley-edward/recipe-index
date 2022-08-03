import 'package:flutter/material.dart';

import '../widgets/main_drawer.dart';
import '../helpers/csv_helper.dart';

Future<void> exportDbToCsvFile() async {
	final didSucceed = await CsvHelper.exportDbToCsv();
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
						const ElevatedButton(
							onPressed: exportDbToCsvFile,
							child: Text('Export Data to CSV'),
						),
						const SizedBox(height: 20,),
						ElevatedButton(
							onPressed: () {},
							child: const Text('Import Data from CSV'),
						),
					],
				),
			),
		);
	}
}