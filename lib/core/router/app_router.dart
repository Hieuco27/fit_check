import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:fit_check/features/capture/domain/entities/captured_image.dart';
import 'package:fit_check/features/capture/domain/entities/garment_scan.dart';
import 'package:fit_check/features/capture/presentation/bloc/camera_bloc.dart';
import 'package:fit_check/features/capture/presentation/bloc/portrait_picker_bloc.dart';
import 'package:fit_check/features/capture/presentation/bloc/portrait_picker_event.dart';
import 'package:fit_check/features/auth/presentation/pages/sign_in_page.dart';
import 'package:fit_check/features/auth/presentation/pages/sign_up_page.dart';
import 'package:fit_check/features/capture/presentation/pages/interaction_canvas_page.dart';
import 'package:fit_check/features/capture/presentation/pages/portrait_picker_page.dart';
import 'package:fit_check/features/capture/presentation/pages/smart_camera_page.dart';
import 'package:fit_check/features/home/presentation/pages/home_page.dart';
import 'package:fit_check/features/tryon/presentation/pages/tryon_result_page.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: <RouteBase>[
      GoRoute(path: '/login', builder: (context, state) => const SignInPage()),
      GoRoute(
        path: '/register',
        builder: (context, state) => const SignUpPage(),
      ),
      GoRoute(path: '/home', builder: (context, state) => const HomePage()),

      // ── Camera — Nhận initialMode và useFrontCamera từ extra ────────────
      GoRoute(
        path: '/camera',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;

          // Đọc mode từ extra, mặc định portrait
          final modeStr = extra?['mode'] as String? ?? 'portrait';
          final initialMode = modeStr == 'garment'
              ? CameraMode.garment
              : CameraMode.portrait;

          // Đọc camera facing, mặc định cam sau
          final useFrontCamera = extra?['useFrontCamera'] as bool? ?? false;
          final garmentScan = extra?['garmentScan'] as GarmentScan?;

          return SmartCameraPage(
            initialMode: initialMode,
            useFrontCamera: useFrontCamera,
            garmentScanForTryOn: garmentScan,
          );
        },
        routes: [
          // /camera/canvas — Màn hình 2 (reuse CameraBloc từ SmartCameraPage)
          GoRoute(
            path: 'canvas',
            builder: (context, state) => const InteractionCanvasPage(),
          ),
        ],
      ),

      // /canvas — Route độc lập (navigate từ SmartCameraPage qua context.push)
      GoRoute(
        path: '/canvas',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final portraitImagePath = extra?['portraitImagePath'] as String?;
          final garmentImagePath = extra?['garmentImagePath'] as String?;
          final resultImagePath = extra?['resultImagePath'] as String?;

          if (portraitImagePath != null &&
              garmentImagePath != null &&
              resultImagePath != null) {
            return InteractionCanvasPage(
              portraitImagePath: portraitImagePath,
              garmentImagePath: garmentImagePath,
              resultImagePath: resultImagePath,
            );
          }

          if (extra != null && extra.containsKey('bloc')) {
            return BlocProvider<CameraBloc>.value(
              value: extra['bloc'] as CameraBloc,
              child: const InteractionCanvasPage(),
            );
          }
          return const Scaffold(
            body: Center(child: Text('Error: CameraBloc not provided')),
          );
        },
      ),

      // ── Portrait Picker — Chọn chân dung sau khi chụp quần áo ───────────
      GoRoute(
        path: '/portrait-picker',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          final garmentScan = extra['garmentScan'] as GarmentScan?;
          final garmentImagePath = extra['garmentImagePath'] as String?;
          final isUpdating = extra['isUpdating'] as bool? ?? false;

          return BlocProvider(
            create: (_) => PortraitPickerBloc()..add(const LoadPickerData()),
            child: PortraitPickerPage(
              garmentScan: garmentScan,
              garmentImagePath: garmentImagePath,
              isUpdating: isUpdating,
            ),
          );
        },
      ),

      // ── Try-On Result — Màn hình kết quả ──────────────────────────────
      GoRoute(
        path: '/tryon/result',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          final portraitPath =
              extra['portraitImagePath'] as String? ??
              'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?w=600';
          final garmentPath =
              extra['garmentImagePath'] as String? ??
              'https://images.unsplash.com/photo-1515372039744-b8f02a3ae446?w=600';
          final resultPath = extra['resultImagePath'] as String?;

          return TryOnResultPage(
            portraitImagePath: portraitPath,
            garmentImagePath: garmentPath,
            resultImagePath: resultPath,
          );
        },
      ),

      // Legacy redirect
      GoRoute(
        path: '/tryon',
        builder: (context, state) => SmartCameraPage(
          initialMode: CameraMode.garment,
          useFrontCamera: false,
        ),
      ),
    ],
  );
}
