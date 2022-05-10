import './entry_image.dart';
import './recipe_complexity.dart';
import './technical_difficulty.dart';

class RecipeEntry {
	final String? id;
	final String entryId;
	final String name;
	final RecipeComplexity? complexity;
	final TechnicalDifficulty? difficulty;
	List<EntryImage> images;

	RecipeEntry({
		required this.id,
		required this.entryId,
		required this.name,
		required this.difficulty,
		required this.complexity,
		required this.images,
	});
}