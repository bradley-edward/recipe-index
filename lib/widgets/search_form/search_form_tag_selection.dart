import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/recipe_tag_list.dart';
import '../../providers/recipe_search_provider.dart';
import '../tags_edit/display_tag_list.dart';

class SearchFormTagSelection extends StatefulWidget {

	const SearchFormTagSelection({
		Key? key,
	}) : super(key: key);

	@override
	State<SearchFormTagSelection> createState() => _SearchFormTagSelectionState();
}

class _SearchFormTagSelectionState extends State<SearchFormTagSelection> {
	final Set<int> _selectedTags = {};

	@override
	Widget build(BuildContext context) {
		final fetchedTags = Provider.of<RecipeTagList>(context).tagList;
		final recipeSearchProvider = Provider.of<RecipeSearchProvider>(context, listen: false);
		final currentValues = recipeSearchProvider.getTagIdSet();
		final cvIsNotNull = currentValues != null;

		if (cvIsNotNull) {
			_selectedTags.clear();
			_selectedTags.addAll(currentValues);
		}

		void _selectTag(int id) {
			setState(() {
				if (_selectedTags.contains(id)) {
					_selectedTags.remove(id);
				} else {
					_selectedTags.add(id);
				}
			});
			recipeSearchProvider.setTagIdSet(_selectedTags);
		}

		void _longPressSelectTag(int id) {
			setState(() {
				if (! _selectedTags.contains(id)) {
					_selectedTags.add(id);
				}
			});
			recipeSearchProvider.setTagIdSet(_selectedTags);
		}

		return ExpansionTile(
			title: const Text('Tags'),
			initiallyExpanded: cvIsNotNull,
			onExpansionChanged: (isExpanded) {
				recipeSearchProvider.toggleSearch('tagIds', isExpanded);
			},
			children: [
				Container(
					height: 200,
					child: SingleChildScrollView(
						child: DisplayTagList(
							tagList: fetchedTags,
							isInEditMode: true,
							selectTagFn: _selectTag,
							longPressSelectTagFn: _longPressSelectTag,
							selectedTags: _selectedTags
						),
					),
				),
			],
		);
	}
}