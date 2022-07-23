import 'package:flutter/material.dart';

import '../../models/recipe_tag.dart';

class DisplayTagListReadonly extends StatelessWidget {
	final List<RecipeTag> tagList;

	const DisplayTagListReadonly({
		required this.tagList,
		Key? key
	}) : super(key: key);

	@override
	Widget build(BuildContext context) {
		return SingleChildScrollView(
			child: Wrap(
				spacing: 6.0,
				children: tagList.map((currTag) {
					return Chip(
						avatar: CircleAvatar(
							child: Text(
								currTag.name.substring(0,2),
								style: const TextStyle(
									fontSize: 13,
								),
							),
							foregroundColor: Colors.black,
						),
						label: Text(currTag.name),
						backgroundColor: Colors.white,
						elevation: 2,
						labelStyle: const TextStyle(
							color: Colors.black
						),
					);
				}).toList(),
			),
		);
	}
}