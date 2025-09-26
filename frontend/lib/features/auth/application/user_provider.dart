import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../infrastructure/user_api.dart';

final userApiProvider = Provider<UserApi>((ref) => UserApi());

final userListProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final api = ref.read(userApiProvider);
  return await api.getUsers();
});

final userByIdProvider =
    FutureProvider.family<Map<String, dynamic>?, int>((ref, id) async {
  final api = ref.read(userApiProvider);
  return await api.getUserById(id);
});
