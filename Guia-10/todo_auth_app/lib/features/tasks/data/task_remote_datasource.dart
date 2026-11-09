import 'package:dio/dio.dart';
import '../domain/entities/task.dart';

class TaskRemoteDatasource {
  final Dio _dio;

  // JSONPlaceholder como API de tareas (el token se envía por el interceptor)
  static const _baseUrl = 'https://jsonplaceholder.typicode.com';

  TaskRemoteDatasource(this._dio);

  Future<List<Task>> getTasks({int page = 1, int limit = 20}) async {
    final response = await _dio.get(
      '$_baseUrl/todos',
      queryParameters: {'_page': page, '_limit': limit},
    );
    final list = response.data as List;
    return list.map((e) => Task.fromJson(e)).toList();
  }

  Future<Task> createTask(String title) async {
    final response = await _dio.post(
      '$_baseUrl/todos',
      data: {'title': title, 'completed': false, 'userId': 1},
    );
    return Task.fromJson(response.data);
  }

  Future<Task> updateTask(Task task) async {
    final response = await _dio.put(
      '$_baseUrl/todos/${task.id}',
      data: task.toJson(),
    );
    return Task.fromJson(response.data);
  }

  Future<void> deleteTask(int id) async {
    await _dio.delete('$_baseUrl/todos/$id');
  }
}