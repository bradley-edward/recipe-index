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
		var inComplexity = true;
		var inDifficulty = true;
		var inPrepTime = true;
		var inCookTime = true;
		var inServings = true;

		if (complexitySet != null) {
			inComplexity = complexitySet!.contains(entry.complexity);
		}
		if (difficultySet != null) {
			inDifficulty = difficultySet!.contains(entry.difficulty);
		}
		
		if (prepTimeRange != null) {
			inPrepTime = _isWithinRange(entry.prepTimeMins, prepTimeRange!);
		}
		if (cookTimeRange != null) {
			inCookTime = _isWithinRange(entry.cookTimeMins, cookTimeRange!);
		}
		if (servingsRange != null) {
			inServings = _isWithinRange(entry.servings, servingsRange!);
		}

		return inComplexity && inDifficulty && inPrepTime && inCookTime && inServings;
	}
}