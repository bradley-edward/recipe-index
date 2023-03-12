import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../providers/recipe_collection.dart';
import '../providers/recipe_tag_list.dart';
import '../screens/edit_recipe_screen.dart';
import './image_view_screen.dart';
import '../widgets/entry_image_carousel.dart';
import '../widgets/tags_edit/display_tag_list_readonly.dart';
import '../widgets/recipe_details/recipe_dates.dart';
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
			: LayoutBuilder(
				builder: (context, constraints) {
					return Container(
						height: constraints.maxHeight * 0.86,
						child: SingleChildScrollView(
							child: Column(
								mainAxisAlignment: MainAxisAlignment.start,
								children: <Widget>[
									Container(
										height: 240,
										child: entryImageCarousel(
											imageList: entry.images,
											onImageDblTap: (img) {
												appNav.pushNamed(ImageViewScreen.routeName, arguments: img);
											},
										),
									),
									const SizedBox(height: 10,),
									Container(
										child: Text(
											entry.name,
											textAlign: TextAlign.center,
											style: appTheme.textTheme.titleLarge,
										),
									),
									const SizedBox(height: 10,),
                  RatingBarIndicator(
                    rating: entry.rating,
                    itemBuilder: (context, index) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                    ),
                    itemCount: 5,
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
                      Column(
												children: [
													Text(
														'Extra Time',
														style: appTheme.textTheme.headline6,
													),
													Text(entry.additionalTimeHrsMins),
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
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(entry.notes),
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
                  const SizedBox(height: 10,),
                  RecipeDates(
                    timestampCreate: entry.timestampCreate,
                    timestampLastUpdate: entry.timestampLastUpdate,
                    timestampLastExport: entry.timestampLastExport,
                    timestampLastImport: entry.timestampLastImport,
                  ),
								],
							),
						),
					);
				}
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