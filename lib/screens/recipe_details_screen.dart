import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/recipe_collection.dart';
import '../screens/edit_recipe_screen.dart';
import '../widgets/entry_image_carousel.dart';

class RecipeDetailsScreen extends StatelessWidget {
	static const routeName = '/recipe-details';

	@override
	Widget build(BuildContext context) {
		var entryId = ModalRoute.of(context)!.settings.arguments as String;
		var entry = Provider.of<RecipeCollection>(context).findById(entryId);

		return Scaffold(
			appBar: AppBar(
				title: Text(entry.name),
				elevation: 0,
			),
			body: SingleChildScrollView(
				child: Column(
					mainAxisAlignment: MainAxisAlignment.center,
					children: <Widget>[
						Container(
							height: 240,
							child: entryImageCarousel(entry.images),
						),
						const SizedBox(height: 10,),
						Container(
							height: 100,
							child: Text(
								entry.name,
								textAlign: TextAlign.center,
								style: TextStyle(
									fontWeight: FontWeight.bold,
								),
							),
						),
					],
				),
			),
			floatingActionButton: FloatingActionButton(
				child: const Icon(Icons.edit),
				onPressed: () {
					Navigator.of(context).pushNamed(EditRecipeScreen.routeName, arguments: entryId);
				},
			),
			floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
		);
	}
}