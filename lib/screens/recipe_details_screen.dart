import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/recipe_collection.dart';
import '../screens/edit_recipe_screen.dart';

class RecipeDetailsScreen extends StatelessWidget {
	static const routeName = '/recipe-details';

	@override
	Widget build(BuildContext context) {
		var entryId = ModalRoute.of(context)!.settings.arguments as String;
		var entry = Provider.of<RecipeCollection>(context, listen: false).findById(entryId);

		return Scaffold(
			appBar: AppBar(
				title: Text(entry.name),
			),
			body: Center(child: Text(entry.name)),
			floatingActionButton: FloatingActionButton(
				child: const Icon(Icons.edit),
				onPressed: () {
					Navigator.of(context).pushNamed(EditRecipeScreen.routeName);
				},
			),
			floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
		);
	}
}