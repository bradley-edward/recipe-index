import 'package:flutter/material.dart';

import '../models/recipe_entry.dart';
import '../helpers/db_helper.dart';

class RecipeCollection with ChangeNotifier {
	List<RecipeEntry> _entries = [
		/*
		RecipeEntry(id: 'e1', entryId: '0001', name: 'Glazed Carrots'),
		RecipeEntry(id: 'e2', entryId: '0002', name: 'Brown Sugar Mustard Glazed Ham'),
		RecipeEntry(id: 'e3', entryId: '0004', name: 'Philly Cheesesteak'),
		RecipeEntry(id: 'e4', entryId: '0006', name: 'Soy-Balsamic Glazed Sea Scallops'),
		*/
	];

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
		);
		_entries.add(newEntry);
		notifyListeners();
		DBHelper.insert('recipes', {
			'id': newEntry.id!,
			'entryId': newEntry.entryId,
			'name': newEntry.name,
		});
	}

	Future<void> updateEntry(String id, RecipeEntry newEntry) async {
		final entryIndex = _entries.indexWhere((entry) => entry.id == id);
		if (entryIndex >= 0) {
			_entries[entryIndex] = newEntry;
			notifyListeners();
			DBHelper.insert('recipes', {
				'id': newEntry.id!,
				'entryId': newEntry.entryId,
				'name': newEntry.name,
			});
		}
	}

	Future<void> fetchAndSetRecipes() async {
		final dataList = await DBHelper.getData('recipes');
		_entries = dataList.map((item) => RecipeEntry(
			id: item['id'],
			entryId: item['entryId'],
			name: item['name'],
		)).toList();
		notifyListeners();
	}
}