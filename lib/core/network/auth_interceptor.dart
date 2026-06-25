import 'package:dio/dio.dart';

/// Interceptor chuyên dùng để xử lý các vấn đề liên quan đến Authentication (Xác thực)
/// Ví dụ: Tự động đính kèm Token vào Header của mỗi request gửi đi.
class AuthInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // TODO: Lấy token từ local storage (ví dụ: SharedPreferences / FlutterSecureStorage)
    // final token = await TokenStorage.getAccessToken();
    const token = null; // Tạm thời để null vì bạn chưa có TokenStorage

    // Nếu có token thì tự động gắn vào Header 'Authorization'
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    // Cho phép request tiếp tục đi tới Server
    return handler.next(options);
  }
}
