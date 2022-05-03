import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../models/entry_image.dart';
import './entry_image_displayer.dart';

class entryImageCarousel extends StatelessWidget {
	List<EntryImage> imageList;

	entryImageCarousel(this.imageList, { Key? key }) : super(key: key);

	@override
	Widget build(BuildContext context) {
		return CarouselSlider.builder(
			itemCount: imageList.length,
			itemBuilder: (ctx, index, pageViewIndex) {
				var currImage = imageList[index];
				return EntryImageDisplayer(currImage, key: ValueKey(currImage.id));
			},
			options: CarouselOptions(
				enableInfiniteScroll: false,
				autoPlay: false,
			),
		);
	}
}