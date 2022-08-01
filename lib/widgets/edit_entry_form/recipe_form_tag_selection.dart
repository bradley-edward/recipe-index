import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/recipe_tag.dart';
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
	String _searchString = '';
	final _searchTEC = TextEditingController();
	
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

	void _quickAdd(RecipeTagList rtlProvider, TextEditingController tec) async {
		final newTagName = tec.text;

		if (rtlProvider.search(newTagName).isNotEmpty) return;

		final String strippedNewTag = newTagName.trim();

		if (strippedNewTag.isEmpty) return;

		await rtlProvider.addTag(RecipeTag(name: strippedNewTag));
	}

	@override
	Widget build(BuildContext context) {
		final tagListProvider = Provider.of<RecipeTagList>(context);
		final fetchedTags = _searchString.isNotEmpty ? tagListProvider.search(_searchString) : tagListProvider.tagList;

		return Container(
			height: 400,
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
					Container(
						width: 320,
						child: Row(
							crossAxisAlignment: CrossAxisAlignment.end,
							children: [
								ElevatedButton.icon(
									label: const Text('Add'),
									onPressed: () {
										_quickAdd(tagListProvider, _searchTEC);
									},
									icon: const Icon(Icons.add),
								),
								const SizedBox(width: 20),
								Expanded(
									child: TextField(
										controller: _searchTEC,
									),
								),
								const SizedBox(width: 20),
								ElevatedButton.icon(
									label: const Text('Search'),
									onPressed: () {
										setState(() {
											_searchString = _searchTEC.text;
										});
									},
									icon: const Icon(Icons.search),
								),
							],
						),
					),
					if (_searchString.isNotEmpty && fetchedTags.isEmpty) const Center(
						child: Text('No tags match your search.'),
					),
					if (fetchedTags.isNotEmpty) DisplayTagList(
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