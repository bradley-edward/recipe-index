import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/recipe_collection.dart';
import '../providers/recipe_tag_list.dart';
import '../screens/edit_recipe_screen.dart';
import '../widgets/entry_image_carousel.dart';
import '../widgets/tags_edit/display_tag_list_readonly.dart';
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

		final entryId = ModalRoute.of(context)!.settings.arguments as int;
		var collectionProvider = Provider.of<RecipeCollection>(context);
		final entry = collectionProvider.findById(entryId);

		return Scaffold(
			appBar: AppBar(
				title: Text(entry != null ? entry.idString : 'Entry Not Found'),
				elevation: 0,
				actions: <Widget>[
					if (entry != null) IconButton(
						onPressed: () async {
							final bool confirmDelete = await showModalBottomSheet(
								context: context,
								builder: _buildConfirmDeleteModal,
							);

							if (confirmDelete) {
								await collectionProvider.deleteEntry(entryId);
								appNav.pop();
							}
						},
						icon: const Icon(Icons.delete)
					),
				],
			),
			body: entry == null
			? const Center(
				child: Text('That entry cannot be found!'),
			)
			: Container(
				height: 520,
				child: SingleChildScrollView(
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
												'Expertise',
												style: appTheme.textTheme.headline6,
											),
											Text(difficultyStrings[entry.difficulty]!),
										],
									),
								],
							),
							const SizedBox(height: 20,),
							Row(
								mainAxisAlignment: MainAxisAlignment.spaceAround,
								children: [
									Column(
										children: [
											Text(
												'Prep. Time',
												style: appTheme.textTheme.headline6,
											),
											Text(entry.prepTimeHrsMins),
										],
									),
									Column(
										children: [
											Text(
												'Cooking Time',
												style: appTheme.textTheme.headline6,
											),
											Text(entry.cookingTimeHrsMins),
										],
									),
								],
							),
							const SizedBox(height: 20,),
							Row(
								mainAxisAlignment: MainAxisAlignment.spaceAround,
								children: [
									Column(
										children: [
											Text(
												'Servings',
												style: appTheme.textTheme.headline6,
											),
											Text(entry.servings.toString()),
										],
									),
								],
							),
							const SizedBox(height: 10,),
							if (entry.tagIds.isNotEmpty) ...[
								Text(
									'Tags',
									style: appTheme.textTheme.headline6,
								),
								DisplayTagListReadonly(
									tagList: Provider.of<RecipeTagList>(context, listen: false).findByIdSet(entry.tagIds),
								),
							],
						],
					),
				),
			),
			floatingActionButton: entry == null
			? null
			: Row(
				mainAxisAlignment: MainAxisAlignment.center,
				children: <Widget>[
					FloatingActionButton(
						heroTag: 'editThis',
						child: const Icon(Icons.edit),
						onPressed: () {
							appNav.pushNamed(EditRecipeScreen.routeName, arguments: {
								'entryId': entryId,
								'formMode': 'Edit'
							});
						},
					),
					const SizedBox(width: 20),
					FloatingActionButton(
						heroTag: 'newBasedOnThis',
						child: const Icon(Icons.content_copy),
						onPressed: () {
							appNav.pushNamed(EditRecipeScreen.routeName, arguments: {
								'entryId': entryId,
								'formMode': 'New'
							});
						},
					),
				],
			),
			floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
		);
	}
}