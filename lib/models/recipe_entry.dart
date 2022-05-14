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

	RecipeEntry({
		this.id,
		required this.name,
		required this.difficulty,
		required this.complexity,
		required this.prepTimeMins,
		required this.cookTimeMins,
		required this.servings,
		required this.images,
	});

	String get idString {
		if (id == null) {
			return '#NaN';
		}
		return '#${id.toString().padLeft(4,'0')}';
	}
}