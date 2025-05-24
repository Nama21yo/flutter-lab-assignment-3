import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_lab_assignment_3/models/album.dart';
import 'package:flutter_lab_assignment_3/models/photo.dart';

class AlbumRepository {
  final http.Client httpClient;
  final String _baseUrl = 'https://jsonplaceholder.typicode.com';

  AlbumRepository({required this.httpClient});

  Future<List<Album>> getAlbums() async {
    try {
      final albumResponse = await httpClient.get(
        Uri.parse('$_baseUrl/albums'),
      );

      if (albumResponse.statusCode != 200) {
        throw Exception('Failed to load albums');
      }

      final List<dynamic> albumsJson = json.decode(albumResponse.body);
      final List<Album> albums = albumsJson
          .map((albumJson) => Album.fromJson(albumJson))
          .toList();

      // Fetch photos to get thumbnails for albums
      final photoResponse = await httpClient.get(
        Uri.parse('$_baseUrl/photos'),
      );

      if (photoResponse.statusCode != 200) {
        throw Exception('Failed to load photos');
      }

      final List<dynamic> photosJson = json.decode(photoResponse.body);
      final List<Photo> photos = photosJson
          .map((photoJson) => Photo.fromJson(photoJson))
          .toList();

      // Match first photo of each album as thumbnail
      for (var album in albums) {
        final albumPhotos = photos.where((photo) => photo.albumId == album.id);
        if (albumPhotos.isNotEmpty) {
          album.thumbnailUrl = albumPhotos.first.thumbnailUrl;
        }
      }

      return albums;
    } catch (e) {
      throw Exception('Failed to fetch data: $e');
    }
  }

  Future<List<Photo>> getPhotosByAlbumId(int albumId) async {
    try {
      final response = await httpClient.get(
        Uri.parse('$_baseUrl/photos?albumId=$albumId'),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to load photos for album');
      }

      final List<dynamic> photosJson = json.decode(response.body);
      return photosJson
          .map((photoJson) => Photo.fromJson(photoJson))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch album photos: $e');
    }
  }

  Future<Album> getAlbumById(int id) async {
    try {
      final response = await httpClient.get(
        Uri.parse('$_baseUrl/albums/$id'),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to load album details');
      }

      final albumJson = json.decode(response.body);
      final album = Album.fromJson(albumJson);

      // Get the first photo for the album thumbnail
      final photos = await getPhotosByAlbumId(id);
      if (photos.isNotEmpty) {
        album.thumbnailUrl = photos.first.thumbnailUrl;
      }

      return album;
    } catch (e) {
      throw Exception('Failed to fetch album details: $e');
    }
  }
}