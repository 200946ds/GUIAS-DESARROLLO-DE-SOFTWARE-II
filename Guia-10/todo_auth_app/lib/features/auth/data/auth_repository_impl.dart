import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../domain/entities/user.dart';
import '../domain/repositories/auth_repository.dart';
import 'auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource _datasource;
  final FlutterSecureStorage _storage;

  AuthRepositoryImpl(this._datasource, this._storage);

  @override
  Future<User> login(String email, String password) async {
    final data = await _datasource.login(email, password);
    final token = data['token'] as String;

    await _storage.write(key: 'access_token', value: token);
    await _storage.write(key: 'user_email', value: email);

    return User(id: 0, email: email, token: token);
  }

  @override
  Future<User> register(String email, String password) async {
    final data = await _datasource.register(email, password);
    final token = data['token'] as String;
    final id = data['id'] as int? ?? 0;

    await _storage.write(key: 'access_token', value: token);
    await _storage.write(key: 'user_email', value: email);

    return User(id: id, email: email, token: token);
  }

  @override
  Future<void> logout() async {
    await _storage.delete(key: 'access_token');
    await _storage.delete(key: 'user_email');
  }

  @override
  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: 'access_token');
    return token != null && token.isNotEmpty;
  }

  @override
  Future<String?> getToken() => _storage.read(key: 'access_token');
}