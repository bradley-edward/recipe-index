import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/recipe_collection.dart';
import '../providers/recipe_tag_list.dart';

import './screens/recipe_list_screen.dart';
import './screens/recipe_details_screen.dart';
import './screens/search_screen.dart';
import './screens/edit_recipe_screen.dart';
import './screens/recipe_backup_screen.dart';
import './screens/tags_edit_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
	const MyApp({Key? key}) : super(key: key);

	// This widget is the root of your application.
	@override
	Widget build(BuildContext context) {
		return MultiProvider(
			providers: [
				ChangeNotifierProvider(create: (context) => RecipeCollection(),),
				ChangeNotifierProvider(create: (context) => RecipeTagList()),
			],
			child: MaterialApp(
				title: 'Flutter Demo',
				theme: ThemeData(
					primarySwatch: Colors.blue,
				),
				home: RecipeListScreen(),
				routes: {
					RecipeDetailsScreen.routeName: (ctx) => RecipeDetailsScreen(),
					SearchScreen.routeName: (ctx) => SearchScreen(),
					EditRecipeScreen.routeName: (ctx) => EditRecipeScreen(),
					RecipeBackupScreen.routeName: (ctx) => RecipeBackupScreen(),
					TagsEditScreen.routeName: (ctx) => TagsEditScreen(),
				},
			),
		);
	}
}
