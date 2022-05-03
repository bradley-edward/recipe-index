enum ImageType {
	onPhone,
	fromInternet,
}

class EntryImage {
	final String? id;
	final ImageType imageType;
	final String imageLocation;

	EntryImage({this.id, required this.imageLocation, required this.imageType,});
}