import './entry_image.dart';
import './recipe_complexity.dart';
import './technical_difficulty.dart';

class RecipeEntry {
	int? id;
	final String name;
	final RecipeComplexity? complexity;
	final TechnicalDifficulty? difficulty;
	List<EntryImage> images;

	RecipeEntry({
		this.id,
		required this.name,
		required this.difficulty,
		required this.complexity,
		required this.images,
	});
}