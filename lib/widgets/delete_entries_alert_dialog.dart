import 'package:flutter/material.dart';

class DeleteEntriesAlertDialog extends StatelessWidget {
	final Text title;
	final Text content;

	DeleteEntriesAlertDialog({Key? key, required this.title, required this.content}) : super(key: key);

	@override
	Widget build(BuildContext context) {
		return AlertDialog(
			title: title,
			content: Center(
				child: content,
			),
			actions: <Widget>[
				TextButton(
					onPressed: () {
						Navigator.of(context).pop(false);
					},
					child: const Text('No'),
				),
				TextButton(
					onPressed: () {
						Navigator.of(context).pop(true);
					},
					child: const Text('Yes'),
				),
			],
		);
	}
}