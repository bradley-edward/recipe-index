import 'package:flutter/material.dart';

import '../../models/recipe_tag.dart';

class MergeTwoTagsAlertDialog extends StatefulWidget {
	final RecipeTag tag1;
	final RecipeTag tag2;

	const MergeTwoTagsAlertDialog({
		required this.tag1,
		required this.tag2,
		Key? key
	}) : super(key: key);

	@override
	State<MergeTwoTagsAlertDialog> createState() => _MergeTwoTagsAlertDialogState();
}

class _MergeTwoTagsAlertDialogState extends State<MergeTwoTagsAlertDialog> {
	bool _mergeDirectionIsRTL = true;

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
							child: Text(widget.tag1.name),
						),
					),
					Card(
						child: IconButton(
							onPressed: () {
								setState(() {
									_mergeDirectionIsRTL = ! _mergeDirectionIsRTL;
								});
							},
							icon: Icon(_mergeDirectionIsRTL ? Icons.arrow_back : Icons.arrow_forward)
						),
					),
					Card(
						child: Padding(
							padding: const EdgeInsets.all(8.0),
							child: Text(widget.tag2.name),
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
						Navigator.of(context).pop(_mergeDirectionIsRTL);
					},
					child: const Text('Combine'),
				),
			],
		);
	}
}