import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../models/entry_image.dart';
import './entry_image_displayer.dart';

class entryImageCarousel extends StatelessWidget {
	List<EntryImage> imageList;
	Function onImageDblTap;

	entryImageCarousel({required this.imageList, required this.onImageDblTap, Key? key }) : super(key: key);

	@override
	Widget build(BuildContext context) {
		return CarouselSlider.builder(
			itemCount: imageList.length,
			itemBuilder: (ctx, index, pageViewIndex) {
				var currImage = imageList[index];
				return InkWell(
					key: ValueKey(currImage.id),
					child: Hero(
						tag: currImage.id!,
						child: EntryImageDisplayer(currImage),
					),
					onDoubleTap: () {
						onImageDblTap(currImage);
					},
				);
			},
			options: CarouselOptions(
				enableInfiniteScroll: false,
				autoPlay: false,
				enlargeCenterPage: true,
				viewportFraction: 0.5
			),
		);
	}
}