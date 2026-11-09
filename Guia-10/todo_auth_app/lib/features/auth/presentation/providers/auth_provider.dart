import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../core/network/dio_factory.dart';
import '../../data/auth_remote_datasource.dart';
import '../../data/auth_repository_impl.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

// Infraestructura compartida
final secureStorageProvider = Provider((_) => const FlutterSecureStorage());

final dioProvider = Provider((ref) {
  final storage = ref.watch(secureStorageProvider);
  return DioFactory.create(storage: storage);
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dio = ref.watch(dioProvider);
  final storage = ref.watch(secureStorageProvider);
  return AuthRepositoryImpl(AuthRemoteDatasource(dio), storage);
});

// Estado de autenticación
final authStateProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<User?>>((ref) {
  return AuthNotifier(ref.watch(authRepositoryProvider));
});

class AuthNotifier extends StateNotifier<AsyncValue<User?>> {
  final AuthRepository _repository;

  AuthNotifier(this._repository) : super(const AsyncValue.loading()) {
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    final loggedIn = await _repository.isLoggedIn();
    if (loggedIn) {
      final email = await const FlutterSecureStorage().read(key: 'user_email');
      final token = await _repository.getToken();
      state = AsyncValue.data(
        User(id: 0, email: email ?? '', token: token ?? ''),
      );
    } else {
      state = const AsyncValue.data(null);
    }
  }

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.login(email, password));
  }

  Future<void> register(String email, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.register(email, password));
  }

  Future<void> logout() async {
    await _repository.logout();
    state = const AsyncValue.data(null);
  }
}