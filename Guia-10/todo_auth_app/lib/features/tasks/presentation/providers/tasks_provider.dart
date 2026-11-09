import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/task_remote_datasource.dart';
import '../../data/task_repository_impl.dart';
import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return TaskRepositoryImpl(TaskRemoteDatasource(dio));
});

final tasksProvider =
    AsyncNotifierProvider<TasksNotifier, List<Task>>(TasksNotifier.new);

class TasksNotifier extends AsyncNotifier<List<Task>> {
  int _page = 1;
  final int _limit = 20;
  bool _hasMore = true;

  bool get hasMore => _hasMore;

  @override
  Future<List<Task>> build() async {
    _page = 1;
    _hasMore = true;
    return _fetch();
  }

  Future<List<Task>> _fetch() async {
    final repo = ref.read(taskRepositoryProvider);
    final tasks = await repo.getTasks(page: _page, limit: _limit);
    _hasMore = tasks.length == _limit;
    return tasks;
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    _page = 1;
    _hasMore = true;
    state = await AsyncValue.guard(_fetch);
  }

  Future<void> loadMore() async {
    if (!_hasMore || state.isLoading) return;

    final current = state.valueOrNull ?? [];
    _page++;

    try {
      final more = await ref
          .read(taskRepositoryProvider)
          .getTasks(page: _page, limit: _limit);
      _hasMore = more.length == _limit;
      state = AsyncValue.data([...current, ...more]);
    } catch (e, st) {
      _page--;
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addTask(String title) async {
    final repo = ref.read(taskRepositoryProvider);
    final newTask = await repo.createTask(title);
    final current = state.valueOrNull ?? [];
    state = AsyncValue.data([newTask, ...current]);
  }

  Future<void> toggleTask(Task task) async {
    final updated = task.copyWith(completed: !task.completed);
    final repo = ref.read(taskRepositoryProvider);
    await repo.updateTask(updated);

    final current = state.valueOrNull ?? [];
    state = AsyncValue.data([
      for (final t in current)
        if (t.id == task.id) updated else t,
    ]);
  }

  Future<void> deleteTask(int id) async {
    await ref.read(taskRepositoryProvider).deleteTask(id);
    final current = state.valueOrNull ?? [];
    state = AsyncValue.data(current.where((t) => t.id != id).toList());
  }
}