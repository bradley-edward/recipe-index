import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/recipe_collection.dart';
import '../widgets/edit_entry_form/recipe_form.dart';
import '../widgets/delete_entries_alert_dialog.dart';

class EditRecipeScreen extends StatelessWidget {
	static const routeName = '/edit-recipe';

	@override
	Widget build(BuildContext context) {
		final modalRoute = ModalRoute.of(context);

		int? inputEntryId;
		String? formMode;
		if (modalRoute != null) {
			final modalRouteArgs = modalRoute.settings.arguments as Map<String,Object?>;
			inputEntryId = modalRouteArgs['entryId'] as int?;
			formMode = modalRouteArgs['formMode'] as String;
		} else {
			inputEntryId = null;
			formMode = 'New';
		}

		return Scaffold(
			appBar: AppBar(
				title: Text('$formMode Recipe'),
				actions: [
					if (formMode == 'Edit' && inputEntryId != null) IconButton(
						icon: const Icon(Icons.delete),
						onPressed: () async {
							final confirmDelete = await showDialog(
								context: context,
								builder: (BuildContext ctx) {
									return DeleteEntriesAlertDialog(
										title: Text('Deleting entry ${inputEntryId!}...'),
										content: const Text('Delete this entry?')
									);
								}
							);
							if (confirmDelete) {
								await Provider.of<RecipeCollection>(context, listen: false).deleteEntries({inputEntryId!});
								Navigator.of(context).popUntil(
									ModalRoute.withName('/')
								);
							}
						},
					),
				],
			),
			body: Padding(
				padding: const EdgeInsets.all(16),
				child: SingleChildScrollView(
					child: RecipeForm(inputId: inputEntryId, formMode: formMode,)
				),
			),
		);
	}
}