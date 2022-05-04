import 'package:flutter/material.dart';

class ImageUrlModal extends StatefulWidget {
	const ImageUrlModal({ Key? key }) : super(key: key);

	@override
	State<ImageUrlModal> createState() => _ImageUrlModalState();
}

class _ImageUrlModalState extends State<ImageUrlModal> {
	final _form = GlobalKey<FormState>();
	String _inputImageUrl = '';

	var _hasError = false;
	
	void _saveForm() {
		var currentFormState = _form.currentState;
		if (currentFormState == null) {
			return;
		}

		final isValid = currentFormState.validate() && !_hasError;
		if (!isValid) {
			return;
		}

		Navigator.of(context).pop(_inputImageUrl);
	}

	@override
	Widget build(BuildContext context) {
		return Container(
			height: 400,
			width: double.infinity,
			padding: const EdgeInsets.all(20),
			child: Column(
				mainAxisAlignment: MainAxisAlignment.start,
				children: [
					Form(
						key: _form,
						child: Row(
							mainAxisAlignment: MainAxisAlignment.center,
							children: [
								Expanded(
									child: TextFormField(
										decoration: const InputDecoration(
											labelText: 'Image URL here',
										),
										validator: (value) {
											if (value == null) {
												return 'Please provide a value';
											}
											if (value.isEmpty) {
												return 'Please provide a value';
											}
											return null;
										},
										onFieldSubmitted: (value) {
											setState(() {
												_inputImageUrl = value;
											});
											FocusScope.of(context).unfocus();
										},
									),
								),
								const SizedBox(width: 20),
								ElevatedButton.icon(
									icon: const Icon(Icons.add),
									label: const Text('Submit'),
									onPressed: _saveForm,
								)
							],
						)
					),
					const SizedBox(height: 10,),
					if (_inputImageUrl.isNotEmpty) Expanded(
						child: Image.network(
							_inputImageUrl,
							loadingBuilder: (context, child, loadingProgress) {
								if (loadingProgress == null) {
									_hasError = false;
									return child;
								}
								return Center(
									child: CircularProgressIndicator(
										value: loadingProgress.expectedTotalBytes != null
										? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
										: null,
									),
								);
							},
							errorBuilder: (context, error, _) {
								_hasError = true;
								return Center(
									child: Text(
										'Something is wrong with the provided image URL.',
										style: TextStyle(
											color: Theme.of(context).errorColor,
										),
									),
								);
							},
						),
					),
				],
			),
		);
	}
}