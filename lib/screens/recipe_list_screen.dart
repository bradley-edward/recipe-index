import 'package:flutter/material.dart';

import '../widgets/collection_list.dart';
import '../widgets/main_drawer.dart';
import './search_screen.dart';
import './edit_recipe_screen.dart';

class RecipeListScreen extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		final appNavigator = Navigator.of(context);
		return Scaffold(
			appBar: AppBar(
				title: const Text("Recipes"),
				actions: <Widget>[
					IconButton(
						icon: const Icon(Icons.search),
						onPressed: () {
							appNavigator.pushReplacementNamed(SearchScreen.routeName);
						},
					)
				],
			),
			drawer: MainDrawer(),
			body: Container(
				width: double.infinity,
				height: 400,
				child: CollectionList(),
			),
			floatingActionButton: FloatingActionButton(
				child: const Icon(Icons.add),
				onPressed: () {
					appNavigator.pushNamed(EditRecipeScreen.routeName);
				},
			),
			floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
		);
	}
}