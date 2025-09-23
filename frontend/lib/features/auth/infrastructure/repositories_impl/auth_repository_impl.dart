import '../../domain/repositories/auth_repository.dart';
import '../services/auth_api.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApi api;

  AuthRepositoryImpl(this.api);

  @override
  Future<String> login(String username, String password) {
    return api.login(username, password);
  }

  @override
  Future<void> register(
      String username, String password, String email, String phone) {
    return api.register(username, password, email, phone);
  }

  @override
  Future<Map<String, dynamic>> me(String token) {
    return api.me(token);
  }
}
