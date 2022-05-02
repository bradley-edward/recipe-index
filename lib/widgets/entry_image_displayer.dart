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
				return FadeInImage(
					key: ValueKey(imageItem.imageLocation),
					placeholder: const AssetImage('assets/images/downloading.png'),
					image: NetworkImage(imageItem.imageLocation,),
					fit: BoxFit.cover,
				);
			case ImageType.onPhone:
				return Image.file(
					File(imageItem.imageLocation,),
					key: ValueKey(imageItem.imageLocation),
				);
		}
	}
}