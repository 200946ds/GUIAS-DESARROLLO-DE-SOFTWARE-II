import 'package:dio/dio.dart';
import '../models/post.dart';
import '../models/comment.dart';

class DioApiService {
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com';

  final Dio _dio;

  DioApiService({Dio? dio})
      : _dio = dio ??
            Dio(BaseOptions(
              baseUrl: _baseUrl,
              connectTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 10),
              headers: {'Content-Type': 'application/json'},
            ));

  // GET: Obtener todos los posts
  Future<List<Post>> getPosts() async {
    try {
      final response = await _dio.get('/posts');
      final List<dynamic> data = response.data;
      return data.map((json) => Post.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // GET: Obtener un post por ID
  Future<Post> getPostById(int id) async {
    try {
      final response = await _dio.get('/posts/$id');
      return Post.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // POST: Crear post
  Future<Post> createPost({
    required String title,
    required String body,
    required int userId,
  }) async {
    try {
      final response = await _dio.post(
        '/posts',
        data: {
          'title': title,
          'body': body,
          'userId': userId,
        },
      );
      return Post.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // GET: Comentarios de un post
  Future<List<Comment>> getCommentsByPost(int postId) async {
    try {
      final response = await _dio.get('/posts/$postId/comments');
      final List<dynamic> data = response.data;
      return data.map((json) => Comment.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Manejo centralizado de errores
  Exception _handleError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return Exception('Tiempo de espera agotado. Verifica tu conexión.');
    }
    if (e.type == DioExceptionType.connectionError) {
      return Exception('Sin conexión a internet.');
    }
    return Exception('Error: ${e.message}');
  }
}