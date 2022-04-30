import 'package:flutter/material.dart';

import '../models/dummy_data.dart';

class RecipeListScreen extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: const Text("Recipe List"),
			),
			body: Container(
				width: double.infinity,
				height: 400,
				child: ListView.builder(
					itemCount: dummyData.length,
					itemBuilder: (ctx, index) {
						var currEntry = dummyData[index];
						return ListTile(
							leading: Container(
								width: 50,
								height: 50,
								decoration: const BoxDecoration(
									color: Colors.red,
								),
							),
							title: Text(currEntry['name']),
							subtitle: Text(currEntry['entryId']),
						);
					}
				),
			),
		);
	}
}