import 'package:flutter/foundation.dart';
import '../domain/usecases/login_usecase.dart';

class AuthProvider with ChangeNotifier {
  final LoginUseCase loginUseCase;

  AuthProvider(this.loginUseCase);

  String? token;
  bool isLoading = false;

  Future<void> login(String username, String password) async {
    isLoading = true;
    notifyListeners();
    try {
      token = await loginUseCase(username, password);
    } catch (e) {
      debugPrint("Login error: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
