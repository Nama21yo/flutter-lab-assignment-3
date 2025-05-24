import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_lab_assignment_3/blocs/album_detail/album_detail_bloc.dart';
import 'package:flutter_lab_assignment_3/blocs/album_detail/album_detail_event.dart';
import 'package:flutter_lab_assignment_3/blocs/album_detail/album_detail_state.dart';
import 'package:flutter_lab_assignment_3/models/photo.dart'; // Assuming Photo model is here

// --- Color Palette (Applied inline for this example) ---
const Color _appBarColor = Color(0xFF1A237E); // Indigo Dark
const Color _appBarTextColor = Colors.white;
const Color _scaffoldBackgroundColor = Color(0xFFECEFF1); // Blue Grey Light
const Color _cardColor = Colors.white;
const Color _primaryTextColor = Color(0xFF263238); // Blue Grey Dark
const Color _secondaryTextColor = Color(0xFF546E7A); // Blue Grey Medium
const Color _accentColor = Color(0xFFFBC02D); // Yellow/Amber
const Color _errorColor = Color(0xFFD32F2F); // Red
const Color _placeholderColor = Color(0xFFB0BEC5); // Blue Grey Light/Medium

class AlbumDetailScreen extends StatelessWidget {
  final int albumId;

  const AlbumDetailScreen({Key? key, required this.albumId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AlbumDetailBloc(
        albumRepository: context.read(),
      )..add(FetchAlbumDetail(albumId: albumId)),
      child: Scaffold(
        backgroundColor: _scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: _appBarColor,
          foregroundColor: _appBarTextColor,
          elevation: 4.0,
          leading: IconButton(
            icon: const Icon(
                Icons.arrow_back_ios_new_rounded), // Modern back icon
            onPressed: () {
              context.go('/');
            },
          ),
          title: BlocBuilder<AlbumDetailBloc, AlbumDetailState>(
            buildWhen: (previous, current) =>
                previous.album?.title != current.album?.title,
            builder: (context, state) {
              return Text(
                state.album?.title ?? 'Album Details',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18, // Adjusted for potentially long titles
                ),
                overflow: TextOverflow.ellipsis,
              );
            },
          ),
        ),
        body: BlocBuilder<AlbumDetailBloc, AlbumDetailState>(
          builder: (context, state) {
            switch (state.status) {
              case AlbumDetailStatus.initial:
              case AlbumDetailStatus.loading:
                return const Center(
                    child: CircularProgressIndicator(color: _accentColor));
              case AlbumDetailStatus.success:
                return _buildAlbumDetail(context, state);
              case AlbumDetailStatus.failure:
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline_rounded,
                            color: _errorColor, size: 60),
                        const SizedBox(height: 20),
                        const Text(
                          'Oops! Something Went Wrong',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: _primaryTextColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          state.errorMessage,
                          style: const TextStyle(
                              fontSize: 16, color: _secondaryTextColor),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _accentColor,
                            foregroundColor:
                                _primaryTextColor, // Dark text on light accent
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                            textStyle: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            context.read<AlbumDetailBloc>().add(
                                  FetchAlbumDetail(albumId: albumId),
                                );
                          },
                          icon: const Icon(Icons.refresh_rounded),
                          label: const Text('RETRY'),
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

  Widget _buildAlbumDetail(BuildContext context, AlbumDetailState state) {
    final album = state.album;
    if (album == null) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Text(
            'Album not found.',
            style: TextStyle(fontSize: 18, color: _secondaryTextColor),
          ),
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  album.title,
                  style: const TextStyle(
                    fontSize: 26, // Larger title
                    fontWeight: FontWeight.bold,
                    color: _primaryTextColor,
                    height: 1.3, // Line height
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.perm_identity_rounded,
                        color: _secondaryTextColor, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      'User ID: ${album.userId}',
                      style: const TextStyle(
                          fontSize: 15, color: _secondaryTextColor),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.album_rounded,
                        color: _secondaryTextColor, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      'Album ID: ${album.id}',
                      style: const TextStyle(
                          fontSize: 15, color: _secondaryTextColor),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // ignore: deprecated_member_use
                Divider(color: _placeholderColor.withOpacity(0.5)),
                const SizedBox(height: 16),
                const Text(
                  'Photos in this Album',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600, // Semi-bold
                    color: _primaryTextColor,
                  ),
                ),
              ],
            ),
          ),
          state.photos.isEmpty
              ? const Center(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.photo_library_outlined,
                            size: 60, color: _placeholderColor),
                        SizedBox(height: 12),
                        Text(
                          'No photos found for this album.',
                          style: TextStyle(
                              fontSize: 17, color: _secondaryTextColor),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                )
              : GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(
                      20, 0, 20, 20), // Adjusted padding
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: MediaQuery.of(context).size.width > 600
                        ? 3
                        : 2, // Responsive columns
                    childAspectRatio:
                        0.9, // Adjusted aspect ratio for more space for title
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: state.photos.length,
                  itemBuilder: (context, index) {
                    final photo = state.photos[index];
                    return PhotoGridItem(photo: photo);
                  },
                ),
        ],
      ),
    );
  }
}

class PhotoGridItem extends StatelessWidget {
  final Photo photo;

  const PhotoGridItem({Key? key, required this.photo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: _cardColor,
      clipBehavior: Clip.antiAlias, // Important for rounded corners on images
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0), // Softer corners
      ),
      elevation: 3.0, // Subtle shadow
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch, // Stretch children
        children: [
          Expanded(
            flex: 3, // Give more space to image
            child: Image.network(
              photo
                  .thumbnailUrl, // Use thumbnail for grid, full URL for detail if available
              fit: BoxFit.cover,
              // Loading builder can be added if you want a placeholder while image loads
              // loadingBuilder: (context, child, loadingProgress) {
              //   if (loadingProgress == null) return child;
              //   return Center(child: CircularProgressIndicator(color: _accentColor, value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null));
              // },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  // ignore: deprecated_member_use
                  color: _placeholderColor.withOpacity(0.2),
                  child: Center(
                      child: Icon(Icons.broken_image_outlined,
                          // ignore: deprecated_member_use
                          color: _secondaryTextColor.withOpacity(0.7),
                          size: 40)),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0), // Slightly more padding
            child: Text(
              photo.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500, // Medium weight
                color: _primaryTextColor,
                height: 1.2, // Line height for readability
              ),
            ),
          ),
        ],
      ),
    );
  }
}
