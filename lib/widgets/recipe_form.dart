import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/recipe_collection.dart';
import '../models/recipe_entry.dart';

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
	);

	var _initValues = {
		'entryId': '',
		'name': '',
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
			};
		}
	}

	@override
	void dispose() {
		super.dispose();
	}

	void _saveForm() {
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
			collectionProvider.updateEntry(_editedEntry.id!, _editedEntry,);
		} else {
			// Add new entry
			collectionProvider.addEntry(_editedEntry);
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
		: Form(
			key: _form,
			child: ListView(
				children: <Widget>[
					TextFormField(
						initialValue: _initValues['entryId'],
						decoration: const InputDecoration(labelText: 'Entry ID',),
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
							);
						},
					),
					const SizedBox(height: 50,),
					ElevatedButton.icon(
						onPressed: _saveForm,
						icon: const Icon(Icons.save),
						label: const Text('Submit')
					),
				],
			),
		);
	}
}