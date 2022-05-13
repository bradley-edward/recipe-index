import './recipe_entry.dart';
import './recipe_complexity.dart';
import './technical_difficulty.dart';
import './entry_image.dart';

final dummyData = <RecipeEntry>[
	RecipeEntry(
		name: 'Glazed Carrots',
		difficulty: TechnicalDifficulty.easy,
		complexity: RecipeComplexity.moderate,
		images: [
			EntryImage(
				imageLocation: 'https://www.recipetineats.com/wp-content/uploads/2018/11/Brown-Sugar-Roast-Carrots_3.jpg',
				imageType: ImageType.fromInternet,
			),
			EntryImage(
				imageLocation: 'https://www.recipetineats.com/wp-content/uploads/2018/11/Brown-Sugar-Roast-carrots.jpg',
				imageType: ImageType.fromInternet,
			),
		]
	),
	RecipeEntry(
		name: 'Sweetcorn Soup',
		difficulty: TechnicalDifficulty.easy,
		complexity: RecipeComplexity.moderate,
		images: [
			EntryImage(
				imageLocation: 'https://meaningfuleats.com/wp-content/uploads/2017/07/corn-soup.jpg',
				imageType: ImageType.fromInternet,
			),
			EntryImage(
				imageLocation: 'https://meaningfuleats.com/wp-content/uploads/2017/07/sweet-corn-soup.jpg',
				imageType: ImageType.fromInternet
			),
		]
	),
];