enum ImageType {
	onPhone,
	fromInternet,
}

class EntryImage {
  static const localImagesDirName = 'local_images';

	int? id;
	final ImageType imageType;
	final String imageLocation;

	EntryImage({this.id, required this.imageLocation, required this.imageType,});
}