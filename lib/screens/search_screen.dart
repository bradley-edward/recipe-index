import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/recipe_search_provider.dart';
import '../widgets/search_form/search_form.dart';
import '../widgets/search_form/search_result.dart';
import '../widgets/main_drawer.dart';

class SearchScreen extends StatelessWidget {
	static const routeName = '/search';

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: const Text('Search')
			),
			drawer: MainDrawer(),
			body: ChangeNotifierProvider(
				create: (context) => RecipeSearchProvider(),
				child: Column(
					children: const <Widget>[
						SingleChildScrollView(
							child: SearchForm()
						),
						Expanded(
							child: SearchResult(),
						),
					],
				),
			),
		);
	}
}