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

	Future<void> _editTagAlertDialog(BuildContext context, RecipeTag tagToEdit) async {
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
		final appTheme = Theme.of(context);

		return SingleChildScrollView(
			child: Padding(
				padding: const EdgeInsets.all(8.0),
				child: Wrap(
					spacing: 6.0,
					children: tagList.map((currTag) {
						final tagId = currTag.id!;
						final isSelected = isInEditMode && selectedTags.contains(tagId);

						final chipColor = isSelected
						? appTheme.primaryColor
						: Colors.white;

						final textColor = isSelected
						? Colors.white
						: Colors.black;

						return GestureDetector(
							onTap: () {
								if (isInEditMode) {
									selectTagFn(tagId);
								} else {
									_editTagAlertDialog(context, currTag);
								}
							},
							onLongPress: () {
								longPressSelectTagFn(tagId);
							},
							child: Chip(
								avatar: CircleAvatar(
									child: Text(
										currTag.name.substring(0,2),
										style: const TextStyle(
											fontSize: 13,
										),
									),
									foregroundColor: textColor,
								),
								label: Text(currTag.name),
								backgroundColor: chipColor,
								elevation: 2,
								labelStyle: TextStyle(
									color: textColor
								),
							),
						);
					}).toList(),
				),
			),
		);
	}
}