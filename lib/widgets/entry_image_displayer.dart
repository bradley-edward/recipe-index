import 'dart:io';

import 'package:flutter/material.dart';

import '../models/entry_image.dart';

class EntryImageDisplayer extends StatelessWidget {
	EntryImage imageItem;

	EntryImageDisplayer(this.imageItem, { Key? key }) : super(key: key);

	@override
	Widget build(BuildContext context) {
		switch (imageItem.imageType) {
			case ImageType.fromInternet:
				return Image.network(
					imageItem.imageLocation,
					loadingBuilder: (context, child, loadingProgress) {
						if (loadingProgress == null) return child;
						return Center(
							child: CircularProgressIndicator(
								value: loadingProgress.expectedTotalBytes != null
								? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
								: null,
							),
						);
					},
				);
			case ImageType.onPhone:
				return Image.file(
					File(imageItem.imageLocation,),
					key: ValueKey(imageItem.imageLocation),
				);
		}
	}
}