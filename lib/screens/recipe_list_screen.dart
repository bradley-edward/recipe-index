import 'package:flutter/material.dart';

final dummyData = <Map<String,dynamic>>[
	{
		'id': 'e1',
		'entryId': '0001',
		'name': 'Glazed Carrots'
	},
	{
		'id': 'e2',
		'entryId': '0002',
		'name': 'Brown Sugar Mustard Glazed Ham'
	},
	{
		'id': 'e3',
		'entryId': '0004',
		'name': 'Philly Cheesesteak'
	},
	{
		'id': 'e4',
		'entryId': '0006',
		'name': 'Soy-Balsamic Glazed Sea Scallops'
	},
];

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