import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main_drawer.dart';
import '../../models/recipe_tag.dart';
import '../../providers/recipe_tag_list.dart';
import './display_tag_list.dart';
import './tag_edit_alert_dialog.dart';

class TagsEditScaffold extends StatefulWidget {
	const TagsEditScaffold({ Key? key }) : super(key: key);

	@override
	State<TagsEditScaffold> createState() => _TagsEditScaffoldState();
}

class _TagsEditScaffoldState extends State<TagsEditScaffold> {
	Future<Object>? _tagsFuture;
	var _isInit = false;
	var _isInEditMode = false;
	final Set<int> _selectedTags = {};

	Future<Object>? _obtainTagsFuture() {
		return Provider.of<RecipeTagList>(context).fetchAndSetTags();
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

			if (! _isInEditMode) {
				_isInEditMode = true;
			}
		});
	}

	void _addNewTagAlertDialog() async {
		final String? confirmNewTag = await showDialog(
			context: context,
			builder: (BuildContext ctx) {
				return const TagEditAlertDialog();
			}
		);
		
		if (confirmNewTag == null) return;

		final String strippedNewTag = confirmNewTag.trim();

		if (strippedNewTag.isEmpty) return;

		await Provider.of<RecipeTagList>(context, listen: false).addTag(RecipeTag(name: strippedNewTag));
	}
	
	@override
	void didChangeDependencies() {
		super.didChangeDependencies();
		if (! _isInit) {
			_tagsFuture = _obtainTagsFuture();
			_isInit = true;
		}
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				leading: _isInEditMode
				? IconButton(onPressed: () {
					setState(() {
						_isInEditMode = false;
					});
				}, icon: const Icon(Icons.arrow_back))
				: null,
				title: const Text('Tags Edit'),
				actions: [
					if (_selectedTags.length == 2) IconButton(
						onPressed: () {},
						icon: const Icon( Icons.merge ),
					),
					if (_selectedTags.isNotEmpty) IconButton(
						onPressed: () {},
						icon: const Icon(Icons.delete),
					)
				],
			),
			drawer: _isInEditMode ? null : MainDrawer(),
			body: FutureBuilder<Object>(
				future: _tagsFuture,
				builder: (context, dataSnapshot) {
					if (dataSnapshot.connectionState == ConnectionState.waiting) {
						return const Center(child: CircularProgressIndicator());
					} else {
						if (dataSnapshot.hasError) {
							return const Center(child: Text('An error occurred!'),);
						} else {
							return Consumer<RecipeTagList>(
								child: const Center(
									child: Text('Got no Tags yet; start adding some!'),
								),
								builder: (ctx, tagCollection, ch) {
									final List<RecipeTag> fetchedTags = tagCollection.tagList;
									final tagsCount = fetchedTags.length;

									if (tagsCount <= 0) {
										return ch!;
									}

									return Container(
										width: double.infinity,
										height: 500,
										child: DisplayTagList(
											tagList: fetchedTags,
											isInEditMode: _isInEditMode,
											selectTagFn: _selectTag,
											longPressSelectTagFn: _longPressSelectTag,
											selectedTags: _selectedTags,
										),
									);
								}
							);
						}
					}
				}
			),
			floatingActionButton: Row(
				mainAxisAlignment: MainAxisAlignment.center,
				children: <Widget>[
					FloatingActionButton(
						heroTag: 'addNew',
						child: const Icon(Icons.add),
						onPressed: () {
							_addNewTagAlertDialog();
						},
					),
					const SizedBox(width: 20),
					FloatingActionButton(
						heroTag: 'addDummyData',
						child: const Icon(Icons.add_box),
						onPressed: () async {
							await Provider.of<RecipeTagList>(context, listen: false).populateWithDummyData();
						},
					),
				],
			),
			floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
		);
	}
}