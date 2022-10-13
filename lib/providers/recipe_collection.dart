import 'package:flutter/material.dart';

import '../models/entry_search_criteria.dart';
import '../models/dummy_data.dart';
import '../models/recipe_entry.dart';
import '../models/entry_image.dart';
import '../models/recipe_complexity.dart';
import '../models/technical_difficulty.dart';
import '../helpers/db_helper.dart';

class RecipeCollection with ChangeNotifier {
	final List<RecipeEntry> _entries = [];

	List<RecipeEntry> get entries {
		return [..._entries];
	}

	int _displayIdCompare(String displayId1, String displayId2) {
		return displayId1.toLowerCase().compareTo(displayId2.toLowerCase());
	}

	void _insertionSortShuffle(int idx) {
		if (_entries.length < 2) return;

		if (idx == _entries.length - 1) {
			return _entriesInsertionSortOnePass();
		}

		var goRight = false;
		var rightCompare = _displayIdCompare(_entries[idx].displayId, _entries[idx + 1].displayId);
		if (idx == 0) {
			if (rightCompare < 0) {
				return;
			}
			goRight = true;	// The tag is bigger than its right neighbor. Must shift it right.
		} else {
			var leftCompare = _displayIdCompare(_entries[idx - 1].displayId, _entries[idx].displayId);
			if (leftCompare < 0 && rightCompare < 0) return;	// The tag is already in its appropriate location.

			if (leftCompare > 0 && rightCompare < 0) {
				// The tag is smaller than both its neighbors. Must shift it left.
				goRight = false;
			} else if (leftCompare < 0 && rightCompare > 0) {
				// The tag is bigger than both its neighbors. Must shift it right.
				goRight = true;
			}
		}

		return _entriesInsertionSortOnePass(idx, goRight);
	}

	void _entriesInsertionSortOnePass([int? idxToShuffle, bool shiftRight = false]) {
		final tagLen = _entries.length;
		if (tagLen < 2) return;

		idxToShuffle ??= shiftRight ? 0 : tagLen - 1;
		RecipeEntry currEntry = _entries[idxToShuffle];

		int j = idxToShuffle - (shiftRight ? -1 : 1);
		if (shiftRight) {
			while (j < tagLen && _displayIdCompare(currEntry.displayId, _entries[j].displayId) > 0) {
				_entries[j-1] = _entries[j];
				j++;
			}
			_entries[j-1] = currEntry;
		} else {
			while (j >= 0 && _displayIdCompare(_entries[j].displayId, currEntry.displayId) > 0) {
				_entries[j+1] = _entries[j];
				j--;
			}
			_entries[j+1] = currEntry;
		}
	}

	List<RecipeEntry> searchForEntries(EntrySearchCriteria searchCriteria) {
		final foundEntries = _entries.where((entry) => searchCriteria.fitsCriteria(entry)).toList();
		return foundEntries;
	}

	RecipeEntry? findById(int id) {
		final entryIdx = _entries.indexWhere((entry) => entry.id == id);
		if (entryIdx == -1) return null;
		return _entries[entryIdx];
	}

	Future<int> addEntry(RecipeEntry entry) async {
		final entryId = await DBHelper.insert('recipes', {
			'name': entry.name,
			'displayId': entry.displayId,
			'complexity': entry.complexity!.index,
			'difficulty': entry.difficulty!.index,
			'prepTime': entry.prepTimeMins,
			'cookingTime': entry.cookTimeMins,
			'servings': entry.servings,
		});

		if (entry.tagIds.isNotEmpty) {
			final mnRecipesTagsRecords = entry.tagIds.toList(growable: false).map((tagId) {
				return {
					'recipeId': entryId,
					'tagId': tagId
				};
			}).toList(growable: false);

			await DBHelper.insertMany('mn_recipes_tags', mnRecipesTagsRecords);
		}

		final newEntry = RecipeEntry(
			id: entryId,
			name: entry.name,
			displayId: entry.displayId,
			complexity: entry.complexity,
			difficulty: entry.difficulty,
			prepTimeMins: entry.prepTimeMins,
			cookTimeMins: entry.cookTimeMins,
			servings: entry.servings,
			images: entry.images,
			tagIds: entry.tagIds,
		);
		
		_entries.add(newEntry);
		_entriesInsertionSortOnePass();
		notifyListeners();

		if (newEntry.images.isEmpty) {
			return entryId;
		}

		List<Map<String, Object>> imagesData = [];
		for (var i = 0, len = newEntry.images.length; i < len; i++) {
			var currImage = newEntry.images[i];
			imagesData.add({
				'listIndex': i,
				'imageType': currImage.imageType.index,
				'imageLocation': currImage.imageLocation,
				'ownerId': newEntry.id!,
			});
		}
		final insertedImageIds = await DBHelper.insertMany('images', imagesData);
		for (var i = 0, len = newEntry.images.length; i < len; i++) {
			newEntry.images[i].id = insertedImageIds[i] as int;
		}

		return entryId;
	}

	Future<void> _updateEntryImages(int ownerId, List<EntryImage> imageList, Set<int> deleteIds) async {
		List<Map<String,Object>> recordsToInsert = [];
		List<Map<String,dynamic>> recordsToUpdate = [];

		List<int> insertedImagesIndices = [];
		
		for (var i = 0, len = imageList.length; i < len; i++) {
			var currImage = imageList[i];
			final recordItem = {
				'listIndex': i,
				'imageType': currImage.imageType.index,
				'imageLocation': currImage.imageLocation,
				'ownerId': ownerId,
			};
			if (currImage.id != null) {
				recordItem['id'] = currImage.id!;
				recordsToUpdate.add(recordItem);
			} else {
				recordsToInsert.add(recordItem);
				insertedImagesIndices.add(i);
			}
		}

		final batchResults = await DBHelper.batchStmts('images', recordsToInsert, recordsToUpdate, deleteIds,);
		if (recordsToInsert.isNotEmpty) {
			for (var i = 0, len = insertedImagesIndices.length; i < len; i++) {
				final imageIdx = insertedImagesIndices[i];
				imageList[imageIdx].id ??= batchResults['insertResults']![i] as int;
			}
		}
	}

	Future<void> _updateEntryTags(int ownerId, Set<int> newTagSet, Set<int> oldTagSet) async {
		final tagsToAdd = newTagSet.difference(oldTagSet);
		final tagsToRemove = oldTagSet.difference(newTagSet);

		final recordsToInsert = tagsToAdd.toList(growable: false).map((tagId) => {
			'recipeId': ownerId,
			'tagId': tagId
		}).toList();
		final recordsToDelete = tagsToRemove.toList(growable: false).map((tagId) => {
			'recipeId': ownerId,
			'tagId': tagId
		}).toList();

		await DBHelper.batchModifyMNRecipesTags(recordsToInsert, recordsToDelete,);
	}

	Future<void> updateEntry(int id, RecipeEntry newEntry, Set<int> imageIdsToRemove, Set<int> tagsOldSet,) async {
		final entryIndex = _entries.indexWhere((entry) => entry.id == id);
		if (entryIndex == -1) {
			return;
		}

		// We should perhaps deal with deleting image files from the file-system, depending on how the images table is being updated.
		newEntry.images.removeWhere((image) => imageIdsToRemove.contains(image.id));
		_entries[entryIndex] = newEntry;
		_insertionSortShuffle(entryIndex);
		notifyListeners();

		await DBHelper.update('recipes', {
			'id': newEntry.id!,
			'name': newEntry.name,
			'displayId': newEntry.displayId,
			'complexity': newEntry.complexity!.index,
			'difficulty': newEntry.difficulty!.index,
			'prepTime': newEntry.prepTimeMins,
			'cookingTime': newEntry.cookTimeMins,
			'servings': newEntry.servings,
		});

		await _updateEntryTags(newEntry.id!, newEntry.tagIds, tagsOldSet);

		await _updateEntryImages(newEntry.id!, newEntry.images, imageIdsToRemove,);
	}

	Future<void> deleteEntries(Set<int> idSet) async {
		final List<RecipeEntry> entriesToDelete = [];
		for (final entryId in idSet) {
			final idIdx = _entries.indexWhere((entry) => entryId == entry.id);
			if (idIdx != -1) {
				entriesToDelete.add(_entries.removeAt(idIdx));
			}
		}

		notifyListeners();

		await DBHelper.deleteRecipesById(
			entriesToDelete.map((e) => e.id!).toSet()
		);
	}

	Future<void> deleteEntry(int id) async {
		final entryIndex = _entries.indexWhere((entry) => entry.id == id);
		if (entryIndex == -1) {
			return;
		}

		final entryToDelete = _entries.removeAt(entryIndex);
		notifyListeners();

		await DBHelper.deleteRecipesById({entryToDelete.id!});
	}

	Future<bool> fetchAndSetRecipes() async {
		final dataList = await DBHelper.getData('recipes');
		final imageList = await DBHelper.getData('images');
		final mnRecipeTags = await DBHelper.getData('mn_recipes_tags');

		_entries.clear();
		for (Map<String, dynamic> entry in dataList) {
			final entryImageData = imageList.where(
				(image) => image['ownerId'] == entry['id']
			).toList()..sort(
				(a, b) => a['listIndex'] - b['listIndex']
			);

			final tagsSet = mnRecipeTags.where((e) => e['recipeId'] == entry['id']).map((e) => e['tagId'] as int).toSet();

			_entries.add(
					RecipeEntry(
					id: entry['id'],
					name: entry['name'],
					displayId: entry['displayId'],
					complexity: RecipeComplexity.values[entry['complexity']],
					difficulty: TechnicalDifficulty.values[entry['difficulty']],
					prepTimeMins: entry['prepTime'],
					cookTimeMins: entry['cookingTime'],
					servings: entry['servings'],
					images: entryImageData.map((image) => EntryImage(
						id: image['id'],
						imageLocation: image['imageLocation'],
						imageType: ImageType.values[image['imageType']],
					)).toList(),
					tagIds: tagsSet,
				)
			);
			_entriesInsertionSortOnePass();
		}
		notifyListeners();
		return true;
	}

	Future<void> populateWithDummyData() async {
		for (final entryInfo in dummyData) {
			await addEntry(entryInfo);
		}
	}
}