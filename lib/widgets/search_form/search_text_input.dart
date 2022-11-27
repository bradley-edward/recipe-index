import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/recipe_search_provider.dart';

class SearchTextInput extends StatefulWidget {
	final String titleStr;
	final String searchName;

	const SearchTextInput({
		Key? key,
		required this.titleStr,
		required this.searchName,
	}) : super(key: key);

	@override
	State<SearchTextInput> createState() => _SearchTextInputState();
}

class _SearchTextInputState extends State<SearchTextInput> {
  final _searchTEC = TextEditingController();

	@override
	Widget build(BuildContext context) {
		final appTheme = Theme.of(context);
		final recipeSearchProvider = Provider.of<RecipeSearchProvider>(context, listen: false);
		final currentValue = recipeSearchProvider.getSearchText(widget.searchName);
		final cvIsNotNull = currentValue != null;

		if (cvIsNotNull) {
			_searchTEC.text = currentValue;
		}

		return ExpansionTile(
			title: Text(widget.titleStr, style: appTheme.textTheme.titleMedium,),
			initiallyExpanded: cvIsNotNull,
			onExpansionChanged: (isExpanded) {
				recipeSearchProvider.toggleSearch(widget.searchName, isExpanded);
			},
			children: [
				ListTile(
          title: TextField(
            controller: _searchTEC,
            onChanged: (_) {
              recipeSearchProvider.setSearchText(widget.searchName, _searchTEC.text);
            },
          ),
				),
			],
		);
	}
}