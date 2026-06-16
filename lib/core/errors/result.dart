/// Generic result type for repository/API calls.
///
/// This is intended to be reused across the whole project so that all
/// async operations can return a consistent success/error structure.
class Result<T> {
  Result._({
    this.data,
    this.message,
    required this.isSuccess,
    required this.isCancelled,
  });

  /// Non-null when the call is successful.
  final T? data;

  /// Optional error message when the call fails.
  final String? message;

  /// Convenience flag to check success without looking at [data] or [message].
  final bool isSuccess;
  final bool isCancelled;

  /// Factory for success case.
  factory Result.success({T? data}) {
    return Result<T>._(
      data: data,
      message: null,
      isSuccess: true,
      isCancelled: false,
    );
  }

  /// Factory for failure case.
  factory Result.failure({String? message}) {
    return Result<T>._(
      data: null,
      message: message,
      isSuccess: false,
      isCancelled: false,
    );
  }
  factory Result.cancelled({String? message}) {
    return Result<T>._(
      data: null,
      message: message,
      isSuccess: false,
      isCancelled: true,
    );
  }
}
