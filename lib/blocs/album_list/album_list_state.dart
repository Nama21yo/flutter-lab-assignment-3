import 'package:flutter_lab_assignment_3/models/album.dart';

enum AlbumListStatus { initial, loading, success, failure }

class AlbumListState {
  final AlbumListStatus status;
  final List<Album> albums;
  final String errorMessage;

  AlbumListState({
    this.status = AlbumListStatus.initial,
    this.albums = const <Album>[],
    this.errorMessage = '',
  });

  AlbumListState copyWith({
    AlbumListStatus? status,
    List<Album>? albums,
    String? errorMessage,
  }) {
    return AlbumListState(
      status: status ?? this.status,
      albums: albums ?? this.albums,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}