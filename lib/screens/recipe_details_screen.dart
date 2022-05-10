import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/recipe_collection.dart';
import '../screens/edit_recipe_screen.dart';
import '../widgets/entry_image_carousel.dart';
import '../models/recipe_complexity.dart';
import '../models/technical_difficulty.dart';

class RecipeDetailsScreen extends StatelessWidget {
	static const routeName = '/recipe-details';

	Widget _buildConfirmDeleteModal(BuildContext ctx) {
		return Column(
			mainAxisAlignment: MainAxisAlignment.center,
			children: <Widget>[
				const Text('Delete this recipe entry?'),
				const SizedBox(height: 10,),
				Row(
					mainAxisAlignment: MainAxisAlignment.center,
					children: <Widget>[
						ElevatedButton(
							onPressed: () {
								Navigator.of(ctx).pop(false);
							},
							child: const Text('Go Back'),
						),
						const SizedBox(width: 10,),
						ElevatedButton(
							onPressed: () {
								Navigator.of(ctx).pop(true);
							},
							child: const Text('Confirm'),
						),
					],
				)
			],
		);
	}

	@override
	Widget build(BuildContext context) {
		final appNav = Navigator.of(context);
		final appTheme = Theme.of(context);

		var entryId = ModalRoute.of(context)!.settings.arguments as String;
		var collectionProvider = Provider.of<RecipeCollection>(context, listen: false);
		final entry = collectionProvider.findById(entryId);

		return Scaffold(
			appBar: AppBar(
				title: Text(entry.name),
				elevation: 0,
				actions: <Widget>[
					IconButton(onPressed: () async {
						final bool confirmDelete = await showModalBottomSheet(
							context: context,
							builder: _buildConfirmDeleteModal,
						);

						if (confirmDelete) {
							await collectionProvider.deleteEntry(entryId);
							appNav.pop();
						}
					},
					icon: const Icon(Icons.delete)),
				],
			),
			body: SingleChildScrollView(
				child: Column(
					mainAxisAlignment: MainAxisAlignment.start,
					children: <Widget>[
						Container(
							height: 240,
							child: entryImageCarousel(entry.images),
						),
						const SizedBox(height: 10,),
						Container(
							child: Text(
								entry.name,
								textAlign: TextAlign.center,
								style: appTheme.textTheme.titleLarge,
							),
						),
						const SizedBox(height: 40,),
						Row(
							mainAxisAlignment: MainAxisAlignment.spaceAround,
							children: [
								Column(
									children: [
										Text(
											'Complexity',
											style: appTheme.textTheme.headline6,
										),
										Text(complexityStrings[entry.complexity]!),
									],
								),
								Column(
									children: [
										Text(
											'Technical Difficulty',
											style: appTheme.textTheme.headline6,
										),
										Text(difficultyStrings[entry.difficulty]!),
									],
								),
							],
						),
					],
				),
			),
			floatingActionButton: FloatingActionButton(
				child: const Icon(Icons.edit),
				onPressed: () {
					appNav.pushNamed(EditRecipeScreen.routeName, arguments: entryId);
				},
			),
			floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
		);
	}
}