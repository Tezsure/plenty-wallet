enum MediaType {
  image,
  video,
  text,
}

class InfoStory {
  final String url;
  final Duration duration;
  final String? message;
  final MediaType mediaType;

  const InfoStory({
    required this.url,
    this.duration = const Duration(seconds: 3),
    this.message,
    required this.mediaType,
  });
}
