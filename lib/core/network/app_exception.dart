// core/network/app_exception.dart
import 'package:dio/dio.dart';

class AppException implements Exception {
  AppException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  factory AppException.fromDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return AppException('Kết nối quá lâu, vui lòng thử lại');

      case DioExceptionType.connectionError:
        return AppException('Không có kết nối mạng');

      case DioExceptionType.badResponse:
        final data = error.response?.data;
        final message = (data is Map && data['message'] != null)
            ? data['message'].toString()
            : 'Có lỗi xảy ra (${error.response?.statusCode})';
        return AppException(message, statusCode: error.response?.statusCode);

      case DioExceptionType.cancel:
        return AppException('Yêu cầu đã bị huỷ');

      default:
        return AppException('Lỗi không xác định, vui lòng thử lại');
    }
  }

  @override
  String toString() => message;
}
