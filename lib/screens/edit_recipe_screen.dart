import 'package:flutter/material.dart';

import '../widgets/image_input.dart';

class EditRecipeScreen extends StatelessWidget {
	static const routeName = '/edit-recipe';

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: const Text('Edit Recipe')
			),
			body: Center(
				child: ImageInput(() {}),
			),
		);
	}
}