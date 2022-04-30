import 'package:flutter/foundation.dart';
import '../models/recipe_entry.dart';

class RecipeCollection with ChangeNotifier {
	final List<RecipeEntry> _entries = [
		RecipeEntry(id: 'e1', entryId: '0001', name: 'Glazed Carrots'),
		RecipeEntry(id: 'e2', entryId: '0002', name: 'Brown Sugar Mustard Glazed Ham'),
		RecipeEntry(id: 'e3', entryId: '0004', name: 'Philly Cheesesteak'),
		RecipeEntry(id: 'e4', entryId: '0006', name: 'Soy-Balsamic Glazed Sea Scallops'),
	];

	List<RecipeEntry> get entries {
		return [..._entries];
	}

}