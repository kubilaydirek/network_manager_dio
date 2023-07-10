import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class NetworkManager {
  static const String _baseUrl = "BASE_URL"; // API'nin temel URL'si

  final Dio _dio;

  NetworkManager() : _dio = Dio() {
    _dio.options.baseUrl = _baseUrl;
    _dio.interceptors.add(PrettyDioLogger());
    _dio.interceptors.add(InterceptorsWrapper(onRequest: _onRequest, onError: _onError, onResponse: _onResponse));
  }

  void _onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // ignore: prefer_const_declarations
    final token = 'YOUR_TOKEN';
    options.headers["Authorization"] = "Bearer $token";
    handler.next(options);
  }

  Future<Response<T>> get<T>(String path, {Map<String, dynamic>? queryParameters, int timeoutSeconds = 30}) async {
    try {
      final response = await _dio.get<T>(path, queryParameters: queryParameters, options: _getRequestOptions(timeoutSeconds));
      return response;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response<T>> post<T>(String path, {dynamic data, int timeoutSeconds = 30}) async {
    try {
      final response = await _dio.post<T>(path, data: data, options: _getRequestOptions(timeoutSeconds));
      return response;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response<T>> put<T>(String path, {dynamic data, int timeoutSeconds = 30}) async {
    try {
      final response = await _dio.put<T>(path, data: data, options: _getRequestOptions(timeoutSeconds));
      return response;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response<T>> delete<T>(String path, {Map<String, dynamic>? queryParameters, int timeoutSeconds = 30}) async {
    try {
      final response = await _dio.delete<T>(path, queryParameters: queryParameters, options: _getRequestOptions(timeoutSeconds));
      return response;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Options _getRequestOptions(int timeoutSeconds) {
    return Options(
      receiveTimeout: Duration(microseconds: timeoutSeconds * 1000), // sunucudan yanıt bekleme süresi
      sendTimeout: Duration(microseconds: timeoutSeconds * 1000),
      // isteğin sunucuya gönderilme süresi
    );
  }

  dynamic _handleError(dynamic error) {
    if (error is DioException) {
      if (error.response != null) {
        final statusCode = error.response!.statusCode;
        final responseData = error.response!.data;

        throw NetworkException("Request failed with status code $statusCode. Response data: $responseData");
      } else {
        throw NetworkException("No response from server.");
      }
    }
    throw error;
  }

  void _onError(DioException e, ErrorInterceptorHandler handler) {
    handler.next(e);
  }

  void _onResponse(Response e, ResponseInterceptorHandler handler) {
    handler.next(e);
  }
}

class NetworkException implements Exception {
  final String message;

  NetworkException(this.message);

  @override
  String toString() {
    return 'NetworkException: $message';
  }
}
