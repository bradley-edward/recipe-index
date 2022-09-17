import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

import '../models/entry_image.dart';

ImageProvider getImageProvider(EntryImage entryImg) {
	switch (entryImg.imageType) {
		case ImageType.fromInternet:
			return NetworkImage(entryImg.imageLocation);
		case ImageType.onPhone:
			return FileImage(File(entryImg.imageLocation));
	}
}

class ImageViewScreen extends StatelessWidget {
	static const routeName = '/image-view';

	const ImageViewScreen({Key? key}) : super(key: key);

	@override
	Widget build(BuildContext context) {
		final entryImage = ModalRoute.of(context)!.settings.arguments as EntryImage;

		return Container(
			height: double.infinity,
			width: double.infinity,
			child: Hero(
				tag: entryImage.id!,
				child: PhotoView(
					imageProvider: getImageProvider(entryImage)
				),
			),
		);
	}
}