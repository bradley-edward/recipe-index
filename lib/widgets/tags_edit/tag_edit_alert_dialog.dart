import 'package:flutter/material.dart';
import '../../models/recipe_tag.dart';

class TagEditAlertDialog extends StatelessWidget {
	final RecipeTag? tagToEdit;

	const TagEditAlertDialog({
		this.tagToEdit,
		Key? key
	}) : super(key: key);

	@override
	Widget build(BuildContext context) {
		final tagController = TextEditingController(text: tagToEdit != null ? tagToEdit!.name : null);

		final titleText = tagToEdit != null ? "Edit Tag '${tagToEdit!.name}'" : 'Add New Tag';
		final actionButtonText = tagToEdit != null ? 'Save' : 'Add';

		return AlertDialog(
			title: Text(titleText),
			content: Center(
				child: TextField(
					controller: tagController,
				),
			),
			actions: <Widget>[
				TextButton(
					onPressed: () {
						Navigator.of(context).pop(null);
					},
					child: const Text('Cancel'),
				),
				TextButton(
					onPressed: () {
						Navigator.of(context).pop(tagController.text);
					},
					child: Text(actionButtonText),
				),
			],
		);
	}
}