import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../models/recipe_complexity.dart';
import '../../models/technical_difficulty.dart';
import '../../models/entry_search_criteria.dart';

class RecipeSearchProvider with ChangeNotifier {
	final _enabledSearches = {
		'complexity': false,
		'difficulty': false,
		'prepTime': false,
		'cookTime': false,
		'servings': false,
	};
	final Set<RecipeComplexity> _complexitySearch = {};
	final Set<TechnicalDifficulty> _difficultySearch = {};
	final Map<String, int> _prepTimeRange = {
		'from': -1,
		'to': -1,
	};
	final Map<String, int> _cookTimeRange = {
		'from': -1,
		'to': -1,
	};
	final Map<String, int> _servingRange = {
		'from': -1,
		'to': -1,
	};

	EntrySearchCriteria? get searchPayload {
		var atLeastOneEnabled = false;
		final searchPayload = EntrySearchCriteria();
		if (_enabledSearches['complexity']! && _complexitySearch.isNotEmpty) {
			atLeastOneEnabled = true;
			searchPayload.complexitySet = _complexitySearch;
		}
		if (_enabledSearches['difficulty']! && _difficultySearch.isNotEmpty) {
			atLeastOneEnabled = true;
			searchPayload.difficultySet = _difficultySearch;
		}

		if (_enabledSearches['prepTime']!) {
			atLeastOneEnabled = true;
			searchPayload.prepTimeRange = _prepTimeRange;
		}
		if (_enabledSearches['cookTime']!) {
			atLeastOneEnabled = true;
			searchPayload.cookTimeRange = _cookTimeRange;
		}
		if (_enabledSearches['servings']!) {
			atLeastOneEnabled = true;
			searchPayload.servingsRange = _servingRange;
		}

		return atLeastOneEnabled ? searchPayload : null;
	}

	void toggleSearch(String searchName, bool newVal) {
		_enabledSearches[searchName] = newVal;
	}

	void setEnumSearch(String searchName, List<Enum> inputEnumList) {
		switch (searchName) {
			case 'complexity':
				_complexitySearch.clear();
				for (final enumItem in inputEnumList) {
					_complexitySearch.add(enumItem as RecipeComplexity);
				}
				break;
			case 'difficulty':
				_difficultySearch.clear();
				for (final enumItem in inputEnumList) {
					_difficultySearch.add(enumItem as TechnicalDifficulty);
				}
				break;
			default:
				break;
		}
	}
	
	void setIntRange(String searchName, Map<String, int> inputIntRange) {
		Map<String, int>? mapToModify;
		switch (searchName) {
			case 'prepTime':
				mapToModify = _prepTimeRange;
				break;
			case 'cookTime':
				mapToModify = _cookTimeRange;
				break;
			case 'servings':
				mapToModify = _servingRange;
				break;
			default:
				break;
		}

		if (mapToModify == null) return;

		mapToModify['from'] = inputIntRange['from']!;
		mapToModify['to'] = inputIntRange['to']!;
	}
}