import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/collection_list.dart';

class RecipeListScreen extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: const Text("Recipes"),
			),
			body: Container(
				width: double.infinity,
				height: 400,
				child: CollectionList(),
			),
		);
	}
}