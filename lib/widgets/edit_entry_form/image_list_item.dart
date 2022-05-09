import 'package:flutter/material.dart';

import '../../models/entry_image.dart';
import '../entry_image_displayer.dart';

class ImageListItem extends StatelessWidget {
	final EntryImage imageData;
	final bool toBeDeleted;
	final VoidCallback markToBeDeleted;

	const ImageListItem({required this.imageData, required this.toBeDeleted, required this.markToBeDeleted, Key? key }) : super(key: key);

	@override
	Widget build(BuildContext context) {
		return LayoutBuilder(
			builder: ((ctx, constraints) {
				return Stack(
					children: [
						Positioned(
							bottom: 0,
							left: 0,
							child: Container(
								height: (constraints.maxHeight * 0.95),
								width: constraints.maxWidth * 0.95,
								child: Card(
									color: imageData.id == null
									? const Color.fromARGB(255, 167, 243, 167)
									: toBeDeleted
									? const Color.fromARGB(255, 243, 167, 167)
									: null,
									child: Center(
										child: Container(
											padding: const EdgeInsets.all(5),
											child: EntryImageDisplayer(imageData,),
										),
									),
								),
							),
						),
						Positioned(
							top: 0.5,
							right: 0.5,
							child: Container(
								height: 30,
								width: 30,
								decoration: BoxDecoration(
									color: Colors.black,
									borderRadius: BorderRadius.circular(15),
								),
								child: IconButton(
									color: Colors.white,
									icon: const Icon(Icons.highlight_off),
									padding: EdgeInsets.zero,
									constraints: const BoxConstraints(),
									onPressed: markToBeDeleted,
								),
							),
						),
					],
				);
			}),
		);
	}
}