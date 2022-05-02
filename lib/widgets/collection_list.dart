import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/recipe_collection.dart';
import '../screens/recipe_details_screen.dart';
import './entry_image_displayer.dart';

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
								var hasImages = (currEntry.images != null) && (currEntry.images!.isNotEmpty);
								return ListTile(
									leading: Container(
										width: 60,
										height: 60,
										child: hasImages
										? FittedBox(
											child: EntryImageDisplayer(currEntry.images![0]),
											fit: BoxFit.contain,
										) 
										: const ColoredBox(color: Colors.red),
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