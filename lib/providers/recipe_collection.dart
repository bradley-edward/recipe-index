import 'package:flutter/material.dart';

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

	RecipeEntry findById(String id) {
		return _entries.firstWhere((entry) => entry.id == id);
	}

	Future<void> addEntry(RecipeEntry entry) async {
		var newEntry = RecipeEntry(
			id: UniqueKey().toString(),
			entryId: entry.entryId,
			name: entry.name,
			complexity: entry.complexity,
			difficulty: entry.difficulty,
			images: entry.images,
		);
		_entries.add(newEntry);
		notifyListeners();
		await DBHelper.insert('recipes', {
			'id': newEntry.id!,
			'entryId': newEntry.entryId,
			'name': newEntry.name,
			'complexity': newEntry.complexity!.index,
			'difficulty': newEntry.difficulty!.index,
		});

		if (entry.images.isEmpty) {
			return;
		}

		List<Map<String, Object>> imagesData = [];
		for (var i = 0, len = entry.images.length; i < len; i++) {
			var currImage = entry.images[i];
			currImage.id = UniqueKey().toString();
			imagesData.add({
				'id': currImage.id!,
				'listIndex': i,
				'imageType': currImage.imageType.index,
				'imageLocation': currImage.imageLocation,
				'ownerId': newEntry.id!,
			});
		}
		await DBHelper.insertMany('images', imagesData);
	}

	Future<void> _updateEntryImages(String ownerId, List<EntryImage> imageList, Set<String> deleteIds) async {
		List<Map<String,dynamic>> recordsToInsert = [];
		List<Map<String,dynamic>> recordsToUpdate = [];
		
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
				currImage.id = UniqueKey().toString();
				recordItem['id'] = currImage.id!;
				recordsToInsert.add(recordItem);
			}
		}

		await DBHelper.batchStmts('images', recordsToInsert, recordsToUpdate, deleteIds,);
	}

	Future<void> updateEntry(String id, RecipeEntry newEntry, Set<String> imageIdsToRemove,) async {
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
			'entryId': newEntry.entryId,
			'name': newEntry.name,
			'complexity': newEntry.complexity!.index,
			'difficulty': newEntry.difficulty!.index,
		});

		await _updateEntryImages(newEntry.id!, newEntry.images, imageIdsToRemove,);
	}

	Future<void> deleteEntries(Set<String> idSet) async {
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

	Future<void> deleteEntry(String id) async {
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
				entryId: entry['entryId'],
				name: entry['name'],
				complexity: RecipeComplexity.values[entry['complexity']],
				difficulty: TechnicalDifficulty.values[entry['difficulty']],
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
}