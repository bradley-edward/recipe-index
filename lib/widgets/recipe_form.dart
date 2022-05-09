import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/entry_image.dart';
import '../providers/recipe_collection.dart';
import '../models/recipe_entry.dart';
import './image_list_edit.dart';

class RecipeForm extends StatefulWidget {
	final String? inputId;

	const RecipeForm({this.inputId, Key? key }) : super(key: key);

	@override
	State<RecipeForm> createState() => _RecipeFormState();
}

class _RecipeFormState extends State<RecipeForm> {
	final _form = GlobalKey<FormState>();

	var _editedEntry = RecipeEntry(
		id: null,
		entryId: '',
		name: '',
		images: [],
	);
	var _imagesToDelete = <String>{};
	var _initValues = <String, dynamic>{
		'entryId': '',
		'name': '',
		'images': <EntryImage>[],
	};

	var _isLoading = false;
	
	@override
	void initState() {
		super.initState();
		if (widget.inputId != null) {
			_editedEntry = Provider.of<RecipeCollection>(context, listen: false).findById(widget.inputId!);
			_initValues = {
				'entryId': _editedEntry.entryId,
				'name': _editedEntry.name,
				'images': _editedEntry.images,
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
										images: _editedEntry.images,
									);
								},
							),
							Row(
								children: [
									Expanded(
										child: DropdownButtonFormField(
											decoration: const InputDecoration(
												label: Text('Complexity'),
											),
											items: <String>['Simple', 'Moderate', 'Complex'].map((String value) =>
												DropdownMenuItem(
													value: value,
													child: Text(value),
												)
											).toList(),
											onChanged: (String? newVal) {
												print(newVal);
											}
										),
									),
									const SizedBox(width: 10,),
									Expanded(
										child: DropdownButtonFormField(
											decoration: const InputDecoration(
												label: Text('Difficulty'),
											),
											items: <String>['Easy', 'Medium', 'Difficult'].map((String value) =>
												DropdownMenuItem(
													value: value,
													child: Text(value),
												)
											).toList(),
											onChanged: (String? newVal) {
												print(newVal);
											}
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