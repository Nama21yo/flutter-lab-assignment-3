import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_lab_assignment_3/screens/album_list_screen.dart';
import 'package:flutter_lab_assignment_3/screens/album_detail_screen.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const AlbumListScreen(),
      ),
      GoRoute(
        path: '/album/:id',
        builder: (context, state) {
          final albumId = int.parse(state.pathParameters['id']!);
          return AlbumDetailScreen(albumId: albumId);
        },
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(
        child: Text('Page not found: ${state.error}'),
      ),
    ),
  );
}
