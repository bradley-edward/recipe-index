import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../models/entry_image.dart';
import '../../providers/recipe_collection.dart';
import '../../models/recipe_entry.dart';
import '../../models/recipe_complexity.dart';
import '../../models/technical_difficulty.dart';
import '../../screens/recipe_details_screen.dart';
import './image_list_edit.dart';
import './recipe_form_tag_selection.dart';
import '../delete_entries_alert_dialog.dart';

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
		displayId: '',
		difficulty: null,
		complexity: null,
		prepTimeMins: 0,
		cookTimeMins: 0,
		servings: '0',
    rating: 0.0,
		images: [],
		tagIds: <int>{},
    notes: '',
	);
	var _imagesToDelete = <int>{};
	var _initValues = <String, dynamic>{
		'entryId': '',
		'name': '',
		'displayId': '',
		'images': <EntryImage>[],
		'difficulty': null,
		'complexity': null,
		'prepTime': 0,
		'cookingTime': 0,
		'servings': 0,
    'rating': 0.0,
		'tagIds': <int>{},
    'notes': '',
	};

	var _isLoading = false;

	void tagSelectionUpdateHandler(Set<int> selectedTags) {
		_editedEntry = RecipeEntry(
			id: _editedEntry.id,
			displayId: _editedEntry.displayId,
			name: _editedEntry.name,
			complexity: _editedEntry.complexity,
			difficulty: _editedEntry.difficulty,
			prepTimeMins: _editedEntry.prepTimeMins,
			cookTimeMins: _editedEntry.cookTimeMins,
			servings: _editedEntry.servings,
      rating: _editedEntry.rating,
			images: _editedEntry.images,
			tagIds: selectedTags,
      notes: _editedEntry.notes,
		);
	}

	void imageListUpdateHandler(List<EntryImage> newImagesList, [Set<int>? deletedImageIds]) {
		_editedEntry = RecipeEntry(
			id: _editedEntry.id,
			displayId: _editedEntry.displayId,
			name: _editedEntry.name,
			complexity: _editedEntry.complexity,
			difficulty: _editedEntry.difficulty,
			prepTimeMins: _editedEntry.prepTimeMins,
			cookTimeMins: _editedEntry.cookTimeMins,
			servings: _editedEntry.servings,
      rating: _editedEntry.rating,
			images: newImagesList,
			tagIds: _editedEntry.tagIds,
      notes: _editedEntry.notes,
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
					displayId: fetchedEntry.displayId,
					difficulty: fetchedEntry.difficulty,
					complexity: fetchedEntry.complexity,
					prepTimeMins: fetchedEntry.prepTimeMins,
					cookTimeMins: fetchedEntry.cookTimeMins,
					servings: fetchedEntry.servings,
          rating: fetchedEntry.rating,
					images: fetchedEntry.images.map((image) => EntryImage(
						imageLocation: image.imageLocation,
						imageType: image.imageType,
					)).toList(),
					tagIds: fetchedEntry.tagIds,
          notes: fetchedEntry.notes,
				);
			} else if (widget.formMode == 'Edit') {
				_editedEntry = fetchedEntry;
			}
			_initValues = {
				'name': _editedEntry.name,
				'displayId': _editedEntry.displayId,
				'images': _editedEntry.images,
				'tagIds': _editedEntry.tagIds,
				'complexity': _editedEntry.complexity,
				'difficulty': _editedEntry.difficulty,
				'prepTime': _editedEntry.prepTimeMins,
				'cookingTime': _editedEntry.cookTimeMins,
				'servings': _editedEntry.servings,
        'rating': _editedEntry.rating,
        'notes': _editedEntry.notes,
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

		final appNav = Navigator.of(context);

		if (widget.formMode == 'Edit') {
			// Edit existing entry
			await collectionProvider.updateEntry(_editedEntry.id!, _editedEntry, _imagesToDelete, _initValues['tagIds']);
			appNav.pop();
		} else {
			// Add new entry
			final newEntryId = await collectionProvider.addEntry(_editedEntry);

			if (widget.inputId != null) {
				// We have entered this form via a recipe details screen.
				// So back out once to go to the details screen of the first recipe, then pushReplacement on it.
				appNav..pop()..pushReplacementNamed(
					RecipeDetailsScreen.routeName,
					arguments: newEntryId
				);
			} else {
				// We have entered this form via the recipe list screen.
				// pushReplacement to go right to the new recipe.
				appNav.pushReplacementNamed(
					RecipeDetailsScreen.routeName,
					arguments: newEntryId
				);
			}
		}
	}

	@override
	Widget build(BuildContext context) {
		final providerRc = Provider.of<RecipeCollection>(context, listen: false);

		return Scaffold(
			appBar: AppBar(
				title: Text('${widget.formMode} Recipe'),
				actions: [
					IconButton(
						onPressed: () async {
							final confirmSave = await showDialog(
								context: context,
								builder: (BuildContext ctx) {
									return DeleteEntriesAlertDialog(
										title: const Text('Confirm Save'),
										content: const Text('Save changes?')
									);
								}
							);
							if (confirmSave) {
								_saveForm();
							}
						},
						icon: const Icon(Icons.save),
					),
					if (widget.formMode == 'Edit' && widget.inputId != null) IconButton(
						icon: const Icon(Icons.delete),
						onPressed: () async {
							final confirmDelete = await showDialog(
								context: context,
								builder: (BuildContext ctx) {
									return DeleteEntriesAlertDialog(
										title: Text('Deleting entry ${widget.inputId!}...'),
										content: const Text('Delete this entry?')
									);
								}
							);
							if (confirmDelete) {
								await providerRc.deleteEntries({widget.inputId!});
								Navigator.of(context).popUntil(
									ModalRoute.withName('/')
								);
							}
						},
					),
				],
			),
			body: Padding(
				padding: const EdgeInsets.all(16),
				child: SingleChildScrollView(
					child: _isLoading
					? const Center(child: CircularProgressIndicator(),)
					: Column(
						children: [
							Form(
								key: _form,
								child: Column(
									children: <Widget>[
										Row(
											children: [
												Expanded(
													child: TextFormField(
														initialValue: _initValues['name'],
														decoration: const InputDecoration(labelText: 'Title',),
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
																displayId: _editedEntry.displayId,
																complexity: _editedEntry.complexity,
																difficulty: _editedEntry.difficulty,
																prepTimeMins: _editedEntry.prepTimeMins,
																cookTimeMins: _editedEntry.cookTimeMins,
																servings: _editedEntry.servings,
                                rating: _editedEntry.rating,
																images: _editedEntry.images,
																tagIds: _editedEntry.tagIds,
                                notes: _editedEntry.notes,
															);
														},
													),
												),
												const SizedBox(width: 10,),
												Expanded(
													child: TextFormField(
														initialValue: _initValues['displayId'],
														decoration: const InputDecoration(labelText: 'Entry ID',),
														textInputAction: TextInputAction.next,
														validator: (value) {
															if (value == null) {
																return 'Please provide a value';
															}
															if (value.isEmpty) {
																return 'Please provide a value';
															}

															if (providerRc.isDisplayIdAlreadyUsed(value, _editedEntry.id)) {
																return "'$value' is already used. Try another.";
															}

															return null;
														},
														onSaved: (value) {
															_editedEntry = RecipeEntry(
																id: _editedEntry.id,
																name: _editedEntry.name,
																displayId: value!,
																complexity: _editedEntry.complexity,
																difficulty: _editedEntry.difficulty,
																prepTimeMins: _editedEntry.prepTimeMins,
																cookTimeMins: _editedEntry.cookTimeMins,
																servings: _editedEntry.servings,
                                rating: _editedEntry.rating,
																images: _editedEntry.images,
																tagIds: _editedEntry.tagIds,
                                notes: _editedEntry.notes,
															);
														},
													),
												),
											],
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
																displayId: _editedEntry.displayId,
																complexity: value!,
																difficulty: _editedEntry.difficulty,
																prepTimeMins: _editedEntry.prepTimeMins,
																cookTimeMins: _editedEntry.cookTimeMins,
																servings: _editedEntry.servings,
                                rating: _editedEntry.rating,
																images: _editedEntry.images,
																tagIds: _editedEntry.tagIds,
                                notes: _editedEntry.notes,
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
																displayId: _editedEntry.displayId,
																complexity: _editedEntry.complexity,
																difficulty: value!,
																prepTimeMins: _editedEntry.prepTimeMins,
																cookTimeMins: _editedEntry.cookTimeMins,
																servings: _editedEntry.servings,
                                rating: _editedEntry.rating,
																images: _editedEntry.images,
																tagIds: _editedEntry.tagIds,
                                notes: _editedEntry.notes,
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
																displayId: _editedEntry.displayId,
																complexity: _editedEntry.complexity,
																difficulty: _editedEntry.difficulty,
																prepTimeMins: int.parse(value!),
																cookTimeMins: _editedEntry.cookTimeMins,
																servings: _editedEntry.servings,
                                rating: _editedEntry.rating,
																images: _editedEntry.images,
																tagIds: _editedEntry.tagIds,
                                notes: _editedEntry.notes,
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
																displayId: _editedEntry.displayId,
																complexity: _editedEntry.complexity,
																difficulty: _editedEntry.difficulty,
																prepTimeMins: _editedEntry.prepTimeMins,
																cookTimeMins: int.parse(value!),
																servings: _editedEntry.servings,
                                rating: _editedEntry.rating,
																images: _editedEntry.images,
																tagIds: _editedEntry.tagIds,
                                notes: _editedEntry.notes,
															);
														},
													),
												),
											],
										),
										TextFormField(
											initialValue: _initValues['servings'].toString(),
											decoration: const InputDecoration(labelText: 'Servings',),
											keyboardType: TextInputType.text,
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
													name: _editedEntry.name,
													displayId: _editedEntry.displayId,
													complexity: _editedEntry.complexity,
													difficulty: _editedEntry.difficulty,
													prepTimeMins: _editedEntry.prepTimeMins,
													cookTimeMins: _editedEntry.cookTimeMins,
													servings: value!,
                          rating: _editedEntry.rating,
													images: _editedEntry.images,
													tagIds: _editedEntry.tagIds,
                          notes: _editedEntry.notes,
												);
											},
										),
                    const SizedBox(height: 10,),
                    TextFormField(
                      initialValue: _initValues['notes'].toString(),
                      decoration: const InputDecoration(labelText: 'Notes',),
                      keyboardType: TextInputType.multiline,
                      minLines: 1,
                      maxLines: 5,
                      maxLength: 256,
                      textInputAction: TextInputAction.newline,
                      onSaved: (value) {
                        _editedEntry = RecipeEntry(
                          id: _editedEntry.id,
                          name: _editedEntry.name,
                          displayId: _editedEntry.displayId,
                          complexity: _editedEntry.complexity,
                          difficulty: _editedEntry.difficulty,
                          prepTimeMins: _editedEntry.prepTimeMins,
                          cookTimeMins: _editedEntry.cookTimeMins,
                          servings: _editedEntry.servings,
                          rating: _editedEntry.rating,
                          images: _editedEntry.images,
                          tagIds: _editedEntry.tagIds,
                          notes: value!,
                        );
                      },
                    ),
                    const SizedBox(height: 10,),
                    const Text('Rating'),
                    RatingBar.builder(
                      initialRating: _initValues['rating'],
                      allowHalfRating: true,
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber
                      ),
                      onRatingUpdate: (rating) {
                        _editedEntry = RecipeEntry(
													id: _editedEntry.id,
													name: _editedEntry.name,
													displayId: _editedEntry.displayId,
													complexity: _editedEntry.complexity,
													difficulty: _editedEntry.difficulty,
													prepTimeMins: _editedEntry.prepTimeMins,
													cookTimeMins: _editedEntry.cookTimeMins,
													servings: _editedEntry.servings,
                          rating: rating,
													images: _editedEntry.images,
													tagIds: _editedEntry.tagIds,
                          notes: _editedEntry.notes,
												);
                      }
                    )
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
						],
					),
				),
			),
		);
	}
}