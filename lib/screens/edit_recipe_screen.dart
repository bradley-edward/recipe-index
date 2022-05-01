import 'package:flutter/material.dart';

import '../widgets/recipe_form.dart';

class EditRecipeScreen extends StatelessWidget {
	static const routeName = '/edit-recipe';

	@override
	Widget build(BuildContext context) {
		final modalRoute = ModalRoute.of(context);

		String? inputEntryId;
		if (modalRoute != null) {
			inputEntryId = modalRoute.settings.arguments as String?;
		} else {
			inputEntryId = null;
		}

		return Scaffold(
			appBar: AppBar(
				title: const Text('Edit Recipe')
			),
			body: Padding(
				padding: const EdgeInsets.all(16),
				child: RecipeForm(inputId: inputEntryId),
			),
		);
	}
}