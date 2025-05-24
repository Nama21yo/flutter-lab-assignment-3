import 'package:flutter_lab_assignment_3/models/album.dart';
import 'package:flutter_lab_assignment_3/models/photo.dart';
enum AlbumDetailStatus { initial, loading, success, failure }

class AlbumDetailState {
  final AlbumDetailStatus status;
  final Album? album;
  final List<Photo> photos;
  final String errorMessage;

  AlbumDetailState({
    this.status = AlbumDetailStatus.initial,
    this.album,
    this.photos = const <Photo>[],
    this.errorMessage = '',
  });

  AlbumDetailState copyWith({
    AlbumDetailStatus? status,
    Album? album,
    List<Photo>? photos,
    String? errorMessage,
  }) {
    return AlbumDetailState(
      status: status ?? this.status,
      album: album ?? this.album,
      photos: photos ?? this.photos,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}