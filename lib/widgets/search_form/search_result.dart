import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../collection_list.dart';
import '../../providers/recipe_search_provider.dart';
import '../../providers/recipe_collection.dart';


class SearchResult extends StatelessWidget {
	const SearchResult({ Key? key }) : super(key: key);

	@override
	Widget build(BuildContext context) {
		final recipeCollection = Provider.of<RecipeCollection>(context);
		final recipeSearchProvider = Provider.of<RecipeSearchProvider>(context);

		if (recipeSearchProvider.searchPayload == null) {
			return const Center(
				child: Text('The search results will be displayed here'),
			);
		}

		final fetchedEntries = recipeCollection.searchForEntries(recipeSearchProvider.searchPayload!);
		return Column(
			children: <Widget>[
				Text('${fetchedEntries.length} entries'),
				if (fetchedEntries.isNotEmpty) Expanded(
					child: CollectionList(
						entryList: fetchedEntries,
						isInEditMode: false,
						selectEntryFn: () {},
						selectedEntries: const {},
					),
				),
			],
		);
	}
}