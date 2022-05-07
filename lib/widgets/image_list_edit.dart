import 'package:flutter/material.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';

import '../models/entry_image.dart';
import './image_input.dart';
import './image_list_item.dart';

class ImageListEdit extends StatefulWidget {
	Function onUpdateList;
	List<EntryImage> initialList;

	ImageListEdit({ Key? key, required this.onUpdateList, required this.initialList, }) : super(key: key);

	@override
	State<ImageListEdit> createState() => _ImageListEditState();
}

class _ImageListEditState extends State<ImageListEdit> {
	final List<EntryImage> _testData = [];
	final _imagesToDelete = <String>{};

	@override
	void initState() {
		super.initState();
		for (final image in widget.initialList) {
			_testData.add(image);
		}
	}

	@override
	Widget build(BuildContext context) {
		return Column(
			crossAxisAlignment: CrossAxisAlignment.end,
			children: [
				Container(
					height: 240,
					width: double.infinity,
					decoration: const BoxDecoration(
						border: Border.symmetric(
							horizontal: BorderSide(
								color: Colors.black54,
								width: 1,
							)
						)
					),
					child: Padding(
						padding: const EdgeInsets.all(2),
						child: ReorderableGridView.count(
							crossAxisCount: 4,
							crossAxisSpacing: 4,
							mainAxisSpacing: 4,
							onReorder: ((oldIdx, newIdx) {
								setState(() {
									final element = _testData.removeAt(oldIdx);
									_testData.insert(newIdx, element);
								});
								widget.onUpdateList(_testData);
							}),
							children: _testData.map((imageData) => ImageListItem(
								key: ValueKey( imageData.id ?? imageData.imageLocation ),
								imageData: imageData,
								toBeDeleted: _imagesToDelete.contains(imageData.id),
								markToBeDeleted: () {
									if (imageData.id == null) {
										setState(() {
											_testData.removeWhere((entry) => entry == imageData);
										});
										widget.onUpdateList(_testData);
									} else {
										setState(() {
											if (_imagesToDelete.contains(imageData.id)) {
												_imagesToDelete.remove(imageData.id);
											} else {
												_imagesToDelete.add(imageData.id!);
											}
										});
										widget.onUpdateList(_testData, _imagesToDelete);
									}
								},
							)).toList(),
						),
					),
				),
				Container(
					width: 240,
					child: Card(
						child: Row(
							children: [
								const Center(
									child: Text('Add New Image'),
								),
								ImageInput((EntryImage newImage) {
									setState(() {
										_testData.add(newImage);
									});
									widget.onUpdateList(_testData);
								}),
							]
						),
					),
				)
			],
		);
	}
}