import 'package:flutter/material.dart';

import '../../models/recipe_complexity.dart';
import '../../models/technical_difficulty.dart';
import '../../models/minute_range_params.dart';

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
		errorMsg: '',
		fromController: TextEditingController(),
		toController: TextEditingController(),
	);
	final _cookTimeParams = MinuteRangeParams(
		errorMsg: '',
		fromController: TextEditingController(),
		toController: TextEditingController(),
	);
	final _servingParams = MinuteRangeParams(
		errorMsg: '',
		fromController: TextEditingController(),
		toController: TextEditingController(),
	);

	void submitSearch() {
		final searchPayload = <String,Object>{};
		if (_enabledSearches['complexity']! && _complexitySearch.isNotEmpty) {
			searchPayload['complexity'] = _complexitySearch;
		}
		if (_enabledSearches['difficulty']! && _difficultySearch.isNotEmpty) {
			searchPayload['difficulty'] = _difficultySearch;
		}

		if (_enabledSearches['prepTime']!) {
			setState(() {
				_prepTimeParams.validateInputs();
			});
			if (_prepTimeParams.hasError) {
				return;
			}

			searchPayload['prepTime'] = _prepTimeParams.intRange;
		}
		if (_enabledSearches['cookTime']!) {
			setState(() {
				_cookTimeParams.validateInputs();
			});
			if (_cookTimeParams.hasError) {
				return;
			}

			searchPayload['cookTime'] = _cookTimeParams.intRange;
		}
		if (_enabledSearches['servings']!) {
			setState(() {
				_servingParams.validateInputs();
			});
			if (_servingParams.hasError) {
				return;
			}

			searchPayload['servings'] = _servingParams.intRange;
		}

		Navigator.of(context).pushReplacementNamed('/', arguments: searchPayload.isEmpty ? null : searchPayload);
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
	}) => ExpansionTile(
		title: Text(titleStr, style: appTheme.textTheme.titleMedium,),
		controlAffinity: ListTileControlAffinity.leading,
		leading: Switch(value: _enabledSearches[searchName]!, onChanged: (_) {}),
		onExpansionChanged: (isExpanded) {
			setState(() {
				_enabledSearches[searchName] = isExpanded;
			});
		},
		children: [
			ListTile(
				leading: const Text('From'),
				title: TextField(
					controller: inputParams.fromController,
					keyboardType: const TextInputType.numberWithOptions(signed: false, decimal: false),
					decoration: const InputDecoration(
						hintText: '0',
					),
					onEditingComplete: () {
						FocusScope.of(context).unfocus();
						setState(() {
							inputParams.validateInputs();
						});
					},
				),
				trailing: unitName != null ? Text(unitName) : null,
			),
			ListTile(
				leading: const Text('To'),
				title: TextField(
					controller: inputParams.toController,
					keyboardType: const TextInputType.numberWithOptions(signed: false, decimal: false),
					decoration: const InputDecoration(
						hintText: 'Infinity',
					),
					onEditingComplete: () {
						FocusScope.of(context).unfocus();
						setState(() {
							inputParams.validateInputs();
						});
					},
				),
				trailing: unitName != null ? Text(unitName) : null,
			),
			if (_prepTimeParams.hasError) Padding(
				padding: const EdgeInsets.symmetric(vertical: 8),
				child: Text(
					_prepTimeParams.errorMsg,
					style: TextStyle(
						color: appTheme.errorColor,
					),
					textAlign: TextAlign.center,
				),
			)
		],
	);
	
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
								unitName: 'min',
							),
						),
						const SizedBox(width: 5,),
						Expanded(
							child: _buildIntRange(
								titleStr: 'Cooking Time',
								searchName: 'cookTime',
								inputParams: _cookTimeParams,
								appTheme: appTheme,
								unitName: 'min',
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