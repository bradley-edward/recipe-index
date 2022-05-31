import './recipe_complexity.dart';
import './technical_difficulty.dart';
import './recipe_entry.dart';

class EntrySearchCriteria {
	Set<RecipeComplexity>? complexitySet;
	Set<TechnicalDifficulty>? difficultySet;
	Map<String,int>? prepTimeRange;
	Map<String,int>? cookTimeRange;
	Map<String,int>? servingsRange;

	EntrySearchCriteria();

	bool _isWithinRange(int a, Map<String,int> range) {
		return ((range['from'] == -1) || (a >= range['from']!)) && ((range['to'] == -1) || (a <= range['to']!));
	}

	bool fitsCriteria(RecipeEntry entry) {
		var inComplexity = false;
		var inDifficulty = false;
		var inPrepTime = false;
		var inCookTime = false;
		var inServings = false;

		final criterionList = <bool>[];

		if (complexitySet != null) {
			inComplexity = complexitySet!.contains(entry.complexity);
			criterionList.add(inComplexity);
		}
		if (difficultySet != null) {
			inDifficulty = difficultySet!.contains(entry.difficulty);
			criterionList.add(inDifficulty);
		}
		
		if (prepTimeRange != null) {
			inPrepTime = _isWithinRange(entry.prepTimeMins, prepTimeRange!);
			criterionList.add(inPrepTime);
		}
		if (cookTimeRange != null) {
			inCookTime = _isWithinRange(entry.cookTimeMins, cookTimeRange!);
			criterionList.add(inCookTime);
		}
		if (servingsRange != null) {
			inServings = _isWithinRange(entry.servings, servingsRange!);
			criterionList.add(inServings);
		}

		if (criterionList.isEmpty) return false;

		for (final boolFlag in criterionList) {
			if (boolFlag == false) {
				return false;
			}
		}
		return true;
	}
}