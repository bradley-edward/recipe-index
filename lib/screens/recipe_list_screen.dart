import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/recipe_entry.dart';
import '../providers/recipe_collection.dart';
import '../providers/recipe_tag_list.dart';
import '../widgets/collection_list.dart';
import '../widgets/main_drawer.dart';
import './search_screen.dart';
import './edit_recipe_screen.dart';

class RecipeListScreen extends StatefulWidget {
	@override
	State<RecipeListScreen> createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
	Future<Object>? _recipesFuture;

	Future<Object>? _obtainRecipesFuture() {
		final futures = <Future>[
			Provider.of<RecipeCollection>(context).fetchAndSetRecipes(),
			Provider.of<RecipeTagList>(context).fetchAndSetTags()
		];
		return Future.wait(futures);
	}

	var _isInit = true;
	var _isInEditMode = false;
	final Set<int> _selectedEntries = {};

	void _selectEntry(int id) {
		setState(() {
			if (_selectedEntries.contains(id)) {
				_selectedEntries.remove(id);
			} else {
				_selectedEntries.add(id);
			}
		});
	}
	
	@override
	void didChangeDependencies() {
		super.didChangeDependencies();
		if (_isInit) {
			_recipesFuture = _obtainRecipesFuture();
			_isInit = false;
		}
	}

	@override
	Widget build(BuildContext context) {
		final appNavigator = Navigator.of(context);

		return Scaffold(
			appBar: AppBar(
				leading: _isInEditMode
				? IconButton(onPressed: () {
					setState(() {
					  _isInEditMode = false;
					});
				}, icon: const Icon(Icons.arrow_back))
				: null,
				title: const Text("Recipes"),
				actions: <Widget>[
					if (!_isInEditMode) ...<Widget>[
						IconButton(
							icon: const Icon(Icons.search),
							onPressed: () {
								appNavigator.pushReplacementNamed(SearchScreen.routeName);
							},
						),
						IconButton(
							icon: const Icon(Icons.edit),
							onPressed: () {
								setState(() {
									_isInEditMode = true;
								});
							},
						),
					],
					if (_isInEditMode) ...<Widget>[
						if (_selectedEntries.isNotEmpty) IconButton(
							icon: const Icon(Icons.delete),
							onPressed: () async {
								final confirmDelete = await showDialog(
									context: context,
									builder: (BuildContext ctx) {
										return AlertDialog(
											title: const Text('Deleting entries...'),
											content: const Center(
												child: Text('Delete the selected entries?'),
											),
											actions: <Widget>[
												TextButton(
													onPressed: () {
														Navigator.of(context).pop(false);
													},
													child: const Text('No'),
												),
												TextButton(
													onPressed: () {
														Navigator.of(context).pop(true);
													},
													child: const Text('Yes'),
												),
											],
										);
									}
								);
								if (confirmDelete) {
									Provider.of<RecipeCollection>(context, listen: false).deleteEntries(_selectedEntries);
								}
							},
						),
						IconButton(
							icon: const Icon(Icons.edit_off),
							onPressed: () {
								setState(() {
									_isInEditMode = false;
								});
							},
						),
					],
				],
			),
			drawer: _isInEditMode ? null : MainDrawer(),
			body: FutureBuilder<Object>(
				future: _recipesFuture,
				builder: (context, dataSnapshot) {
					if (dataSnapshot.connectionState == ConnectionState.waiting) {
						return const Center(child: CircularProgressIndicator());
					} else {
						if (dataSnapshot.hasError) {
							return const Center(child: Text('An error occurred!'),);
						} else {
							return Consumer<RecipeCollection>(
								child: const Center(
									child: Text('Got no recipes yet; start adding some!'),
								),
								builder: (ctx, recipeCollection, ch) {
									final List<RecipeEntry> fetchedEntries = recipeCollection.entries;
									final recipesCount = fetchedEntries.length;

									if (recipesCount <= 0) {
										return ch!;
									}

									return Container(
										width: double.infinity,
										height: 500,
										child: CollectionList(
											entryList: fetchedEntries,
											isInEditMode: _isInEditMode,
											selectEntryFn: _selectEntry,
											selectedEntries: _selectedEntries
										),
									);
								}
							);
						}
					}
				}
			),
			floatingActionButton: Row(
				mainAxisAlignment: MainAxisAlignment.center,
				children: <Widget>[
					FloatingActionButton(
						heroTag: 'addNew',
						child: const Icon(Icons.add),
						onPressed: () {
							appNavigator.pushNamed(EditRecipeScreen.routeName, arguments: {
								'entryId': null,
								'formMode': 'New'
							});
						},
					),
					const SizedBox(width: 20),
					FloatingActionButton(
						heroTag: 'addDummyData',
						child: const Icon(Icons.add_box),
						onPressed: () async {
							await Provider.of<RecipeCollection>(context, listen: false).populateWithDummyData();
						},
					),
				],
			),
			floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
		);
	}
}