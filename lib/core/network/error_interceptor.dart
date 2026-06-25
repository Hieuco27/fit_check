import 'package:dio/dio.dart';
import 'app_exception.dart';

/// Interceptor chuyên dùng để bắt và xử lý các lỗi trả về từ API một cách tập trung.
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // 1. XỬ LÝ LỖI 401 (HẾT HẠN TOKEN)
    if (err.response?.statusCode == 401) {
      // TODO: Logic Refresh Token
      // - Gọi API refresh-token để lấy token mới
      // - Lưu token mới vào Storage
      // - Thay thế token cũ trong err.requestOptions
      // - Dùng Dio để fetch (retry) lại err.requestOptions và trả về kết quả
      // - Nếu refresh thất bại -> Xoá dữ liệu user và điều hướng về trang Login
    }

    // 2. PARSE LỖI THÀNH DẠNG DỄ ĐỌC
    // Biến các lỗi khô khan của Dio thành câu báo lỗi thân thiện (AppException)
    final appException = AppException.fromDioError(err);

    // Gắn cái lỗi thân thiện này đè lên cái lỗi cũ của Dio
    final customError = err.copyWith(error: appException);

    // Đẩy lỗi ra ngoài cho UI (hoặc Bloc/Repository) xử lý tiếp
    return handler.reject(customError);
  }
}
