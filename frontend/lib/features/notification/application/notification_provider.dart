import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../infrastructure/notification_api.dart';

final notificationProvider =
    StateNotifierProvider<NotificationNotifier, AsyncValue<List<Map<String, dynamic>>>>(
  (ref) => NotificationNotifier(ref),
);

class NotificationNotifier extends StateNotifier<AsyncValue<List<Map<String, dynamic>>>> {
  final Ref ref;

  NotificationNotifier(this.ref) : super(const AsyncValue.loading()) {
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    try {
      final notifications = await ref.read(notificationApiProvider).getUserNotifications();
      state = AsyncValue.data(notifications);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> markAsRead(int id) async {
    try {
      await ref.read(notificationApiProvider).markAsRead(id);
      final updatedList = state.value?.map((n) {
        if (n["id"] == id) {
          return {...n, "is_read": true};
        }
        return n;
      }).toList();
      state = AsyncValue.data(updatedList ?? []);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
