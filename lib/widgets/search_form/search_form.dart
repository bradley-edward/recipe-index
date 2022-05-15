import 'package:flutter/material.dart';

import '../../models/recipe_complexity.dart';
import '../../models/technical_difficulty.dart';

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
	};
	final _complexitySearch = <RecipeComplexity>{};
	final _difficultySearch = <TechnicalDifficulty>{};

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
							child: ExpansionTile(
								title: Text('Prep. Time', style: appTheme.textTheme.titleMedium,),
								controlAffinity: ListTileControlAffinity.leading,
								leading: Switch(value: true, onChanged: (_) {}),
								children: const [
									ListTile(
										leading: Text('From'),
										title: TextField(
											keyboardType: TextInputType.numberWithOptions(signed: false, decimal: false),
										),
									),
									ListTile(
										leading: Text('To'),
										title: TextField(
											keyboardType: TextInputType.numberWithOptions(signed: false, decimal: false),
										),
									),
								],
							),
						),
						const SizedBox(width: 5,),
						Expanded(
							child: ExpansionTile(
								title: Text('Cooking Time', style: appTheme.textTheme.titleMedium,),
								controlAffinity: ListTileControlAffinity.leading,
								leading: Switch(value: true, onChanged: (_) {}),
								children: const [
									ListTile(
										leading: Text('From'),
										title: TextField(
											keyboardType: TextInputType.numberWithOptions(signed: false, decimal: false),
										),
									),
									ListTile(
										leading: Text('To'),
										title: TextField(
											keyboardType: TextInputType.numberWithOptions(signed: false, decimal: false),
										),
									),
								],
							),
						),
					],
				),
			],
		);
	}
}