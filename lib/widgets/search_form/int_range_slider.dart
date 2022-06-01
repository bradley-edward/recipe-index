import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/recipe_search_provider.dart';

class IntRangeSlider extends StatefulWidget {
	final String titleStr;
	final String searchName;
	final double rangeMin;
	final double rangeMax;
	final double rangeStep;
	final String? unitName;

	const IntRangeSlider({
		required this.titleStr,
		required this.searchName,
		required this.rangeMin,
		required this.rangeMax,
		required this.rangeStep,
		this.unitName,
		Key? key
	}) : super(key: key);

	@override
	State<IntRangeSlider> createState() => _IntRangeSliderState();
}

class _IntRangeSliderState extends State<IntRangeSlider> {
	bool _isEnabled = false;
	RangeValues? _intRange;

	@override
	void initState() {
		super.initState();
		_intRange = RangeValues(widget.rangeMin, widget.rangeMax);
	}

	@override
	Widget build(BuildContext context) {
		final appTheme = Theme.of(context);
		final recipeSearchProvider = Provider.of<RecipeSearchProvider>(context, listen: false);
		final currentValues = recipeSearchProvider.getIntRange(widget.searchName);
		final cvIsNotNull = currentValues != null;

		if (cvIsNotNull) {
			_intRange = RangeValues(
				currentValues['from']!.toDouble(),
				currentValues['to']!.toDouble(),
			);
		}

		final startInt = _intRange!.start.round();
		final endInt = _intRange!.end.round();

		var rangeStr = '$startInt - $endInt';
		if (widget.unitName != null) {
			rangeStr += ' ${widget.unitName}';
		}

		return ExpansionTile(
			title: Text(widget.titleStr, style: appTheme.textTheme.titleMedium,),
			controlAffinity: ListTileControlAffinity.leading,
			leading: Switch(value: _isEnabled || cvIsNotNull, onChanged: (_) {}),
			initiallyExpanded: cvIsNotNull,
			onExpansionChanged: (isExpanded) {
				recipeSearchProvider.toggleSearch(widget.searchName, isExpanded);
				setState(() {
					_isEnabled = isExpanded;
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
						values: _intRange!,
						min: widget.rangeMin,
						max: widget.rangeMax,
						divisions: (widget.rangeMax - widget.rangeMin) ~/ widget.rangeStep,
						onChanged: (RangeValues values) {
							setState(() {
								_intRange = values;
							});
							recipeSearchProvider.setIntRange(widget.searchName, {
								'from': values.start.round(),
								'to': values.end.round(),
							});
						},
					),
				),
			],
		);
	}
}