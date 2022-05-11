import 'package:flutter/material.dart';

import '../screens/recipe_archive_screen.dart';

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
					'Archives',
					Icons.archive,
					() {
						appNavigator.pushReplacementNamed(RecipeArchiveScreen.routeName);
					}
				),
			],),
		);
	}
}