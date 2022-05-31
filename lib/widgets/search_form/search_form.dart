import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/recipe_search_provider.dart';
import '../../models/recipe_complexity.dart';
import '../../models/technical_difficulty.dart';
import './enum_selector.dart';
import './int_range_slider.dart';

class SearchForm extends StatelessWidget {
	const SearchForm({ Key? key }) : super(key: key);

	@override
	Widget build(BuildContext context) {
		final recipeSearchProvider = Provider.of<RecipeSearchProvider>(context, listen: false);
		return Column(
			children: <Widget>[
				Row(
					crossAxisAlignment: CrossAxisAlignment.start,
					mainAxisAlignment: MainAxisAlignment.spaceAround,
					children: [
						Expanded(
							child: EnumSelector(
								titleStr: 'Complexity',
								searchName: 'complexity',
								enumValues: RecipeComplexity.values,
								enumStrings: complexityStrings,
							),
						),
						const SizedBox(width: 5,),
						Expanded(
							child: EnumSelector(
								titleStr: 'Expertise',
								searchName: 'difficulty',
								enumValues: TechnicalDifficulty.values,
								enumStrings: difficultyStrings,
							),
						),
					],
				),
				const SizedBox(height: 20,),
				Row(
					crossAxisAlignment: CrossAxisAlignment.start,
					mainAxisAlignment: MainAxisAlignment.spaceAround,
					children: const [
						Expanded(
							child: IntRangeSlider(
								titleStr: 'Prep. Time',
								searchName: 'prepTime',
								rangeMin: 0,
								rangeMax: 180,
								rangeStep: 5,
								unitName: 'mins',
							),
						),
						SizedBox(width: 5,),
						Expanded(
							child: IntRangeSlider(
								titleStr: 'Cooking Time',
								searchName: 'cookTime',
								rangeMin: 0,
								rangeMax: 180,
								rangeStep: 5,
								unitName: 'mins',
							),
						),
					],
				),
				const SizedBox(height: 20,),
				Row(
					crossAxisAlignment: CrossAxisAlignment.start,
					mainAxisAlignment: MainAxisAlignment.start,
					children: const [
						Expanded(
							child: IntRangeSlider(
								titleStr: 'Servings',
								searchName: 'servings',
								rangeMin: 0,
								rangeMax: 20,
								rangeStep: 1,
							),
						),
					],
				),
				ElevatedButton.icon(
					onPressed: () {
						recipeSearchProvider.notifySearchResults();
					},
					icon: const Icon(Icons.search),
					label: const Text('Search'),
				),
			],
		);
	}
}