import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/recipe_tag.dart';
import '../../providers/recipe_tag_list.dart';
import '../widgets/main_drawer.dart';
import '../widgets/tags_edit/display_tag_list.dart';
import '../widgets/tags_edit/tag_edit_alert_dialog.dart';
import '../widgets/tags_edit/merge_two_tags_alert_dialog.dart';
import '../widgets/tags_edit/delete_tags_alert_dialog.dart';

class TagsEditScreen extends StatefulWidget {
	const TagsEditScreen({ Key? key }) : super(key: key);

	static const routeName = '/tags-edit';

	@override
	State<TagsEditScreen> createState() => _TagsEditScreenState();
}

class _TagsEditScreenState extends State<TagsEditScreen> {
	Future<Object>? _tagsFuture;
	var _isInit = true;
	var _isInEditMode = false;
	final Set<int> _selectedTags = {};
	final _searchTEC = TextEditingController();

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

	Future<void> _mergeTwoTagsAlertDialog(BuildContext context, Set<int> twoTagIds) async {
		final tagListProvider = Provider.of<RecipeTagList>(context, listen: false);
		final twoTags = tagListProvider.findByIdSet(twoTagIds);

		final bool? isMergeRTL = await showDialog(
			context: context,
			builder: (BuildContext ctx) {
				return MergeTwoTagsAlertDialog(tag1: twoTags[0], tag2: twoTags[1]);
			}
		);

		if (isMergeRTL == null) return;

		var tagIdAbsorber = twoTags[0].id!, tagIdAbsorbed = twoTags[1].id!;

		if (! isMergeRTL) {
			tagIdAbsorber = twoTags[1].id!;
			tagIdAbsorbed = twoTags[0].id!;
		}

		final didMergeWork = tagListProvider.mergeTwoTags(tagIdAbsorber, tagIdAbsorbed);

		_selectedTags.remove(tagIdAbsorbed);
	}

	Future<void> _addNewTagAlertDialog() async {
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

	Future<void> _deleteTagsAlertDialog(BuildContext context, Set<int> tagsToDelete) async {
		final tagListProvider = Provider.of<RecipeTagList>(context, listen: false);
		final bool? confirmDeleteTags = await showDialog(
			context: context,
			builder: (BuildContext ctx) {
				return DeleteTagsAlertDialog(tagsToDelete: tagListProvider.findByIdSet(tagsToDelete));
			}
		);
		
		if (confirmDeleteTags == null) return;
		if (! confirmDeleteTags) return;

		await tagListProvider.deleteMultipleTags(tagsToDelete);

		_selectedTags.clear();
	}

	@override
	void didChangeDependencies() {
		super.didChangeDependencies();
		if (_isInit) {
			_tagsFuture = _obtainTagsFuture();
			_isInit = false;
		}
	}

	@override
	void dispose() {
		_searchTEC.dispose();

		super.dispose();
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
					if (_isInEditMode) ...[
						if (_selectedTags.length == 2) IconButton(
							onPressed: () {
								_mergeTwoTagsAlertDialog(context, _selectedTags);
							},
							icon: const Icon( Icons.merge ),
						),
						if (_selectedTags.isNotEmpty) IconButton(
							onPressed: () {
								_deleteTagsAlertDialog(context, Set.from(_selectedTags));
							},
							icon: const Icon(Icons.delete),
						),
					],
					if (! _isInEditMode) IconButton(
						onPressed: () {
							setState(() {
								_isInEditMode = true;
							});
						},
						icon: const Icon(Icons.edit),
					),
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
									final searchString = _searchTEC.text;
									final List<RecipeTag> fetchedTags = searchString.isNotEmpty ? tagCollection.search(searchString) : tagCollection.tagList;
									final tagsCount = fetchedTags.length;

									if (tagsCount <= 0 && searchString.isEmpty) return ch!;

									return Container(
										width: double.infinity,
										height: 500,
										padding: const EdgeInsets.all(5),
										child: Column(
											children: <Widget>[
												Container(
													width: 320,
													child: Row(
														crossAxisAlignment: CrossAxisAlignment.end,
														children: [
															Expanded(
																child: TextField(
																	controller: _searchTEC,
																),
															),
															const SizedBox(width: 20),
															ElevatedButton.icon(
																label: const Text('Search'),
																onPressed: () {
																	setState(() {});
																},
																icon: const Icon(Icons.search),
															),
														],
													),
												),
												const SizedBox(height: 5),
												if (tagsCount <= 0) const Text('No tags match your search.'),
												if (tagsCount > 0) DisplayTagList(
													tagList: fetchedTags,
													isInEditMode: _isInEditMode,
													selectTagFn: _selectTag,
													longPressSelectTagFn: _longPressSelectTag,
													selectedTags: _selectedTags,
												),
											],
										),
									);
								}
							);
						}
					}
				}
			),
			floatingActionButton: FloatingActionButton(
				heroTag: 'addNew',
				child: const Icon(Icons.add),
				onPressed: () {
					_addNewTagAlertDialog();
				},
			),
			floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
		);
	}
}