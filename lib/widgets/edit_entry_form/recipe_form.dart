import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/entry_image.dart';
import '../../providers/recipe_collection.dart';
import '../../models/recipe_entry.dart';
import '../../models/recipe_complexity.dart';
import '../../models/technical_difficulty.dart';
import './image_list_edit.dart';
import './recipe_form_tag_selection.dart';

class RecipeForm extends StatefulWidget {
	final int? inputId;
	final String formMode;

	const RecipeForm({this.inputId, required this.formMode, Key? key }) : super(key: key);

	@override
	State<RecipeForm> createState() => _RecipeFormState();
}

class _RecipeFormState extends State<RecipeForm> {
	final _form = GlobalKey<FormState>();

	var _editedEntry = RecipeEntry(
		id: null,
		name: '',
		difficulty: null,
		complexity: null,
		prepTimeMins: 0,
		cookTimeMins: 0,
		servings: 0,
		images: [],
		tagIds: <int>{},
	);
	var _imagesToDelete = <int>{};
	var _initValues = <String, dynamic>{
		'entryId': '',
		'name': '',
		'images': <EntryImage>[],
		'difficulty': null,
		'complexity': null,
		'prepTime': 0,
		'cookingTime': 0,
		'servings': 0,
		'tagIds': <int>{},
	};

	var _isLoading = false;

	void tagSelectionUpdateHandler(Set<int> selectedTags) {
		_editedEntry = RecipeEntry(
			id: _editedEntry.id,
			name: _editedEntry.name,
			complexity: _editedEntry.complexity,
			difficulty: _editedEntry.difficulty,
			prepTimeMins: _editedEntry.prepTimeMins,
			cookTimeMins: _editedEntry.cookTimeMins,
			servings: _editedEntry.servings,
			images: _editedEntry.images,
			tagIds: selectedTags,
		);
	}

	void imageListUpdateHandler(List<EntryImage> newImagesList, [Set<int>? deletedImageIds]) {
		_editedEntry = RecipeEntry(
			id: _editedEntry.id,
			name: _editedEntry.name,
			complexity: _editedEntry.complexity,
			difficulty: _editedEntry.difficulty,
			prepTimeMins: _editedEntry.prepTimeMins,
			cookTimeMins: _editedEntry.cookTimeMins,
			servings: _editedEntry.servings,
			images: newImagesList,
			tagIds: _editedEntry.tagIds,
		);

		if (deletedImageIds != null) {
			_imagesToDelete = deletedImageIds;
		}
	}
	
	@override
	void initState() {
		super.initState();
		if (widget.inputId != null) {
			final fetchedEntry = Provider.of<RecipeCollection>(context, listen: false).findById(widget.inputId!)!;
			if (widget.formMode == 'New') {
				_editedEntry = RecipeEntry(
					id: null,
					name: fetchedEntry.name,
					difficulty: fetchedEntry.difficulty,
					complexity: fetchedEntry.complexity,
					prepTimeMins: fetchedEntry.prepTimeMins,
					cookTimeMins: fetchedEntry.cookTimeMins,
					servings: fetchedEntry.servings,
					images: fetchedEntry.images.map((image) => EntryImage(
						imageLocation: image.imageLocation,
						imageType: image.imageType,
					)).toList(),
					tagIds: fetchedEntry.tagIds,
				);
			} else if (widget.formMode == 'Edit') {
				_editedEntry = fetchedEntry;
			}
			_initValues = {
				'name': _editedEntry.name,
				'images': _editedEntry.images,
				'tagIds': _editedEntry.tagIds,
				'complexity': _editedEntry.complexity,
				'difficulty': _editedEntry.difficulty,
				'prepTime': _editedEntry.prepTimeMins,
				'cookingTime': _editedEntry.cookTimeMins,
				'servings': _editedEntry.servings,
			};
		}
	}

	@override
	void dispose() {
		super.dispose();
	}

	Future<void> _saveForm() async {
		var currentFormState = _form.currentState;
		if (currentFormState == null) {
			return;
		}

		final isValid = currentFormState.validate();
		if (!isValid) {
			return;
		}

		var collectionProvider = Provider.of<RecipeCollection>(context, listen: false);

		currentFormState.save();
		setState(() {
			_isLoading = true;
		});

		if (_editedEntry.id != null) {
			// Edit existing entry
			await collectionProvider.updateEntry(_editedEntry.id!, _editedEntry, _imagesToDelete);
		} else {
			// Add new entry
			await collectionProvider.addEntry(_editedEntry);
		}
		Navigator.of(context).pop();
	}

	@override
	Widget build(BuildContext context) {
		return _isLoading
		? const Center(child: CircularProgressIndicator(),)
		: Column(
			children: [
				Form(
					key: _form,
					child: Column(
						children: <Widget>[
							TextFormField(
								initialValue: _initValues['name'],
								decoration: const InputDecoration(labelText: 'Entry Name',),
								textInputAction: TextInputAction.next,
								validator: (value) {
									if (value == null) {
										return 'Please provide a value';
									}
									if (value.isEmpty) {
										return 'Please provide a value';
									}
									return null;
								},
								onSaved: (value) {
									_editedEntry = RecipeEntry(
										id: _editedEntry.id,
										name: value!,
										complexity: _editedEntry.complexity,
										difficulty: _editedEntry.difficulty,
										prepTimeMins: _editedEntry.prepTimeMins,
										cookTimeMins: _editedEntry.cookTimeMins,
										servings: _editedEntry.servings,
										images: _editedEntry.images,
										tagIds: _editedEntry.tagIds,
									);
								},
							),
							Row(
								children: [
									Expanded(
										child: DropdownButtonFormField<RecipeComplexity>(
											value: _initValues['complexity'],
											decoration: const InputDecoration(
												label: Text('Complexity'),
											),
											items: <RecipeComplexity>[
												RecipeComplexity.simple, RecipeComplexity.moderate, RecipeComplexity.complex
												].map((RecipeComplexity value) =>
												DropdownMenuItem(
													value: value,
													child: Text(complexityStrings[value]!),
												)
											).toList(),
											validator: (RecipeComplexity? value) {
												if (value == null) {
													return 'Please provide a value.';
												}
												return null;
											},
											onChanged: (_) {},
											onSaved: (RecipeComplexity? value) {
												_editedEntry = RecipeEntry(
													id: _editedEntry.id,
													name: _editedEntry.name,
													complexity: value!,
													difficulty: _editedEntry.difficulty,
													prepTimeMins: _editedEntry.prepTimeMins,
													cookTimeMins: _editedEntry.cookTimeMins,
													servings: _editedEntry.servings,
													images: _editedEntry.images,
													tagIds: _editedEntry.tagIds,
												);
											},
										),
									),
									const SizedBox(width: 10,),
									Expanded(
										child: DropdownButtonFormField<TechnicalDifficulty>(
											value: _initValues['difficulty'],
											decoration: const InputDecoration(
												label: Text('Expertise'),
											),
											items: <TechnicalDifficulty>[
												TechnicalDifficulty.easy, TechnicalDifficulty.medium, TechnicalDifficulty.difficult
												].map((TechnicalDifficulty value) =>
												DropdownMenuItem(
													value: value,
													child: Text(difficultyStrings[value]!),
												)
											).toList(),
											validator: (TechnicalDifficulty? value) {
												if (value == null) {
													return 'Please provide a value.';
												}
												return null;
											},
											onChanged: (_) {},
											onSaved: (TechnicalDifficulty? value) {
												_editedEntry = RecipeEntry(
													id: _editedEntry.id,
													name: _editedEntry.name,
													complexity: _editedEntry.complexity,
													difficulty: value!,
													prepTimeMins: _editedEntry.prepTimeMins,
													cookTimeMins: _editedEntry.cookTimeMins,
													servings: _editedEntry.servings,
													images: _editedEntry.images,
													tagIds: _editedEntry.tagIds,
												);
											},
										),
									),
								],
							),
							Row(
								children: [
									Expanded(
										child: TextFormField(
											initialValue: _initValues['prepTime'].toString(),
											decoration: const InputDecoration(labelText: 'Prep. Time (mins)',),
											keyboardType: const TextInputType.numberWithOptions(signed: false, decimal: false),
											textInputAction: TextInputAction.next,
											validator: (value) {
												if (value == null) {
													return 'Please provide a value';
												}
												if (value.isEmpty) {
													return 'Please provide a value';
												}
												final valueInt = int.tryParse(value);
												if (valueInt == null) {
													return 'Please provide an integer';
												}
												if (valueInt < 1) {
													return 'Please provide a value greater than 0';
												}
												return null;
											},
											onSaved: (value) {
												_editedEntry = RecipeEntry(
													id: _editedEntry.id,
													name: _editedEntry.name,
													complexity: _editedEntry.complexity,
													difficulty: _editedEntry.difficulty,
													prepTimeMins: int.parse(value!),
													cookTimeMins: _editedEntry.cookTimeMins,
													servings: _editedEntry.servings,
													images: _editedEntry.images,
													tagIds: _editedEntry.tagIds,
												);
											},
										),
									),
									const SizedBox(width: 10,),
									Expanded(
										child: TextFormField(
											initialValue: _initValues['cookingTime'].toString(),
											decoration: const InputDecoration(labelText: 'Cooking Time (mins)',),
											keyboardType: const TextInputType.numberWithOptions(signed: false, decimal: false),
											textInputAction: TextInputAction.next,
											validator: (value) {
												if (value == null) {
													return 'Please provide a value';
												}
												if (value.isEmpty) {
													return 'Please provide a value';
												}
												final valueInt = int.tryParse(value);
												if (valueInt == null) {
													return 'Please provide an integer';
												}
												if (valueInt < 1) {
													return 'Please provide a value greater than 0';
												}
												return null;
											},
											onSaved: (value) {
												_editedEntry = RecipeEntry(
													id: _editedEntry.id,
													name: _editedEntry.name,
													complexity: _editedEntry.complexity,
													difficulty: _editedEntry.difficulty,
													prepTimeMins: _editedEntry.prepTimeMins,
													cookTimeMins: int.parse(value!),
													servings: _editedEntry.servings,
													images: _editedEntry.images,
													tagIds: _editedEntry.tagIds,
												);
											},
										),
									),
								],
							),
							TextFormField(
								initialValue: _initValues['servings'].toString(),
								decoration: const InputDecoration(labelText: 'Servings',),
								keyboardType: const TextInputType.numberWithOptions(signed: false, decimal: false),
								textInputAction: TextInputAction.next,
								validator: (value) {
									if (value == null) {
										return 'Please provide a value';
									}
									if (value.isEmpty) {
										return 'Please provide a value';
									}
									final valueInt = int.tryParse(value);
									if (valueInt == null) {
										return 'Please provide an integer';
									}
									if (valueInt < 1) {
										return 'Please provide a value greater than 0';
									}
									return null;
								},
								onSaved: (value) {
									_editedEntry = RecipeEntry(
										id: _editedEntry.id,
										name: _editedEntry.name,
										complexity: _editedEntry.complexity,
										difficulty: _editedEntry.difficulty,
										prepTimeMins: _editedEntry.prepTimeMins,
										cookTimeMins: _editedEntry.cookTimeMins,
										servings: int.parse(value!),
										images: _editedEntry.images,
										tagIds: _editedEntry.tagIds,
									);
								},
							),
						],
					),
				),
				RecipeFormTagSelection(
					onTagSelectionUpdate: tagSelectionUpdateHandler,
					initialSelection: _initValues['tagIds'],
				),
				const SizedBox(height: 25,),
				ImageListEdit(
					initialList: _initValues['images'],
					onUpdateList: imageListUpdateHandler,
				),
				const SizedBox(height: 25,),
				ElevatedButton.icon(
					onPressed: _saveForm,
					icon: const Icon(Icons.save),
					label: const Text('Submit')
				),
			],
		);
	}
}