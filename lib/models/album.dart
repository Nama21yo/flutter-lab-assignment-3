class Album {
  final int id;
  final int userId;
  final String title;
  String? thumbnailUrl;

  Album({
    required this.id,
    required this.userId,
    required this.title,
    this.thumbnailUrl,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      id: json['id'],
      userId: json['userId'],
      title: json['title'],
    );
  }
}