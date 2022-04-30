import 'package:flutter/material.dart';

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
			body: const Center(
				child: Text('Search'),
			),
		);
	}
}