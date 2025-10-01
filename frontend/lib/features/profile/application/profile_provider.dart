import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../utils/user_session.dart';
import '../infrastructure/profile_api.dart';

class ProfileState {
  final bool isLoading;
  final Map<String, dynamic>? user;

  const ProfileState({this.isLoading = false, this.user});

  ProfileState copyWith({bool? isLoading, Map<String, dynamic>? user}) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
    );
  }
}

class ProfileNotifier extends StateNotifier<ProfileState> {
  final ProfileApi api;

  ProfileNotifier(this.api) : super(const ProfileState());

  Future<void> loadProfile() async {
    state = state.copyWith(isLoading: true);

    try {
      final profile = await api.getProfile();
      if (profile != null) {
        state = state.copyWith(user: profile);

        UserSession.id = profile['id']?.toString();
        UserSession.username = profile['username'];
        UserSession.phone = profile['phone'];
        UserSession.avatarUrl = profile['avatar_url'];
        UserSession.isLoggedIn = true;
        await UserSession.saveToStorage();
      }
    } catch (_) {
      state = state.copyWith(user: null);
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> updateProfile({
    required String userId,
    required String name,
    required String email,
    required String phone,
    required String avatarUrl,
    required String location,
  }) async {
    state = state.copyWith(isLoading: true);
    try {
      final updated = await api.updateProfile(
        userId: userId,
        name: name,
        email: email,
        phone: phone,
        avatarUrl: avatarUrl,
        location: location,
      );
      if (updated != null) {
        state = state.copyWith(user: updated);
        UserSession.username = updated['username'];
        UserSession.phone = updated['phone'];
        UserSession.avatarUrl = updated['avatar_url'];
        await UserSession.saveToStorage();
      }
    } catch (_) {} finally {
      state = state.copyWith(isLoading: false);
    }
  }
}

final profileProviderNotifier =
    StateNotifierProvider<ProfileNotifier, ProfileState>(
  (ref) => ProfileNotifier(ProfileApi()),
);
