import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_lab_assignment_3/repositories/album_repository.dart';
import 'package:flutter_lab_assignment_3/router/app_router.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final AlbumRepository albumRepository = AlbumRepository(
    httpClient: http.Client(),
  );

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: albumRepository,
      child: MaterialApp.router(
        title: 'Album Viewer',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        routerConfig: AppRouter.router,
      ),
    );
  }
}
