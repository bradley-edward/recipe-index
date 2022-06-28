import 'package:flutter/material.dart';

import '../../models/recipe_tag.dart';

class DisplayTagList extends StatelessWidget {
	final List<RecipeTag> tagList;
	final bool isInEditMode;
	final Function selectTagFn;
	final Function longPressSelectTagFn;
	final Set<int> selectedTags;

	const DisplayTagList({
		required this.tagList,
		required this.isInEditMode,
		required this.selectTagFn,
		required this.longPressSelectTagFn,
		required this.selectedTags,
		Key? key
	}) : super(key: key);

	@override
	Widget build(BuildContext context) {
		return ListView.builder(
			itemCount: tagList.length,
			itemBuilder: (ctx, index) {
				final currTag = tagList[index];
				return ListTile(
					title: Text(currTag.name),
					trailing: isInEditMode
					? IconButton(
						onPressed: () {
							selectTagFn(currTag.id!);
						},
						icon: selectedTags.contains(currTag.id!)
						? const Icon(Icons.check_circle)
						: const Icon(Icons.circle_outlined),
					)
					: null,
					onLongPress: () {
						if (! isInEditMode) {
							longPressSelectTagFn(currTag.id!);
						}
					},
					onTap: () {
						if (isInEditMode) {
							selectTagFn(currTag.id!);
						}
					},
				);
			}
		);
	}
}