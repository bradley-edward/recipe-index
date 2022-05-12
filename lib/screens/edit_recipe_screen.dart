import 'package:flutter/material.dart';

import '../widgets/edit_entry_form/recipe_form.dart';

class EditRecipeScreen extends StatelessWidget {
	static const routeName = '/edit-recipe';

	@override
	Widget build(BuildContext context) {
		final modalRoute = ModalRoute.of(context);

		String? inputEntryId;
		String? formMode;
		if (modalRoute != null) {
			final modalRouteArgs = modalRoute.settings.arguments as Map<String,String?>;
			inputEntryId = modalRouteArgs['entryId'];
			formMode = (modalRoute.settings.arguments as Map<String,String?>)['formMode']!;
		} else {
			inputEntryId = null;
			formMode = 'New';
		}

		return Scaffold(
			appBar: AppBar(
				title: Text('$formMode Recipe')
			),
			body: Padding(
				padding: const EdgeInsets.all(16),
				child: SingleChildScrollView(
					child: RecipeForm(inputId: inputEntryId)
				),
			),
		);
	}
}