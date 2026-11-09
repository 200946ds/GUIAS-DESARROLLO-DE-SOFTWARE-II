import '../entities/task.dart';

abstract class TaskRepository {
  Future<List<Task>> getTasks({int page = 1, int limit = 20});
  Future<Task> createTask(String title);
  Future<Task> updateTask(Task task);
  Future<void> deleteTask(int id);
}