import 'package:flutter/material.dart';

import '../../models/recipe_complexity.dart';
import '../../models/technical_difficulty.dart';

class SearchForm extends StatefulWidget {
	const SearchForm({ Key? key }) : super(key: key);

	@override
	State<SearchForm> createState() => _SearchFormState();
}

class _SearchFormState extends State<SearchForm> {
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
							child: ExpansionTile(
								title: Text('Complexity', style: appTheme.textTheme.titleMedium,),
								controlAffinity: ListTileControlAffinity.leading,
								children: RecipeComplexity.values.map((val) =>
									CheckboxListTile(
										value: true,
										onChanged: (_) {},
										title: Text(complexityStrings[val]!),
									),
								).toList(),
								leading: Switch(value: true, onChanged: (_) {}),
							),
						),
						const SizedBox(width: 5,),
						Expanded(
							child: ExpansionTile(
								title: Text('Expertise', style: appTheme.textTheme.titleMedium,),
								controlAffinity: ListTileControlAffinity.leading,
								children: TechnicalDifficulty.values.map((val) =>
									CheckboxListTile(
										value: true,
										onChanged: (_) {},
										title: Text(difficultyStrings[val]!),
									),
								).toList(),
								leading: Switch(value: true, onChanged: (_) {}),
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