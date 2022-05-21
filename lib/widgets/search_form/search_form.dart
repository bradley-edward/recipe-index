import 'package:flutter/material.dart';

import '../../models/recipe_complexity.dart';
import '../../models/technical_difficulty.dart';
import '../../models/minute_range_params.dart';
import '../../models/entry_search_criteria.dart';

class SearchForm extends StatefulWidget {
	const SearchForm({ Key? key }) : super(key: key);

	@override
	State<SearchForm> createState() => _SearchFormState();
}

class _SearchFormState extends State<SearchForm> {
	final _enabledSearches = {
		'complexity': false,
		'difficulty': false,
		'prepTime': false,
		'cookTime': false,
		'servings': false,
	};
	final _complexitySearch = <RecipeComplexity>{};
	final _difficultySearch = <TechnicalDifficulty>{};
	final _prepTimeParams = MinuteRangeParams(
		rangeMin: 0,
		rangeMax: 100,
		intRange: const RangeValues(0,100),
	);
	final _cookTimeParams = MinuteRangeParams(
		rangeMin: 0,
		rangeMax: 100,
		intRange: const RangeValues(0,100),
	);
	final _servingParams = MinuteRangeParams(
		rangeMin: 0,
		rangeMax: 20,
		intRange: const RangeValues(0,20),
	);

	void submitSearch() {
		var atLeastOneEnabled = false;
		final searchPayload = EntrySearchCriteria();
		if (_enabledSearches['complexity']! && _complexitySearch.isNotEmpty) {
			atLeastOneEnabled = true;
			searchPayload.complexitySet = _complexitySearch;
		}
		if (_enabledSearches['difficulty']! && _difficultySearch.isNotEmpty) {
			atLeastOneEnabled = true;
			searchPayload.difficultySet = _difficultySearch;
		}

		if (_enabledSearches['prepTime']!) {
			atLeastOneEnabled = true;
			searchPayload.prepTimeRange = _prepTimeParams.rangeMap;
		}
		if (_enabledSearches['cookTime']!) {
			atLeastOneEnabled = true;
			searchPayload.cookTimeRange = _cookTimeParams.rangeMap;
		}
		if (_enabledSearches['servings']!) {
			atLeastOneEnabled = true;
			searchPayload.servingsRange = _servingParams.rangeMap;
		}

		Navigator.of(context).pushReplacementNamed('/', arguments: atLeastOneEnabled ? searchPayload : null);
	}

	Widget _buildEnumSearch({
		required Widget title,
		required String searchName,
		required List<Enum> enumValues,
		required Set<Object> searchParams,
		required Map<Object, String> enumStrings,
	}) => ExpansionTile(
		title: title,
		controlAffinity: ListTileControlAffinity.leading,
		leading: Switch(value: _enabledSearches[searchName] ?? false, onChanged: (_) {}),
		onExpansionChanged: (isExpanded) {
			setState(() {
				_enabledSearches[searchName] = isExpanded;
			});
		},
		children: enumValues.map((enumVal) =>
			CheckboxListTile(
				value: searchParams.contains(enumVal),
				onChanged: (_) {
					setState(() {
						if (searchParams.contains(enumVal)) {
							searchParams.remove(enumVal);
						} else {
							searchParams.add(enumVal);
						}
					});
				},
				title: Text(enumStrings[enumVal]!),
			),
		).toList(),
	);

	Widget _buildIntRange({
		required String titleStr,
		required String searchName,
		required MinuteRangeParams inputParams,
		required ThemeData appTheme,
		String? unitName,
	}) {
		final startInt = inputParams.intRange.start.round();
		final endInt = inputParams.intRange.end.round();
		var rangeStr = '$startInt - $endInt';
		if (unitName != null) {
			rangeStr += ' $unitName';
		}
		return ExpansionTile(
			title: Text(titleStr, style: appTheme.textTheme.titleMedium,),
			controlAffinity: ListTileControlAffinity.leading,
			leading: Switch(value: _enabledSearches[searchName]!, onChanged: (_) {}),
			onExpansionChanged: (isExpanded) {
				setState(() {
					_enabledSearches[searchName] = isExpanded;
				});
			},
			children: [
				Padding(
					padding: const EdgeInsets.symmetric(vertical: 2.5),
					child: Center(
						child: Text(rangeStr),
					),
				),
				ListTile(
					title: RangeSlider(
						values: inputParams.intRange,
						min: inputParams.rangeMin,
						max: inputParams.rangeMax,
						divisions: 20,
						onChanged: (RangeValues values) {
							setState(() {
								inputParams.intRange = values;
							});
						},
					),
				),
			],
		);
	}
	
	@override
	Widget build(BuildContext context) {
		final appTheme = Theme.of(context);
		return Column(
			children: <Widget>[
				Row(
					crossAxisAlignment: CrossAxisAlignment.start,
					mainAxisAlignment: MainAxisAlignment.spaceAround,
					children: [
						Expanded(
							child: _buildEnumSearch(
								title: Text('Complexity', style: appTheme.textTheme.titleMedium,),
								searchName: 'complexity',
								enumValues: RecipeComplexity.values,
								searchParams: _complexitySearch,
								enumStrings: complexityStrings,
							),
						),
						const SizedBox(width: 5,),
						Expanded(
							child: _buildEnumSearch(
								title: Text('Expertise', style: appTheme.textTheme.titleMedium,),
								searchName: 'difficulty',
								enumValues: TechnicalDifficulty.values,
								searchParams: _difficultySearch,
								enumStrings: difficultyStrings,
							),
						),
					],
				),
				const SizedBox(height: 20,),
				Row(
					crossAxisAlignment: CrossAxisAlignment.start,
					mainAxisAlignment: MainAxisAlignment.spaceAround,
					children: [
						Expanded(
							child: _buildIntRange(
								titleStr: 'Prep. Time',
								searchName: 'prepTime',
								inputParams: _prepTimeParams,
								appTheme: appTheme,
								unitName: 'mins',
							),
						),
						const SizedBox(width: 5,),
						Expanded(
							child: _buildIntRange(
								titleStr: 'Cooking Time',
								searchName: 'cookTime',
								inputParams: _cookTimeParams,
								appTheme: appTheme,
								unitName: 'mins',
							),
						),
					],
				),
				const SizedBox(height: 20,),
				Row(
					crossAxisAlignment: CrossAxisAlignment.start,
					mainAxisAlignment: MainAxisAlignment.start,
					children: [
						Expanded(
							child: _buildIntRange(
								titleStr: 'Servings',
								searchName: 'servings',
								inputParams: _servingParams,
								appTheme: appTheme,
							),
						),
					],
				),
				ElevatedButton.icon(
					onPressed: submitSearch,
					icon: const Icon(Icons.search),
					label: const Text('Search'),
				),
			],
		);
	}
}