import 'package:flutter/material.dart';

import '../models/recipe_entry.dart';
import '../models/entry_image.dart';
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
			images: entry.images,
		);
		_entries.add(newEntry);
		notifyListeners();
		await DBHelper.insert('recipes', {
			'id': newEntry.id!,
			'entryId': newEntry.entryId,
			'name': newEntry.name,
		});

		if (entry.images.isEmpty) {
			return;
		}

		List<Map<String, Object>> imagesData = [];
		for (var i = 0, len = entry.images.length; i < len; i++) {
			var currImage = entry.images[i];
			imagesData.add({
				'id': UniqueKey().toString(),
				'listIndex': i,
				'imageType': currImage.imageType.index,
				'imageLocation': currImage.imageLocation,
				'ownerId': newEntry.id!,
			});
		}
		await DBHelper.insertMany('images', imagesData);
	}

	Future<void> updateEntry(String id, RecipeEntry newEntry) async {
		final entryIndex = _entries.indexWhere((entry) => entry.id == id);
		if (entryIndex >= 0) {
			_entries[entryIndex] = newEntry;
			notifyListeners();
			await DBHelper.update('recipes', {
				'id': newEntry.id!,
				'entryId': newEntry.entryId,
				'name': newEntry.name,
			});
		}
	}

	Future<void> fetchAndSetRecipes() async {
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
				images: entryImageData.map((image) => EntryImage(
					id: image['id'],
					imageLocation: image['imageLocation'],
					imageType: ImageType.values[image['imageType']],
				)).toList(),
			);
		}).toList();
		notifyListeners();
	}
}