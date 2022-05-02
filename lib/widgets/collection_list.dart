import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/recipe_collection.dart';
import '../screens/recipe_details_screen.dart';

class CollectionList extends StatelessWidget {
	const CollectionList({ Key? key }) : super(key: key);

	@override
	Widget build(BuildContext context) {
		return FutureBuilder(
			future: Provider.of<RecipeCollection>(context, listen: false).fetchAndSetRecipes(),
			builder: (context, snapshot) {
				if (snapshot.connectionState != ConnectionState.done) {
					return const Center(child: CircularProgressIndicator(),);
				}
				return Consumer<RecipeCollection>(
					child: const Center(child: Text('Got no recipes yet, start adding some!')),
					builder: (ctx, recipeCollection, ch) {
						final fetchedEntries = recipeCollection.entries;
						final recipesCount = fetchedEntries.length;

						if (recipesCount <= 0) {
							return ch!;
						}

						return ListView.builder(
							itemCount: recipesCount,
							itemBuilder: (ctx, index) {
								var currEntry = fetchedEntries[index];
								return ListTile(
									leading: Container(
										width: 50,
										height: 50,
										decoration: const BoxDecoration(
											color: Colors.red,
										),
									),
									title: Text(currEntry.name),
									subtitle: Text(currEntry.entryId),
									onTap: () {
										Navigator.of(context).pushNamed(RecipeDetailsScreen.routeName, arguments: currEntry.id);
									},
								);
							}
						);
					},
				);
			}
		);
	}
}