import './recipe_complexity.dart';
import './technical_difficulty.dart';
import './recipe_entry.dart';

class EntrySearchCriteria {
	Set<RecipeComplexity>? complexitySet;
	Set<TechnicalDifficulty>? difficultySet;
	Map<String,int>? prepTimeRange;
	Map<String,int>? cookTimeRange;
	Map<String,int>? addiTimeRange;
	Map<String,int>? ratingRange;
  String? servingsText;
  String? nameText;
  String? notesText;
	Set<int>? tagIdSet;

	EntrySearchCriteria();

	bool _isWithinRange(int a, Map<String,int> range) {
		return ((range['from'] == -1) || (a >= range['from']!)) && ((range['to'] == -1) || (a <= range['to']!));
	}

	bool fitsCriteria(RecipeEntry entry) {
		final criterionList = <bool>[];

		if (complexitySet != null) {
			criterionList.add(complexitySet!.contains(entry.complexity));
		}
		if (difficultySet != null) {
			criterionList.add(difficultySet!.contains(entry.difficulty));
		}
		
		if (prepTimeRange != null) {
			criterionList.add(_isWithinRange(entry.prepTimeMins, prepTimeRange!));
		}
		if (cookTimeRange != null) {
			criterionList.add(_isWithinRange(entry.cookTimeMins, cookTimeRange!));
		}
		if (addiTimeRange != null) {
			criterionList.add(_isWithinRange(entry.addiTimeMins, addiTimeRange!));
		}
		if (ratingRange != null) {
			criterionList.add(_isWithinRange(entry.rating.round(), ratingRange!));
		}

		if (servingsText != null) {
			criterionList.add(entry.servings.contains(RegExp(servingsText!, caseSensitive: false)));
		}
		if (nameText != null) {
			criterionList.add(entry.name.contains(RegExp(nameText!, caseSensitive: false)));
		}
		if (notesText != null) {
			criterionList.add(entry.notes.contains(RegExp(notesText!, caseSensitive: false)));
		}

		if (tagIdSet != null) {
			criterionList.add(tagIdSet!.intersection(entry.tagIds).isNotEmpty);
		}

		if (criterionList.isEmpty) return false;

		return !criterionList.contains(false);
	}
}