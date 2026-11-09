import '../domain/entities/task.dart';
import '../domain/repositories/task_repository.dart';
import 'task_remote_datasource.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskRemoteDatasource _datasource;

  TaskRepositoryImpl(this._datasource);

  @override
  Future<List<Task>> getTasks({int page = 1, int limit = 20}) =>
      _datasource.getTasks(page: page, limit: limit);

  @override
  Future<Task> createTask(String title) => _datasource.createTask(title);

  @override
  Future<Task> updateTask(Task task) => _datasource.updateTask(task);

  @override
  Future<void> deleteTask(int id) => _datasource.deleteTask(id);
}