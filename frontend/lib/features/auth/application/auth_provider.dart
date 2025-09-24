import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../utils/user_session.dart';
import '../infrastructure/auth_api.dart';

final authProviderNotifier =
    StateNotifierProvider<AuthProvider, AuthState>((ref) {
  return AuthProvider(AuthApi());
});

class AuthState {
  final bool isLoading;
  AuthState({this.isLoading = false});

  AuthState copyWith({bool? isLoading}) {
    return AuthState(isLoading: isLoading ?? this.isLoading);
  }
}

class AuthProvider extends StateNotifier<AuthState> {
  final AuthApi api;

  AuthProvider(this.api) : super(AuthState());

  Future<bool> login(String username, String password) async {
    state = state.copyWith(isLoading: true);
    try {
      // step 1: login เอา token
      final result = await api.login(username, password);
      UserSession.token = result['access_token']?.toString();
      UserSession.isLoggedIn = true;

      // step 2: ใช้ token ไปเรียก /auth/me
      final userData = await api.me(UserSession.token!);
      UserSession.id = userData['id']?.toString();
      UserSession.username = userData['username'];
      UserSession.phone = userData['phone'];
      UserSession.avatarUrl = userData['avatar_url'];

      // step 3: เก็บลง SharedPreferences
      await UserSession.saveToStorage();

      state = state.copyWith(isLoading: false);
      return true;
    } catch (_) {
      state = state.copyWith(isLoading: false);
      return false;
    }
  }
}
