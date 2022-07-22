import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/recipe_tag_list.dart';
import '../tags_edit/display_tag_list.dart';

class RecipeFormTagSelection extends StatefulWidget {
	final Function onTagSelectionUpdate;

	const RecipeFormTagSelection({
		Key? key,
		required this.onTagSelectionUpdate,
	}) : super(key: key);

	@override
	State<RecipeFormTagSelection> createState() => _RecipeFormTagSelectionState();
}

class _RecipeFormTagSelectionState extends State<RecipeFormTagSelection> {
	final Set<int> _selectedTags = {};

	void _selectTag(int id) {
		setState(() {
			if (_selectedTags.contains(id)) {
				_selectedTags.remove(id);
			} else {
				_selectedTags.add(id);
			}
		});
		widget.onTagSelectionUpdate(_selectedTags);
	}

	void _longPressSelectTag(int id) {
		setState(() {
			if (! _selectedTags.contains(id)) {
				_selectedTags.add(id);
			}
		});
		widget.onTagSelectionUpdate(_selectedTags);
	}

	@override
	Widget build(BuildContext context) {
		final fetchedTags = Provider.of<RecipeTagList>(context).tagList;

		return Container(
			height: 240,
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
			child: DisplayTagList(
				tagList: fetchedTags,
				isInEditMode: true,
				selectTagFn: _selectTag,
				longPressSelectTagFn: _longPressSelectTag,
				selectedTags: _selectedTags
			),
		);
	}
}