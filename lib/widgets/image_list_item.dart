import 'package:flutter/material.dart';

import '../models/entry_image.dart';
import './entry_image_displayer.dart';

class ImageListItem extends StatelessWidget {
	final EntryImage imageData;
	final bool toBeDeleted;

	const ImageListItem({required this.imageData, required this.toBeDeleted, Key? key }) : super(key: key);

	@override
	Widget build(BuildContext context) {
		return Card(
			child: Center(
				child: Container(
					padding: const EdgeInsets.all(8),
					decoration: BoxDecoration(
						color: imageData.id == null
						? const Color.fromARGB(80, 0, 240, 0)
						: toBeDeleted
						? const Color.fromARGB(80, 240, 0, 0)
						: null
					),
					child: EntryImageDisplayer(imageData,),
				),
			),
		);
	}
}