import 'package:flutter/material.dart';

import '../screens/tags_edit_screen.dart';
import '../screens/csv_export_import_screen.dart';

class MainDrawer extends StatelessWidget {
  static const String _projectVersion = 'v1.0 (2022-Dec-11)';

	Widget buildListTile(String title, IconData icon, VoidCallback tapHandler) {
		return ListTile(
			leading: Icon(
				icon,
				size: 26,
			),
			title: Text(
				title,
				style: const TextStyle(
					fontSize: 20,
					fontWeight: FontWeight.bold,
				),
			),
			onTap: tapHandler,
		);
	}

 	@override
	Widget build(BuildContext context) {
		final appNavigator = Navigator.of(context);
		return Drawer(
			child: Column(children: <Widget>[
        const DrawerHeader(
          decoration: BoxDecoration(
            color: Colors.blue,
          ),
          child: Text(
            _projectVersion,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
        ),
				buildListTile(
					'Recipes',
					Icons.collections,
					() {
						appNavigator.pushReplacementNamed('/');
					}
				),
				buildListTile(
					'CSV Export/Import',
					Icons.archive,
					() {
						appNavigator.pushReplacementNamed(CsvExportImportScreen.routeName);
					}
				),
				buildListTile(
					'Tags List',
					Icons.tag,
					() {
						appNavigator.pushReplacementNamed(TagsEditScreen.routeName);
					}
				),
			],),
		);
	}
}