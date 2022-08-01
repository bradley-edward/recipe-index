import 'package:flutter/material.dart';

import './display_tag_list_readonly.dart';
import '../../models/recipe_tag.dart';

class DeleteTagsAlertDialog extends StatelessWidget {
	final List<RecipeTag> tagsToDelete;
	const DeleteTagsAlertDialog({
		required this.tagsToDelete,
		Key? key
	}) : super(key: key);

	@override
	Widget build(BuildContext context) {
		return AlertDialog(
			title: const Text('Delete Tags'),
			content: DisplayTagListReadonly(tagList: tagsToDelete),
			actions: <Widget>[
				TextButton(
					onPressed: () {
						Navigator.of(context).pop(false);
					},
					child: const Text('Cancel'),
				),
				TextButton(
					onPressed: () {
						Navigator.of(context).pop(true);
					},
					child: const Text('Delete'),
				),
			],
		);
	}
}