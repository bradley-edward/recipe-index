import 'package:flutter/material.dart';

import '../../models/recipe_tag.dart';

class MergeTwoTagsAlertDialog extends StatelessWidget {
	final RecipeTag tag1;
	final RecipeTag tag2;

	const MergeTwoTagsAlertDialog({
		required this.tag1,
		required this.tag2,
		Key? key
	}) : super(key: key);

	@override
	Widget build(BuildContext context) {
		return AlertDialog(
			title: const Text('Combine Two Tags'),
			content: Row(
				mainAxisAlignment: MainAxisAlignment.center,
				children: <Widget>[
					Card(
						child: Padding(
							padding: const EdgeInsets.all(8.0),
							child: Text(tag1.name),
						),
					),
					Card(
						child: IconButton(onPressed: () {}, icon: const Icon(Icons.arrow_back)),
					),
					Card(
						child: Padding(
							padding: const EdgeInsets.all(8.0),
							child: Text(tag2.name),
						),
					),
				],
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
						//Navigator.of(context).pop(tagController.text);
					},
					child: const Text('Combine'),
				),
			],
		);
	}
}