import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/entry_image.dart';
import '../../providers/recipe_collection.dart';
import '../../models/recipe_entry.dart';
import '../../models/recipe_complexity.dart';
import '../../models/technical_difficulty.dart';
import './image_list_edit.dart';

class RecipeForm extends StatefulWidget {
	final String? inputId;
	final String formMode;

	const RecipeForm({this.inputId, required this.formMode, Key? key }) : super(key: key);

	@override
	State<RecipeForm> createState() => _RecipeFormState();
}

class _RecipeFormState extends State<RecipeForm> {
	final _form = GlobalKey<FormState>();

	var _editedEntry = RecipeEntry(
		id: null,
		entryId: '',
		name: '',
		difficulty: null,
		complexity: null,
		images: [],
	);
	var _imagesToDelete = <String>{};
	var _initValues = <String, dynamic>{
		'entryId': '',
		'name': '',
		'images': <EntryImage>[],
		'difficulty': null,
		'complexity': null,
	};

	var _isLoading = false;
	
	@override
	void initState() {
		super.initState();
		if (widget.inputId != null) {
			final fetchedEntry = Provider.of<RecipeCollection>(context, listen: false).findById(widget.inputId!);
			if (widget.formMode == 'New') {
				_editedEntry = RecipeEntry(
					id: null,
					entryId: fetchedEntry.entryId,
					name: fetchedEntry.name,
					difficulty: fetchedEntry.difficulty,
					complexity: fetchedEntry.complexity,
					images: [],
				);
				for (final image in fetchedEntry.images) {
					_editedEntry.images.add(EntryImage(
						imageLocation: image.imageLocation,
						imageType: image.imageType,
					));
				}
			} else if (widget.formMode == 'Edit') {
				_editedEntry = fetchedEntry;
			}
			_initValues = {
				'entryId': _editedEntry.entryId,
				'name': _editedEntry.name,
				'images': _editedEntry.images,
				'complexity': _editedEntry.complexity,
				'difficulty': _editedEntry.difficulty,
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
		setState(() {
			_isLoading = false;
		});
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
								initialValue: _initValues['entryId'],
								decoration: const InputDecoration(labelText: 'Entry ID',),
								keyboardType: const TextInputType.numberWithOptions(signed: false, decimal: false),
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
										entryId: value!,
										name: _editedEntry.name,
										complexity: _editedEntry.complexity,
										difficulty: _editedEntry.difficulty,
										images: _editedEntry.images,
									);
								},
							),
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
										entryId: _editedEntry.entryId,
										name: value!,
										complexity: _editedEntry.complexity,
										difficulty: _editedEntry.difficulty,
										images: _editedEntry.images,
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
													entryId: _editedEntry.entryId,
													name: _editedEntry.name,
													complexity: value!,
													difficulty: _editedEntry.difficulty,
													images: _editedEntry.images,
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
													entryId: _editedEntry.entryId,
													name: _editedEntry.name,
													complexity: _editedEntry.complexity,
													difficulty: value!,
													images: _editedEntry.images,
												);
											},
										),
									),
								],
							),
						],
					),
				),
				const SizedBox(height: 25,),
				ImageListEdit(
					initialList: _initValues['images'],
					onUpdateList: (List<EntryImage> newImagesList, [Set<String>? deletedImageIds]) {
						_editedEntry.images = newImagesList;
						if (deletedImageIds != null) {
							_imagesToDelete = deletedImageIds;
						}
					}
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