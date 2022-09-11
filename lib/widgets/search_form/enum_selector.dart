import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/recipe_search_provider.dart';

class EnumSelector extends StatefulWidget {
	final String titleStr;
	final String searchName;
	final List<Enum> enumValues;
	final Map<Enum, String> enumStrings;

	const EnumSelector({
		required this.titleStr,
		required this.searchName,
		required this.enumValues,
		required this.enumStrings,
		Key? key,
	}) : super(key: key);

	@override
	State<EnumSelector> createState() => _EnumSelectorState();
}

class _EnumSelectorState extends State<EnumSelector> {
	final _chosenEnumSet = <Enum>{};

	@override
	Widget build(BuildContext context) {
		final appTheme = Theme.of(context);
		final recipeSearchProvider = Provider.of<RecipeSearchProvider>(context, listen: false);
		final currentValues = recipeSearchProvider.getEnumSearch(widget.searchName);
		final cvIsNotNull = currentValues != null;
		
		if (cvIsNotNull) {
			_chosenEnumSet.clear();
			_chosenEnumSet.addAll(currentValues);
		}

		return ExpansionTile(
			title: Text(widget.titleStr, style: appTheme.textTheme.titleMedium),
			initiallyExpanded: cvIsNotNull,
			onExpansionChanged: (isExpanded) {
				recipeSearchProvider.toggleSearch(widget.searchName, isExpanded);
			},
			children: widget.enumValues.map((enumVal) =>
				CheckboxListTile(
					title: Text(widget.enumStrings[enumVal]!),
					value: _chosenEnumSet.contains(enumVal),
					onChanged: (_) {
						setState(() {
							if (_chosenEnumSet.contains(enumVal)) {
								_chosenEnumSet.remove(enumVal);
							} else {
								_chosenEnumSet.add(enumVal);
							}
						});
						recipeSearchProvider.setEnumSearch(widget.searchName, _chosenEnumSet.toList(growable: false));
					},
				),
			).toList(),
		);
	}
}