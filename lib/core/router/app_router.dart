import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:fit_check/features/capture/presentation/bloc/camera_bloc.dart';
import 'package:fit_check/features/auth/presentation/pages/splash_page.dart';
import 'package:fit_check/features/auth/presentation/pages/login_page.dart';
import 'package:fit_check/features/auth/presentation/pages/register_page.dart';
import 'package:fit_check/features/capture/presentation/pages/interaction_canvas_page.dart';
import 'package:fit_check/features/capture/presentation/pages/smart_camera_page.dart';
import 'package:fit_check/features/home/presentation/pages/home_page.dart';
import 'package:fit_check/features/tryon/domain/entities/garment_variant.dart';
import 'package:fit_check/features/tryon/presentation/pages/tryon_result_page.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: <RouteBase>[
      GoRoute(path: '/', builder: (context, state) => const SplashPage()),
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(path: '/home', builder: (context, state) => const HomePage()),

      // ── Tính năng Camera mới ─────────────────────────────────────────────
      GoRoute(
        path: '/camera',
        builder: (context, state) => const SmartCameraPage(),
        routes: [
          // /camera/canvas — Màn Hình 2 (reuse CameraBloc từ /camera)
          // CameraBloc được cung cấp từ SmartCameraPage, truyền xuống qua BlocProvider
          GoRoute(
            path: 'canvas',
            builder: (context, state) {
              // CameraBloc được reuse qua context (SmartCameraPage cung cấp)
              return const InteractionCanvasPage();
            },
          ),
        ],
      ),

      // /canvas — Route độc lập khi navigate từ SmartCameraPage bằng context.push('/canvas')
      // Cần wrap với BlocProvider để reuse CameraBloc
      GoRoute(
        path: '/canvas',
        builder: (context, state) {
          // CameraBloc phải được cung cấp bởi parent (SmartCameraPage) thông qua extra
          final extra = state.extra as Map<String, dynamic>?;
          if (extra != null && extra.containsKey('bloc')) {
            return BlocProvider<CameraBloc>.value(
              value: extra['bloc'] as CameraBloc,
              child: const InteractionCanvasPage(),
            );
          }
          // Fallback an toàn (nếu lỡ navigate trực tiếp không qua SmartCameraPage)
          return const Scaffold(
            body: Center(
              child: Text('Error: CameraBloc not found in route extra'),
            ),
          );
        },
      ),

      // ── Try-On Result — Màn Hình 3 ──────────────────────────────────────
      GoRoute(
        path: '/tryon/result',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          final portraitPath =
              extra['portraitImagePath'] as String? ??
              'https://images.unsplash.com/photo-1521572267360-ee0c2909d518?w=600';
          final garmentPath =
              extra['garmentImagePath'] as String? ??
              'https://images.unsplash.com/photo-1521572267360-ee0c2909d518?w=600';
          final variant =
              extra['initialVariant'] as GarmentVariant? ??
              const GarmentVariant(
                id: 2,
                size: 'M',
                colorHex: 'FFFFFF',
                colorName: 'Trắng',
                price: 299000,
                stockCount: 10,
              );

          return TryOnResultPage(
            portraitImagePath: portraitPath,
            garmentImagePath: garmentPath,
            initialVariant: variant,
          );
        },
      ),

      // Legacy route (giữ để backward compat)
      GoRoute(
        path: '/tryon',
        builder: (context, state) =>
            const SmartCameraPage(), // Redirect sang camera mới
      ),
    ],
  );
}
