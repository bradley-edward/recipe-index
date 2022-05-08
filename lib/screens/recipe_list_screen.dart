import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/recipe_collection.dart';
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
		return Provider.of<RecipeCollection>(context).fetchAndSetRecipes();
	}

	var _isInit = false;
	var _isInEditMode = false;
	final Set<String> _selectedEntries = {};

	void _selectEntry(String id) {
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
		if (! _isInit) {
			_recipesFuture = _obtainRecipesFuture();
			_isInit = true;
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
						IconButton(
							icon: const Icon(Icons.delete),
							onPressed: () {
								print(_selectedEntries);
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
								child: const Center(child: Text('Got no recipes yet, start adding some!')),
								builder: (ctx, recipeCollection, ch) {
									final fetchedEntries = recipeCollection.entries;
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