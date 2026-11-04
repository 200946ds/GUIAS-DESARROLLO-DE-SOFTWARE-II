
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/post.dart';
import '../models/comment.dart';

class ApiService {
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com';

  final http.Client _client;

  ApiService({http.Client? client})
      : _client = client ?? http.Client();

  // GET: Obtener todos los posts
  Future<List<Post>> getPosts() async {
    final uri = Uri.parse('$_baseUrl/posts');
    final response = await _client.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Post.fromJson(json)).toList();
    } else {
      throw ApiException(
        statusCode: response.statusCode,
        message: 'Error al obtener posts',
      );
    }
  }

  // GET: Obtener un post por ID
  Future<Post> getPostById(int id) async {
    final uri = Uri.parse('$_baseUrl/posts/$id');
    final response = await _client.get(uri);

    if (response.statusCode == 200) {
      return Post.fromJson(json.decode(response.body));
    } else if (response.statusCode == 404) {
      throw ApiException(statusCode: 404, message: 'Post no encontrado');
    } else {
      throw ApiException(
        statusCode: response.statusCode,
        message: 'Error inesperado',
      );
    }
  }

  // POST: Crear un nuevo post
  Future<Post> createPost({
    required String title,
    required String body,
    required int userId,
  }) async {
    final uri = Uri.parse('$_baseUrl/posts');
    final response = await _client.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'title': title,
        'body': body,
        'userId': userId,
      }),
    );

    if (response.statusCode == 201) {
      return Post.fromJson(json.decode(response.body));
    } else {
      throw ApiException(
        statusCode: response.statusCode,
        message: 'Error al crear el post',
      );
    }
  }

  // PUT: Actualizar un post
  Future<Post> updatePost(Post post) async {
    final uri = Uri.parse('$_baseUrl/posts/${post.id}');
    final response = await _client.put(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(post.toJson()),
    );

    if (response.statusCode == 200) {
      return Post.fromJson(json.decode(response.body));
    } else {
      throw ApiException(
        statusCode: response.statusCode,
        message: 'Error al actualizar el post',
      );
    }
  }

  // DELETE: Eliminar un post
  Future<void> deletePost(int id) async {
    final uri = Uri.parse('$_baseUrl/posts/$id');
    final response = await _client.delete(uri);

    if (response.statusCode != 200) {
      throw ApiException(
        statusCode: response.statusCode,
        message: 'Error al eliminar el post',
      );
    }
  }

  // GET: Comentarios de un post
  Future<List<Comment>> getCommentsByPost(int postId) async {
    final uri = Uri.parse('$_baseUrl/posts/$postId/comments');
    final response = await _client.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((j) => Comment.fromJson(j)).toList();
    } else {
      throw ApiException(
        statusCode: response.statusCode,
        message: 'Error al obtener comentarios',
      );
    }
  }

  // GET: Posts con paginación
  Future<List<Post>> getPostsPaginated({
    int page = 1,
    int limit = 20,
  }) async {
    final uri = Uri.parse('$_baseUrl/posts').replace(
      queryParameters: {
        '_page': page.toString(),
        '_limit': limit.toString(),
      },
    );

    final response = await _client.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Post.fromJson(json)).toList();
    } else {
      throw ApiException(
        statusCode: response.statusCode,
        message: 'Error al obtener posts paginados',
      );
    }
  }

  void dispose() => _client.close();
}

// Excepción personalizada
class ApiException implements Exception {
  final int statusCode;
  final String message;

  const ApiException({
    required this.statusCode,
    required this.message,
  });

  @override
  String toString() => 'ApiException[$statusCode]: $message';
}
