abstract class AuthRepository {
  Future<String> login(String username, String password);
  Future<void> register(String username, String password, String email, String phone);
  Future<Map<String, dynamic>> me(String token);
}
