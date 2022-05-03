import 'dart:io';

import 'package:flutter/material.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';

import '../models/entry_image.dart';
import './entry_image_displayer.dart';
import './image_input.dart';

class ImageListEdit extends StatefulWidget {
	Function onUpdateList;
	List<EntryImage> initialList;

	ImageListEdit({ Key? key, required this.onUpdateList, required this.initialList, }) : super(key: key);

	@override
	State<ImageListEdit> createState() => _ImageListEditState();
}

class _ImageListEditState extends State<ImageListEdit> {
	final List<EntryImage> _testData = [];

	@override
	void initState() {
		super.initState();
		_testData.addAll(widget.initialList);
	}
	

	@override
	Widget build(BuildContext context) {
		return Column(
			crossAxisAlignment: CrossAxisAlignment.end,
			children: [
				Container(
					height: 240,
					width: double.infinity,
					decoration: BoxDecoration(
						border: Border.all(
							color: Colors.red,
							width: 2.0,
						)
					),
					child: Center(
						child: ReorderableGridView.count(
							crossAxisCount: 4,
							crossAxisSpacing: 5,
							mainAxisSpacing: 5,
							onReorder: ((oldIdx, newIdx) {
								setState(() {
									final element = _testData.removeAt(oldIdx);
									_testData.insert(newIdx, element);
								});
								widget.onUpdateList(_testData);
							}),
							children: _testData.map((imageItem) {
								return Card(
									key:  ValueKey(imageItem.imageLocation,),
									child: EntryImageDisplayer(imageItem,),
								);
							}).toList(),
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