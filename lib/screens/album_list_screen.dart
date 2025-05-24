import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lab_assignment_3/blocs/album_list/album_list_bloc.dart';
import 'package:flutter_lab_assignment_3/blocs/album_list/album_list_event.dart';
import 'package:flutter_lab_assignment_3/blocs/album_list/album_list_state.dart';
import 'package:flutter_lab_assignment_3/models/album.dart';
import 'package:go_router/go_router.dart';

const Color _appBarColor = Color(0xFF1A237E);
const Color _appBarTextColor = Colors.white;
const Color _scaffoldBackgroundColor = Color(0xFFECEFF1);
const Color _cardColor = Colors.white;
const Color _primaryTextColor = Color(0xFF263238);
const Color _secondaryTextColor = Color(0xFF546E7A);
const Color _accentColor = Color(0xFFFBC02D);
const Color _errorColor = Color(0xFFD32F2F);
const Color _placeholderColor = Color(0xFFB0BEC5);

class AlbumListScreen extends StatelessWidget {
  const AlbumListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          AlbumListBloc(albumRepository: context.read())..add(FetchAlbums()),
      child: Scaffold(
        backgroundColor: _scaffoldBackgroundColor,
        appBar: AppBar(
          title: const Text(
            'Photo Albums',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          backgroundColor: _appBarColor,
          foregroundColor: _appBarTextColor,
          elevation: 4.0,
        ),
        body: BlocBuilder<AlbumListBloc, AlbumListState>(
          builder: (context, state) {
            switch (state.status) {
              case AlbumListStatus.initial:
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: _accentColor),
                      SizedBox(height: 20),
                      Text(
                        'Fetching albums...',
                        style:
                            TextStyle(fontSize: 16, color: _secondaryTextColor),
                      ),
                    ],
                  ),
                );
              case AlbumListStatus.loading:
                return const Center(
                    child: CircularProgressIndicator(color: _accentColor));
              case AlbumListStatus.success:
                if (state.albums.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.photo_library_outlined,
                              size: 60, color: _placeholderColor),
                          const SizedBox(height: 16),
                          const Text(
                            'No Albums Found',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: _primaryTextColor),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'There are currently no albums to display.',
                            style: TextStyle(
                                fontSize: 16, color: _secondaryTextColor),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _accentColor,
                              foregroundColor: _primaryTextColor,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                            ),
                            onPressed: () {
                              context
                                  .read<AlbumListBloc>()
                                  .add(RefreshAlbums());
                            },
                            icon: const Icon(Icons.refresh_rounded),
                            label: const Text('REFRESH'),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return RefreshIndicator(
                  color: _accentColor,
                  backgroundColor: _cardColor,
                  onRefresh: () async {
                    context.read<AlbumListBloc>().add(RefreshAlbums());
                  },
                  child: ListView.builder(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    itemCount: state.albums.length,
                    itemBuilder: (context, index) {
                      final album = state.albums[index];
                      return AlbumListItem(album: album);
                    },
                  ),
                );
              case AlbumListStatus.failure:
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network(
                          'https://cdn-icons-png.flaticon.com/512/2748/2748558.png',
                          height: 120,
                          width: 120,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(
                            Icons.cloud_off_rounded,
                            color: _errorColor,
                            size: 80,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Oops! Something went wrong.',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: _primaryTextColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'We couldn\'t load the albums right now.\nPlease check your internet or try again later.',
                          style: TextStyle(
                            fontSize: 16,
                            color: _secondaryTextColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 28),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _accentColor,
                            foregroundColor: _primaryTextColor,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 14),
                            textStyle: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            context.read<AlbumListBloc>().add(FetchAlbums());
                          },
                          icon: const Icon(Icons.refresh_rounded),
                          label: const Text('Try Again'),
                        ),
                      ],
                    ),
                  ),
                );
            }
          },
        ),
      ),
    );
  }
}

class AlbumListItem extends StatelessWidget {
  final Album album;

  const AlbumListItem({super.key, required this.album});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: _cardColor,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      elevation: 2.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(10.0),
        splashColor: _accentColor.withAlpha(25),
        highlightColor: _accentColor.withAlpha(12),
        onTap: () {
          context.go('/album/${album.id}');
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              album.thumbnailUrl != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        album.thumbnailUrl!,
                        width: 64,
                        height: 64,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              color: _placeholderColor.withAlpha(50),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Icon(Icons.broken_image_outlined,
                                color: _secondaryTextColor.withAlpha(180),
                                size: 32),
                          );
                        },
                      ),
                    )
                  : Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: _placeholderColor.withAlpha(50),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Icon(Icons.photo_album_outlined,
                          color: _secondaryTextColor.withAlpha(180), size: 32),
                    ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      album.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: _primaryTextColor,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Album ID: ${album.id}',
                      style: const TextStyle(
                          fontSize: 14, color: _secondaryTextColor),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.arrow_forward_ios_rounded,
                  size: 18, color: _secondaryTextColor.withAlpha(200)),
            ],
          ),
        ),
      ),
    );
  }
}
