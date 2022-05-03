import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;

import '../models/entry_image.dart';

class ImageInput extends StatelessWidget {
	final Function onSelectImage;

	ImageInput(this.onSelectImage);

	Future<void> _takePicture(ImageSource imgSrc) async {
		final picker = ImagePicker();
		final imageXFile = await picker.pickImage(
			source: imgSrc,
			maxWidth: 600,
		);
		if (imageXFile == null) {
			return;
		}

		final imageFile = File(imageXFile.path);

		final appDir = await syspaths.getApplicationDocumentsDirectory();
		final fileName = path.basename(imageFile.path);
		final savedImage = await imageFile.copy('${appDir.path}/$fileName');
		onSelectImage(EntryImage(imageLocation: savedImage.path, imageType: ImageType.onPhone));
	}

	@override
	Widget build(BuildContext context) {
		return Column(
			mainAxisAlignment: MainAxisAlignment.center,
			children: <Widget>[
				TextButton.icon(
					icon: const Icon(Icons.language),
					label: const Text('Image URL'),
					style: TextButton.styleFrom(
						primary: Theme.of(context).primaryColor,
					),
					onPressed: () {},
				),
				TextButton.icon(
					icon: const Icon(Icons.image),
					label: const Text('Gallery'),
					style: TextButton.styleFrom(
						primary: Theme.of(context).primaryColor,
					),
					onPressed: () {
						_takePicture(ImageSource.gallery);
					},
				),
				TextButton.icon(
					icon: const Icon(Icons.camera),
					label: const Text('Camera'),
					style: TextButton.styleFrom(
						primary: Theme.of(context).primaryColor,
					),
					onPressed: () {
						_takePicture(ImageSource.camera);
					},
				),
			],
		);
	}
}