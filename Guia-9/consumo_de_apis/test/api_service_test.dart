import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'dart:convert';

import 'package:consumo_de_apis/services/api_service.dart';

void main() {
  group('ApiService', () {
    test('getPosts devuelve lista de posts cuando status 200', () async {
      // Mock del cliente HTTP
      final mockClient = MockClient((request) async {
        return http.Response(
          json.encode([
            {
              'userId': 1,
              'id': 1,
              'title': 'Post de prueba',
              'body': 'Contenido de prueba'
            }
          ]),
          200,
        );
      });

      final apiService = ApiService(client: mockClient);
      final posts = await apiService.getPosts();

      expect(posts.length, 1);
      expect(posts.first.title, 'Post de prueba');
      expect(posts.first.id, 1);
    });

    test('getPosts lanza ApiException cuando status no es 200', () async {
      final mockClient = MockClient((request) async {
        return http.Response('Error', 500);
      });

      final apiService = ApiService(client: mockClient);

      expect(
        () => apiService.getPosts(),
        throwsA(isA<ApiException>()),
      );
    });

    test('createPost devuelve el post creado', () async {
      final mockClient = MockClient((request) async {
        return http.Response(
          json.encode({
            'userId': 1,
            'id': 101,
            'title': 'Nuevo post',
            'body': 'Contenido'
          }),
          201,
        );
      });

      final apiService = ApiService(client: mockClient);
      final post = await apiService.createPost(
        title: 'Nuevo post',
        body: 'Contenido',
        userId: 1,
      );

      expect(post.id, 101);
      expect(post.title, 'Nuevo post');
    });
  });
}