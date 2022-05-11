import 'package:flutter/material.dart';

import '../widgets/main_drawer.dart';

class RecipeArchiveScreen extends StatelessWidget {
	static const routeName = '/recipe-archive';

	const RecipeArchiveScreen({ Key? key }) : super(key: key);

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: const Text('Recipe Archives'),
				elevation: 0,
			),
			drawer: MainDrawer(),
			body: Padding(
				padding: const EdgeInsets.symmetric(horizontal: 16),
				child: Column(
					mainAxisAlignment: MainAxisAlignment.center,
					children: const <Widget>[
						Text('This screen is for exporting backup CSVs of the recipes saved to this app.'),
						SizedBox(height: 10,),
						Text('Also for importing said CSVs back into the app.'),
					],
				),
			),
		);
	}
}