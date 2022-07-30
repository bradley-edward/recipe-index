import './recipe_entry.dart';
import './recipe_complexity.dart';
import './technical_difficulty.dart';
import './entry_image.dart';

final dummyData = <RecipeEntry>[
	RecipeEntry(
		name: 'Glazed Carrots',
		displayId: '0001',
		difficulty: TechnicalDifficulty.easy,
		complexity: RecipeComplexity.moderate,
		prepTimeMins: 10,
		cookTimeMins: 10,
		servings: 2,
		images: [
			EntryImage(
				imageLocation: 'https://www.recipetineats.com/wp-content/uploads/2018/11/Brown-Sugar-Roast-Carrots_3.jpg',
				imageType: ImageType.fromInternet,
			),
			EntryImage(
				imageLocation: 'https://www.recipetineats.com/wp-content/uploads/2018/11/Brown-Sugar-Roast-carrots.jpg',
				imageType: ImageType.fromInternet,
			),
		],
		tagIds: <int>{},
	),
	RecipeEntry(
		name: 'Sweetcorn Soup',
		displayId: '0002',
		difficulty: TechnicalDifficulty.easy,
		complexity: RecipeComplexity.moderate,
		prepTimeMins: 5,
		cookTimeMins: 15,
		servings: 4,
		images: [
			EntryImage(
				imageLocation: 'https://meaningfuleats.com/wp-content/uploads/2017/07/corn-soup.jpg',
				imageType: ImageType.fromInternet,
			),
			EntryImage(
				imageLocation: 'https://meaningfuleats.com/wp-content/uploads/2017/07/sweet-corn-soup.jpg',
				imageType: ImageType.fromInternet
			),
		],
		tagIds: <int>{},
	),
	RecipeEntry(
		name: 'Soy-Balsamic Glazed Sea Scallops',
		displayId: '0003',
		difficulty: TechnicalDifficulty.easy,
		complexity: RecipeComplexity.moderate,
		prepTimeMins: 10,
		cookTimeMins: 12,
		servings: 2,
		images: [
			EntryImage(
				imageLocation: 'https://withsaltandwit.com/wp-content/uploads/2014/11/28.jpg',
				imageType: ImageType.fromInternet,
			),
			EntryImage(
				imageLocation: 'https://withsaltandwit.com/wp-content/uploads/2014/11/18.jpg',
				imageType: ImageType.fromInternet
			),
		],
		tagIds: <int>{},
	),
	RecipeEntry(
		name: 'Philly Cheesesteak',
		displayId: '0004',
		difficulty: TechnicalDifficulty.difficult,
		complexity: RecipeComplexity.complex,
		prepTimeMins: 30,
		cookTimeMins: 30,
		servings: 2,
		images: [
			EntryImage(
				imageLocation: 'https://www.spendwithpennies.com/wp-content/uploads/2020/02/Philly-Cheesesteak-SWP-12.jpg',
				imageType: ImageType.fromInternet,
			),
			EntryImage(
				imageLocation: 'https://www.spendwithpennies.com/wp-content/uploads/2020/02/Philly-Cheesesteak-SWP-9.jpg',
				imageType: ImageType.fromInternet
			),
		],
		tagIds: <int>{},
	),
	RecipeEntry(
		name: 'Brown Sugar Mustard Glazed Ham',
		displayId: '0005',
		difficulty: TechnicalDifficulty.difficult,
		complexity: RecipeComplexity.complex,
		prepTimeMins: 15,
		cookTimeMins: 75,
		servings: 10,
		images: [
			EntryImage(
				imageLocation: 'https://cafedelites.com/wp-content/uploads/2017/12/Brown-Sugar-Garlic-Ham-406.jpg',
				imageType: ImageType.fromInternet,
			),
			EntryImage(
				imageLocation: 'https://cafedelites.com/wp-content/uploads/2017/12/HAM-HOW-TO-Image.jpg',
				imageType: ImageType.fromInternet
			),
		],
		tagIds: <int>{},
	),
];