import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lab_assignment_3/blocs/album_detail/album_detail_event.dart';
import 'package:flutter_lab_assignment_3/blocs/album_detail/album_detail_state.dart';
import 'package:flutter_lab_assignment_3/repositories/album_repository.dart';
class AlbumDetailBloc extends Bloc<AlbumDetailEvent, AlbumDetailState> {
  final AlbumRepository albumRepository;

  AlbumDetailBloc({required this.albumRepository})
      : super(AlbumDetailState()) {
    on<FetchAlbumDetail>(_onFetchAlbumDetail);
  }

  Future<void> _onFetchAlbumDetail(
    FetchAlbumDetail event,
    Emitter<AlbumDetailState> emit,
  ) async {
    emit(state.copyWith(status: AlbumDetailStatus.loading));

    try {
      final album = await albumRepository.getAlbumById(event.albumId);
      final photos = await albumRepository.getPhotosByAlbumId(event.albumId);

      emit(state.copyWith(
        status: AlbumDetailStatus.success,
        album: album,
        photos: photos,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AlbumDetailStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}