enum ImageType {
	onPhone,
	fromInternet,
}

class EntryImage {
	int? id;
	final ImageType imageType;
	final String imageLocation;

	EntryImage({this.id, required this.imageLocation, required this.imageType,});
}