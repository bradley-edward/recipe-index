import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../models/entry_image.dart';
import './entry_image_displayer.dart';

class entryImageCarousel extends StatelessWidget {
	entryImageCarousel({ Key? key }) : super(key: key);

	final _testData = [
		EntryImage('https://images.unsplash.com/photo-1651185693290-90dd10d4ea28', ImageType.fromInternet),
		EntryImage('https://i.imgur.com/OQaAojt.png', ImageType.fromInternet),
	];

	@override
	Widget build(BuildContext context) {
		return CarouselSlider.builder(
			itemCount: _testData.length,
			itemBuilder: (ctx, index, pageViewIndex) {
				var currImage = _testData[index];
				return EntryImageDisplayer(currImage, key: ValueKey(currImage.imageLocation));
			},
			options: CarouselOptions(
				enableInfiniteScroll: false,
				autoPlay: false,
			),
		);
	}
}