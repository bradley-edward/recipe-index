import 'package:flutter/material.dart';

import '../models/recipe_tag.dart';
import '../helpers/db_helper.dart';

class RecipeTagList with ChangeNotifier {
	List<RecipeTag> _tags = [];

	List<RecipeTag> get tagList {
		return [..._tags];
	}

	List<RecipeTag> findByIdSet(Set<int> ids) {
		return _tags.where((tagEntry) => ids.contains(tagEntry.id)).toList();
	}

	RecipeTag? findById(int id) {
		final entryIdx = _tags.indexWhere((entry) => entry.id == id);
		if (entryIdx == -1) return null;
		return _tags[entryIdx];
	}

	List<RecipeTag> search(String inputSearch) {
		final searchRegex = RegExp(RegExp.escape(inputSearch), caseSensitive: false);
		return _tags.where((tagItem) => searchRegex.hasMatch(tagItem.name)).toList();
	}

	bool containsTagWithName(String inputName) {
		return _tags.indexWhere((tag) => tag.name == inputName) != -1;
	}

	Future<bool> mergeTwoTags(int tagIdAbsorber, int tagIdAbsorbed) async {
		// Replace the 'absorbed' tag with the 'absorber' tag, in the MN recipes tags table.
		await DBHelper.mergeTwoTags(tagIdAbsorber, tagIdAbsorbed);

		// Remove the absorbed id tag from the list.
		_tags.removeWhere((element) => element.id == tagIdAbsorbed);
		notifyListeners();

		return true;
	}

	Future<int> addTag(RecipeTag tag) async {
		final tagId = await DBHelper.insert('tags', {
			'name': tag.name,
		});
		final newTag = RecipeTag(
			id: tagId,
			name: tag.name,
		);

		_tags.add(newTag);
		notifyListeners();

		return tagId;
	}

	Future<void> updateTag(int id, String newName) async {
		final tagIndex = _tags.indexWhere((item) => item.id == id);
		if (tagIndex == -1) {
			return;
		}

		final newTag = RecipeTag(id: id, name: newName);

		_tags[tagIndex] = newTag;
		notifyListeners();

		await DBHelper.update('tags', {
			'id': id,
			'name': newName,
		});
	}

	Future<void> deleteTag(int id) async {
		final tagIndex = _tags.indexWhere((item) => item.id == id);
		if (tagIndex == -1) {
			return;
		}

		final tagToDelete = _tags.removeAt(tagIndex);
		notifyListeners();

		await DBHelper.deleteTagsById({tagToDelete.id!});
	}

	Future<void> deleteMultipleTags(Set<int> idSet) async {
		// Make sure all the tags we want to delete are inside the _tags list.
		final idxsDelete = <int>[];
		for (final tagId in idSet.toList()) {
			final tagIdx = _tags.indexWhere((item) => item.id == tagId);
			if (tagIdx == -1) {
				return;
			}

			idxsDelete.add(tagIdx);
		}

		idxsDelete.sort();

		for (final idx in idxsDelete.reversed) {
			_tags.removeAt(idx);
		}

		notifyListeners();

		await DBHelper.deleteTagsById(idSet);
	}

	Future<bool> fetchAndSetTags() async {
		final tagList = await DBHelper.getData('tags');

		_tags = tagList.map((tagItem) => RecipeTag(
			id: tagItem['id'],
			name: tagItem['name'],
		)).toList();

		notifyListeners();
		return true;
	}

	Future<void> populateWithDummyData() async {
		final dummyData = [
			'Chicken',
			'Beef',
			'Carrot',
			'Fish',
			'Cheese',
			'Apple',
			'Ham',
			'Pork',
			'Vegan',
			'Vegetarian',
			'Milk',
			'Banana',
			'Bread'
		];

		for (final tagName in dummyData) {
			await addTag(RecipeTag(name: tagName));
		}
	}
}