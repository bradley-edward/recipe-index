import 'package:flutter/material.dart';

class TagEditAlertDialog extends StatelessWidget {
	final TextEditingController tagController;

	const TagEditAlertDialog({
		required this.tagController,
		Key? key
	}) : super(key: key);

	@override
	Widget build(BuildContext context) {
		return AlertDialog(
			title: const Text('Add New Tag'),
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
					child: const Text('Add'),
				),
			],
		);
	}
}