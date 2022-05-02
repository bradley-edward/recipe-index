import 'dart:io';

import 'package:flutter/material.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';

import '../models/entry_image.dart';
import './entry_image_displayer.dart';
import './image_input.dart';

class ImageListEdit extends StatefulWidget {
	const ImageListEdit({ Key? key }) : super(key: key);

	@override
	State<ImageListEdit> createState() => _ImageListEditState();
}

class _ImageListEditState extends State<ImageListEdit> {
	final _testData = [
		EntryImage('https://images.unsplash.com/photo-1651185693290-90dd10d4ea28', ImageType.fromInternet),
		EntryImage('https://i.imgur.com/OQaAojt.png', ImageType.fromInternet),
	];
	
	Widget _buildItem(String text) {
		return Card(
			key: ValueKey(text),
			child: Text(text),
		);
    }

	@override
	Widget build(BuildContext context) {
		return Column(
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
				Card(
					child: Row(
						children: [
							const Text('Add New Image'),
							ImageInput((EntryImage newImage) {
								setState(() {
									_testData.add(newImage);
								});
							}),
						]
					),
				)
			],
		);
	}
}