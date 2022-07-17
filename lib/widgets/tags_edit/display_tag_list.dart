import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/recipe_tag_list.dart';
import '../../models/recipe_tag.dart';
import './tag_edit_alert_dialog.dart';

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

	void _editTagAlertDialog(BuildContext context, RecipeTag tagToEdit) async {
		final String? tagNewName = await showDialog(
			context: context,
			builder: (BuildContext ctx) {
				return TagEditAlertDialog(tagToEdit: tagToEdit,);
			}
		);

		if (tagNewName == null) return;
		final String strippedNewName = tagNewName.trim();
		if (strippedNewName.isEmpty) return;

		await Provider.of<RecipeTagList>(context, listen: false).updateTag(tagToEdit.id!, strippedNewName);
	}

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
						} else {
							_editTagAlertDialog(context, currTag);
						}
					},
				);
			}
		);
	}
}