import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/recipe_tag_list.dart';
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

	void _resetToInitialSelection() {
		setState(() {
			_selectedTags.clear();
		});
	}

	void _selectTag(int id) {
		setState(() {
			if (_selectedTags.contains(id)) {
				_selectedTags.remove(id);
			} else {
				_selectedTags.add(id);
			}
		});
	}

	void _longPressSelectTag(int id) {
		setState(() {
			if (! _selectedTags.contains(id)) {
				_selectedTags.add(id);
			}
		});
	}

	@override
	Widget build(BuildContext context) {
		final fetchedTags = Provider.of<RecipeTagList>(context).tagList;

		return Container(
			height: 120,
			width: double.infinity,
			decoration: const BoxDecoration(
				border: Border.symmetric(
					horizontal: BorderSide(
						color: Colors.black54,
						width: 1,
					)
				),
				color: Colors.black12,
			),
			child: Column(
				children: [
					ElevatedButton(
						onPressed: _resetToInitialSelection,
						child: const Text('Reset to Initial Tags'),
					),
					DisplayTagList(
						tagList: fetchedTags,
						isInEditMode: true,
						selectTagFn: _selectTag,
						longPressSelectTagFn: _longPressSelectTag,
						selectedTags: _selectedTags
					),
				],
			),
		);
	}
}