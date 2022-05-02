enum ImageType {
	onPhone,
	fromInternet,
}

class EntryImage {
	final ImageType imageType;
	final String imageLocation;

	EntryImage(this.imageLocation, this.imageType);
}