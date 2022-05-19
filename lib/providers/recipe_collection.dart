import 'package:flutter/material.dart';

import '../models/entry_search_criteria.dart';
import '../models/dummy_data.dart';
import '../models/recipe_entry.dart';
import '../models/entry_image.dart';
import '../models/recipe_complexity.dart';
import '../models/technical_difficulty.dart';
import '../helpers/db_helper.dart';

class RecipeCollection with ChangeNotifier {
	List<RecipeEntry> _entries = [];

	List<RecipeEntry> get entries {
		return [..._entries];
	}

	List<RecipeEntry> searchForEntries(EntrySearchCriteria searchCriteria) {
		final foundEntries = _entries.where((entry) => searchCriteria.fitsCriteria(entry)).toList();
		return foundEntries;
	}

	RecipeEntry findById(int id) {
		return _entries.firstWhere((entry) => entry.id == id);
	}

	Future<void> addEntry(RecipeEntry entry) async {
		final entryId = await DBHelper.insert('recipes', {
			'name': entry.name,
			'complexity': entry.complexity!.index,
			'difficulty': entry.difficulty!.index,
			'prepTime': entry.prepTimeMins,
			'cookingTime': entry.cookTimeMins,
			'servings': entry.servings,
		});
		final newEntry = RecipeEntry(
			id: entryId,
			name: entry.name,
			complexity: entry.complexity,
			difficulty: entry.difficulty,
			prepTimeMins: entry.prepTimeMins,
			cookTimeMins: entry.cookTimeMins,
			servings: entry.servings,
			images: entry.images,
		);
		
		_entries.add(newEntry);
		notifyListeners();

		if (newEntry.images.isEmpty) {
			return;
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

	Future<void> updateEntry(int id, RecipeEntry newEntry, Set<int> imageIdsToRemove,) async {
		final entryIndex = _entries.indexWhere((entry) => entry.id == id);
		if (entryIndex == -1) {
			return;
		}

		// We should perhaps deal with deleting image files from the file-system, depending on how the images table is being updated.
		newEntry.images.removeWhere((image) => imageIdsToRemove.contains(image.id));
		_entries[entryIndex] = newEntry;
		notifyListeners();

		await DBHelper.update('recipes', {
			'id': newEntry.id!,
			'name': newEntry.name,
			'complexity': newEntry.complexity!.index,
			'difficulty': newEntry.difficulty!.index,
			'prepTime': newEntry.prepTimeMins,
			'cookingTime': newEntry.cookTimeMins,
			'servings': newEntry.servings,
		});

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

		// Delete the images associated with this entry, if any.
		for (final entryToDelete in entriesToDelete) {
			if (entryToDelete.images.isNotEmpty) {
				await DBHelper.deleteWhere('images', '"ownerId" = ?', [entryToDelete.id!]);
			}
			await DBHelper.deleteById('recipes', entryToDelete.id!);
		}
	}

	Future<void> deleteEntry(int id) async {
		final entryIndex = _entries.indexWhere((entry) => entry.id == id);
		if (entryIndex == -1) {
			return;
		}

		final entryToDelete = _entries.removeAt(entryIndex);
		notifyListeners();

		// Delete the images associated with this entry, if any.
		if (entryToDelete.images.isNotEmpty) {
			await DBHelper.deleteWhere('images', '"ownerId" = ?', [entryToDelete.id!]);
		}
		await DBHelper.deleteById('recipes', entryToDelete.id!);
	}

	Future<bool> fetchAndSetRecipes() async {
		final dataList = await DBHelper.getData('recipes');
		final imageList = await DBHelper.getData('images');

		_entries = dataList.map((entry) {
			final entryImageData = imageList.where(
				(image) => image['ownerId'] == entry['id']
			).toList()..sort(
				(a, b) => a['listIndex'] - b['listIndex']
			);

			return RecipeEntry(
				id: entry['id'],
				name: entry['name'],
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
			);
		}).toList();
		notifyListeners();
		return true;
	}

	Future<void> populateWithDummyData() async {
		for (final entryInfo in dummyData) {
			await addEntry(entryInfo);
		}
	}
}