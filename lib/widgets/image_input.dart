import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
/*
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;
*/

class ImageInput extends StatefulWidget {
	final Function onSelectImage;

	ImageInput(this.onSelectImage);

	@override
	State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
	File? _storedImage;

	Future<void> _takePicture() async {
		final picker = ImagePicker();
		final imageXFile = await picker.pickImage(
			source: ImageSource.camera,
			maxWidth: 600,
		);
		if (imageXFile == null) {
			return;
		}

		final imageFile = File(imageXFile.path);
		setState(() {
			_storedImage = imageFile;
		});

		//final appDir = await syspaths.getApplicationDocumentsDirectory();
		//final fileName = path.basename(imageFile.path);
		//final savedImage = await imageFile.copy('${appDir.path}/$fileName');
		//widget.onSelectImage(savedImage);
	}

	@override
	Widget build(BuildContext context) {
		return Row(
			children: <Widget>[
				Container(
					width: 150,
					height: 100,
					decoration: BoxDecoration(
						border: Border.all(width: 1, color: Colors.grey),
					),
					child: _storedImage != null
					? Image.file(_storedImage!, fit: BoxFit.cover, width: double.infinity,)
					: const Text('No Image', textAlign: TextAlign.center,),
					alignment: Alignment.center,
				),
				const SizedBox(width: 10,),
				Expanded(
					child: TextButton.icon(
						icon: const Icon(Icons.camera),
						label: const Text('Take Picture'),
						style: TextButton.styleFrom(
							primary: Theme.of(context).primaryColor,
						),
						onPressed: _takePicture,
					)
				),
			],
		);
	}
}