import 'package:flutter/material.dart';

import '../screens/tags_edit_screen.dart';
import '../screens/recipe_backup_screen.dart';

class MainDrawer extends StatelessWidget {
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
				const SizedBox(height: 20,),
				buildListTile(
					'Recipes',
					Icons.collections,
					() {
						appNavigator.pushReplacementNamed('/');
					}
				),
				buildListTile(
					'Backup',
					Icons.archive,
					() {
						appNavigator.pushReplacementNamed(RecipeBackupScreen.routeName);
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