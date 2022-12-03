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
    'rating': false,
		'name': false,
    'notes': false,
		'tagIds': false,
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
	final Map<String, int> _ratingRange = {
		'from': -1,
		'to': -1,
	};
	String _servingText = '';
	String _nameText = '';
  String _notesText = '';
	final Set<int> _tagIds = {};

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
		if (_enabledSearches['rating']!) {
			atLeastOneEnabled = true;
			searchPayload.ratingRange = _ratingRange;
		}

		if (_enabledSearches['servings']!) {
			atLeastOneEnabled = true;
			searchPayload.servingsText = _servingText;
		}
		if (_enabledSearches['name']!) {
			atLeastOneEnabled = true;
			searchPayload.nameText = _nameText;
		}
		if (_enabledSearches['notes']!) {
			atLeastOneEnabled = true;
			searchPayload.notesText = _notesText;
		}

		if (_enabledSearches['tagIds']!) {
			atLeastOneEnabled = true;
			searchPayload.tagIdSet = _tagIds;
		}

		return atLeastOneEnabled ? searchPayload : null;
	}

	void toggleSearch(String searchName, bool newVal) {
		_enabledSearches[searchName] = newVal;
	}

	Set<Enum>? getEnumSearch(String searchName) {
		switch (searchName) {
			case 'complexity':
				return (_enabledSearches['complexity']! && _complexitySearch.isNotEmpty) ? _complexitySearch : null;
			case 'difficulty':
				return (_enabledSearches['difficulty']! && _difficultySearch.isNotEmpty) ? _difficultySearch : null;
			default:
				return null;
		}
	}

  String? getSearchText(String searchName) {
    if (! _enabledSearches[searchName]! ) return null;

    String? strToReturn;

    switch (searchName) {
      case 'servings':
        strToReturn = _servingText;
        break;
      case 'name':
        strToReturn = _nameText;
        break;
      case 'notes':
        strToReturn = _notesText;
        break;
    }

    return strToReturn;
  }

	Map<String, int>? getIntRange(String searchName) {
		if (! _enabledSearches[searchName]!) return null;

		Map<String, int>? mapToReturn;
		switch (searchName) {
			case 'prepTime':
				mapToReturn = _prepTimeRange;
				break;
			case 'cookTime':
				mapToReturn = _cookTimeRange;
				break;
      case 'rating':
        mapToReturn = _ratingRange;
        break;
			default:
				return null;
		}

		if (mapToReturn['from'] == -1 && mapToReturn['to'] == -1) return null;
		return mapToReturn;
	}

	Set<int>? getTagIdSet() {
		if (! _enabledSearches['tagIds']!) return null;

		final toReturn = <int>{};
		toReturn.addAll(_tagIds);

		return toReturn;
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
			case 'rating':
				mapToModify = _ratingRange;
				break;
			default:
				break;
		}

		if (mapToModify == null) return;

		mapToModify['from'] = inputIntRange['from']!;
		mapToModify['to'] = inputIntRange['to']!;
	}

  void setSearchText(String searchName, String inputSearchText) {
    switch (searchName) {
      case 'servings':
        _servingText = inputSearchText;
        break;
      case 'name':
        _nameText = inputSearchText;
        break;
      case 'notes':
        _notesText = inputSearchText;
        break;
    }
  }

	void setTagIdSet(Set<int> inputTagSet) {
		_tagIds.clear();
		_tagIds.addAll(inputTagSet);
	}

	void notifySearchResults() {
		notifyListeners();
	}
}