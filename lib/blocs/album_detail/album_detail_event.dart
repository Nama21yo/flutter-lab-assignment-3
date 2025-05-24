abstract class AlbumDetailEvent {}

class FetchAlbumDetail extends AlbumDetailEvent {
  final int albumId;

  FetchAlbumDetail({required this.albumId});
}