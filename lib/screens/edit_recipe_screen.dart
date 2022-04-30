import 'package:flutter/material.dart';

import '../widgets/main_drawer.dart';

class EditRecipeScreen extends StatelessWidget {
	static const routeName = '/edit-recipe';

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: const Text('Edit Recipe')
			),
			body: const Center(
				child: Text('Edit Recipe'),
			),
		);
	}
}