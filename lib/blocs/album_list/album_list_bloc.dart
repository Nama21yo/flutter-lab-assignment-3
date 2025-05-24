import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lab_assignment_3/blocs/album_list/album_list_event.dart';
import 'package:flutter_lab_assignment_3/blocs/album_list/album_list_state.dart';
import 'package:flutter_lab_assignment_3/repositories/album_repository.dart';
class AlbumListBloc extends Bloc<AlbumListEvent, AlbumListState> {
  final AlbumRepository albumRepository;

  AlbumListBloc({required this.albumRepository}) : super(AlbumListState()) {
    on<FetchAlbums>(_onFetchAlbums);
    on<RefreshAlbums>(_onRefreshAlbums);
  }

  Future<void> _onFetchAlbums(
    FetchAlbums event,
    Emitter<AlbumListState> emit,
  ) async {
    if (state.status == AlbumListStatus.loading) return;

    emit(state.copyWith(status: AlbumListStatus.loading));

    try {
      final albums = await albumRepository.getAlbums();
      emit(state.copyWith(
        status: AlbumListStatus.success,
        albums: albums,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AlbumListStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onRefreshAlbums(
    RefreshAlbums event,
    Emitter<AlbumListState> emit,
  ) async {
    emit(state.copyWith(status: AlbumListStatus.loading));

    try {
      final albums = await albumRepository.getAlbums();
      emit(state.copyWith(
        status: AlbumListStatus.success,
        albums: albums,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AlbumListStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}