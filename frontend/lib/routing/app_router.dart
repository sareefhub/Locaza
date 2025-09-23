import 'package:go_router/go_router.dart';

import '../features/splash/presentation/screens/splash_screen.dart';
import '../features/auth/presentation/screens/onboarding_screen.dart';
import '../features/home/presentation/screens/home_screen.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/presentation/screens/login_username_screen.dart';
import '../features/auth/presentation/screens/sign_up_screen.dart';
import '../features/profile/presentation/screens/profile_screen.dart';
import '../features/product/presentation/screens/post_screen.dart';
import '../features/profile/presentation/screens/edit_profile_screen.dart';
import '../features/product/presentation/screens/post_form_screen.dart';
import '../features/favorite/presentation/screens/favorite_screen.dart';
import '../features/product/presentation/screens/choose_photo_screen.dart';
import '../features/product/presentation/screens/edit_post_form_screen.dart';
import '../features/chat/presentation/screens/chat_screen.dart';
import '../features/chat/presentation/screens/chat_detail_screen.dart';
import '../features/notification/presentation/screens/notification_screen.dart';
import '../features/product/presentation/screens/product_details_screen.dart';
import '../features/product/presentation/screens/search_screen.dart';
import '../features/product/presentation/screens/filter_screen.dart';
import '../features/product/presentation/screens/purchase_history_screen.dart';
import '../features/store/presentation/screens/store_screen.dart';

import '../utils/user_session.dart';
import 'routes.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.home,
  routes: [
    GoRoute(path: AppRoutes.splash, builder: (_, __) => const SplashScreen()),
    GoRoute(
      path: AppRoutes.onboarding,
      builder: (_, __) => const OnboardingScreen(),
    ),
    GoRoute(path: AppRoutes.home, builder: (_, __) => const HomeScreen()),
    GoRoute(path: AppRoutes.search, builder: (_, __) => const SearchScreen()),
    GoRoute(path: AppRoutes.login, builder: (_, __) => const LoginScreen()),
    GoRoute(
      path: AppRoutes.loginUsername,
      builder: (_, __) => const LoginUsernameScreen(),
    ),
    GoRoute(path: AppRoutes.signup, builder: (_, __) => const SignUpScreen()),
    GoRoute(path: AppRoutes.profile, builder: (_, __) => const ProfileScreen()),
    GoRoute(path: AppRoutes.post, builder: (_, __) => const PostScreen()),
    GoRoute(
      path: AppRoutes.editProfile,
      builder: (_, __) => const EditProfileScreen(),
    ),
    GoRoute(
      path: AppRoutes.postForm,
      builder: (_, __) => const PostFormScreen(),
    ),
    GoRoute(
      path: AppRoutes.favorite,
      builder: (_, __) => const FavoriteScreen(),
    ),
    GoRoute(
      path: AppRoutes.choosePhoto,
      builder: (_, __) => const ChoosePhotoScreen(),
    ),
    GoRoute(
      path: AppRoutes.chat,
      builder: (_, __) => ChatScreen(currentUserId: UserSession.id ?? ''),
    ),
    GoRoute(
      path: AppRoutes.chatDetail,
      builder: (_, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return ChatDetailScreen(
          chatId: state.pathParameters['chatId'] ?? "tempChatId",
          currentUserId: state.pathParameters['currentUserId'] ?? "1",
          otherUserId: state.pathParameters['otherUserId'] ?? "2",
          product: extra?['product'] ?? {},
        );
      },
    ),
    GoRoute(
      path: AppRoutes.notification,
      builder: (_, __) => const NotificationScreen(),
    ),
    GoRoute(
      path: AppRoutes.postEdit,
      builder: (_, state) =>
          EditPostFormScreen(postId: state.pathParameters['id']!),
    ),
    GoRoute(
      path: AppRoutes.productDetails,
      builder: (_, state) {
        final product = state.extra as Map<String, dynamic>;
        return ProductDetailsPage(product: product);
      },
    ),
    GoRoute(
      path: AppRoutes.filter,
      builder: (_, state) =>
          FilterScreen(initialFilters: state.extra as Map<String, dynamic>?),
    ),
    GoRoute(
      path: AppRoutes.purchaseHistory,
      builder: (context, state) => const MyPurchasePage(),
    ),
    GoRoute(
      path: AppRoutes.store,
      builder: (_, state) {
        final storeId = state.pathParameters['storeId'] ?? '';
        final extra = state.extra as Map<String, dynamic>?;

        return StoreScreen(
          storeId: storeId,
          isOwner: extra?['isOwner'] ?? false,
          seller: extra?['seller'],
        );
      },
    ),
  ],
);
