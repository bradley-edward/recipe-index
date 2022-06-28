import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/tags_edit/tags_edit_scaffold.dart';
import '../providers/recipe_tag_list.dart';

class TagsEditScreen extends StatelessWidget {
	const TagsEditScreen({ Key? key }) : super(key: key);

	static const routeName = '/tags-edit';

	@override
	Widget build(BuildContext context) {
		return ChangeNotifierProvider(
			create: (context) => RecipeTagList(),
			child: const TagsEditScaffold(),
		);
	}
}