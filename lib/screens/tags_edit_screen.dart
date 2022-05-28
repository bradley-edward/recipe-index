import 'package:flutter/material.dart';

import '../widgets/main_drawer.dart';

class TagsEditScreen extends StatelessWidget {
	const TagsEditScreen({ Key? key }) : super(key: key);

	static const routeName = '/tags-edit';

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: const Text('Search')
			),
			drawer: MainDrawer(),
			body: const Center(
				child: Text('The screen to edit the tags is here.'),
			),
		);
	}
}