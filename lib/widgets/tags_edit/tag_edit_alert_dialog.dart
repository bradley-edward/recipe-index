import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/recipe_tag_list.dart';
import '../../models/recipe_tag.dart';

class TagEditAlertDialog extends StatefulWidget {
	final RecipeTag? tagToEdit;

	const TagEditAlertDialog({
		this.tagToEdit,
		Key? key
	}) : super(key: key);

	@override
	State<TagEditAlertDialog> createState() => _TagEditAlertDialogState();
}

class _TagEditAlertDialogState extends State<TagEditAlertDialog> {
	final _form = GlobalKey<FormState>();
	String? _tagInput = '';

	@override
	Widget build(BuildContext context) {
		final titleText = widget.tagToEdit != null ? "Edit Tag '${widget.tagToEdit!.name}'" : 'Add New Tag';
		final actionButtonText = widget.tagToEdit != null ? 'Save' : 'Add';

		return AlertDialog(
			title: Text(titleText),
			content: Container(
				height: 100,
				width: 200,
				child: Form(
					key: _form,
					child: Center(
						child: TextFormField(
							initialValue: widget.tagToEdit != null ? widget.tagToEdit!.name : null,
							validator: (tagName) {
								if (tagName == null) return 'Please input a string.';
								if (tagName.isEmpty) return 'Please input a string.';
								final String strippedTagName = tagName.trim();
								if (strippedTagName.isEmpty) return 'Please input a string that is not pure whitespace.';

								final value = Provider.of<RecipeTagList>(context, listen: false).containsTagWithName(strippedTagName);
								if (value) return 'That tag already exists.';

								return null;
							},
							onSaved: (newValue) {
								_tagInput = newValue;
							},
						),
					),
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
						var currentFormState = _form.currentState;
						if (currentFormState == null) {
							return;
						}

						final isValid = currentFormState.validate();
						if (!isValid) {
							return;
						}

						currentFormState.save();

						Navigator.of(context).pop(_tagInput);
					},
					child: Text(actionButtonText),
				),
			],
		);
	}
}