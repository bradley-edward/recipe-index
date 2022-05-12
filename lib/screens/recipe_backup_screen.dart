import 'package:flutter/material.dart';

import '../widgets/main_drawer.dart';
import '../helpers/db_helper.dart';

class RecipeBackupScreen extends StatelessWidget {
	static const routeName = '/recipe-backup';

	const RecipeBackupScreen({ Key? key }) : super(key: key);

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: const Text('Recipe Backup'),
				elevation: 0,
			),
			drawer: MainDrawer(),
			body: Center(
				child: Column(
					crossAxisAlignment: CrossAxisAlignment.center,
					mainAxisAlignment: MainAxisAlignment.center,
					children: <Widget>[
						ElevatedButton(
							onPressed: () async {
								final backupString = await DBHelper.generateBackup(isEncrypted: true);
								print(backupString);
							},
							child: const Text('Generate Backup'),
						),
						const SizedBox(height: 20,),
						ElevatedButton(
							onPressed: () {
								
							},
							child: const Text('Restore from Backup'),
						),
					],
				),
			),
		);
	}
}