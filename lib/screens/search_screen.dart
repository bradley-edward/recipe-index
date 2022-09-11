import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/recipe_search_provider.dart';
import '../widgets/search_form/search_form.dart';
import '../widgets/search_form/search_result.dart';
import '../widgets/main_drawer.dart';

class SearchScreen extends StatelessWidget {
	static const routeName = '/search';

	Widget _componentsList(Orientation orientation, BoxConstraints constraints) {
		const componentsList = <Widget>[
			SingleChildScrollView(
				child: SearchForm()
			),
			Expanded(
				child: SearchResult(),
			),
		];

		if (orientation == Orientation.portrait) {
			return Column(
				children: const <Widget>[
					SingleChildScrollView(
						child: SearchForm()
					),
					Expanded(
						child: SearchResult(),
					),
				],
			);
		}

		return Row(
			children: <Widget>[
				Container(
					height: constraints.maxHeight,
					width: constraints.maxWidth * 0.55,
					child: const SingleChildScrollView(
						child: SearchForm()
					),
				),
				const Expanded(
					child: SearchResult(),
				),
			],
		);
	}

	@override
	Widget build(BuildContext context) {
		final orientation = MediaQuery.of(context).orientation;

		return Scaffold(
			appBar: AppBar(
				title: const Text('Search')
			),
			drawer: MainDrawer(),
			body: ChangeNotifierProvider(
				create: (context) => RecipeSearchProvider(),
				child: LayoutBuilder(builder: (ctx, constraints) {
					return _componentsList(orientation, constraints);
				}),
			),
		);
	}
}