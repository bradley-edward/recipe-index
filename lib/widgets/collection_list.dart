import 'package:flutter/material.dart';

import '../models/recipe_entry.dart';
import '../screens/recipe_details_screen.dart';
import './entry_image_displayer.dart';

class CollectionList extends StatelessWidget {
	final List<RecipeEntry> entryList;

	const CollectionList(this.entryList, { Key? key }) : super(key: key);

	@override
	Widget build(BuildContext context) {
		return ListView.builder(
			itemCount: entryList.length,
			itemBuilder: (ctx, index) {
				var currEntry = entryList[index];
				return ListTile(
					leading: Container(
						width: 60,
						height: 60,
						child: (currEntry.images.isNotEmpty)
						? FittedBox(
							child: EntryImageDisplayer(currEntry.images[0]),
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
	}
}