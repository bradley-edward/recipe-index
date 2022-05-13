import 'package:flutter/material.dart';

import '../models/recipe_entry.dart';
import '../screens/recipe_details_screen.dart';
import './entry_image_displayer.dart';

class CollectionList extends StatelessWidget {
	final List<RecipeEntry> entryList;
	final bool isInEditMode;
	final Function selectEntryFn;
	final Set<int> selectedEntries;

	const CollectionList({ required this.entryList, required this.isInEditMode, required this.selectEntryFn, required this.selectedEntries, Key? key }) : super(key: key);

	@override
	Widget build(BuildContext context) {
		return ListView.builder(
			itemCount: entryList.length,
			itemBuilder: (ctx, index) {
				final currEntry = entryList[index];
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
					subtitle: Text(currEntry.id!.toString().padLeft(5,'0')),
					trailing: isInEditMode
					? IconButton(
						onPressed: () {
							selectEntryFn(currEntry.id!);
						},
						icon: selectedEntries.contains(currEntry.id!)
						? const Icon(Icons.check_circle)
						: const Icon(Icons.circle_outlined),
					)
					: null,
					onTap: () {
						if (!isInEditMode) {
							Navigator.of(context).pushNamed(RecipeDetailsScreen.routeName, arguments: currEntry.id!);
						} else {
							selectEntryFn(currEntry.id!);
						}
					},
				);
			}
		);
	}
}