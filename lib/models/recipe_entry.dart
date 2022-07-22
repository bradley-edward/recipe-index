import './entry_image.dart';
import './recipe_complexity.dart';
import './technical_difficulty.dart';

class RecipeEntry {
	int? id;
	final String name;
	final RecipeComplexity? complexity;
	final TechnicalDifficulty? difficulty;
	final int prepTimeMins;
	final int cookTimeMins;
	final int servings;
	List<EntryImage> images;
	Set<int> tagIds;

	RecipeEntry({
		this.id,
		required this.name,
		required this.difficulty,
		required this.complexity,
		required this.prepTimeMins,
		required this.cookTimeMins,
		required this.servings,
		required this.images,
		required this.tagIds,
	});

	String _getHoursMinutesStr(inputMins) {
		if (inputMins < 60) {
			return '$inputMins min';
		}
		return '${inputMins ~/ 60} hr ${inputMins % 60} min';
	}

	String get idString {
		if (id == null) {
			return '#NaN';
		}
		return '#${id.toString().padLeft(4,'0')}';
	}

	String get prepTimeHrsMins {
		return _getHoursMinutesStr(prepTimeMins);
	}

	String get cookingTimeHrsMins {
		return _getHoursMinutesStr(cookTimeMins);
	}
}