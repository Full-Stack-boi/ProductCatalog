import 'package:dio/dio.dart';

class AppException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic originalError;

  const AppException({
    required this.message,
    this.statusCode,
    this.originalError,
  });

  factory AppException.fromDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
        return AppException(
          message: 'การเชื่อมต่อหมดเวลา กรุณาลองใหม่อีกครั้ง',
          originalError: error,
        );
      case DioExceptionType.badResponse:
        final status = error.response?.statusCode;
        final statusMsg = error.response?.statusMessage;
        if (status == 404) {
          return AppException(
            message: 'ไม่พบข้อมูลที่ต้องการ (404 Not Found)',
            statusCode: status,
            originalError: error,
          );
        }
        if (status != null && status >= 500) {
          return AppException(
            message: 'ระบบเซิร์ฟเวอร์ขัดข้อง ($status) กรุณาลองใหม่ในภายหลัง',
            statusCode: status,
            originalError: error,
          );
        }
        return AppException(
          message: statusMsg ?? 'เกิดข้อผิดพลาดในการรับส่งข้อมูล ($status)',
          statusCode: status,
          originalError: error,
        );
      case DioExceptionType.cancel:
        return AppException(message: 'คำขอถูกยกเลิก', originalError: error);
      case DioExceptionType.connectionError:
        return AppException(
          message: 'ไม่สามารถเชื่อมต่อเครือข่ายได้ กรุณาตรวจสอบอินเทอร์เน็ต',
          originalError: error,
        );
      case DioExceptionType.badCertificate:
        return AppException(
          message: 'ใบรับรองความปลอดภัยไม่ถูกต้อง',
          originalError: error,
        );
      case DioExceptionType.unknown:
        return AppException(
          message: 'เกิดข้อผิดพลาดที่ไม่ทราบสาเหตุ กรุณาลองใหม่อีกครั้ง',
          originalError: error,
        );
    }
  }

  @override
  String toString() => message;
}
