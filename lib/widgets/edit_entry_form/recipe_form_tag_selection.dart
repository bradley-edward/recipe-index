import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/recipe_tag_list.dart';
import '../tags_edit/display_tag_list.dart';

class RecipeFormTagSelection extends StatefulWidget {
	final Function onTagSelectionUpdate;
	final Set<int> initialSelection;

	const RecipeFormTagSelection({
		Key? key,
		required this.onTagSelectionUpdate,
		required this.initialSelection,
	}) : super(key: key);

	@override
	State<RecipeFormTagSelection> createState() => _RecipeFormTagSelectionState();
}

class _RecipeFormTagSelectionState extends State<RecipeFormTagSelection> {
	final Set<int> _selectedTags = {};
	
	@override
	void initState() {
		super.initState();

		_selectedTags.addAll(widget.initialSelection);
	}

	void _resetToInitialSelection() {
		setState(() {
			_selectedTags.clear();
			_selectedTags.addAll(widget.initialSelection);
		});

		widget.onTagSelectionUpdate(_selectedTags);
	}

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
			height: 320,
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