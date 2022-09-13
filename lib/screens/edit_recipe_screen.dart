import 'package:flutter/material.dart';

import '../widgets/edit_entry_form/recipe_form.dart';

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

		return RecipeForm(inputId: inputEntryId, formMode: formMode,);
	}
}