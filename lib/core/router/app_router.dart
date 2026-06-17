import 'package:go_router/go_router.dart';
import 'package:fit_check/features/auth/presentation/pages/splash_page.dart';
import 'package:fit_check/features/auth/presentation/pages/login_page.dart';
import 'package:fit_check/features/auth/presentation/pages/register_page.dart';
import 'package:fit_check/features/home/presentation/pages/home_page.dart';
import 'package:fit_check/features/tryon/presentation/pages/tryon_page.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/tryon',
        builder: (context, state) => const TryonPage(),
      ),
    ],
  );
}
