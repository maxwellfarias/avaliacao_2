import 'package:avaliacao_2/utils/result.dart';

enum HttpMethod { get, post, put, delete }

typedef ApiResponseDecoder<T> = T Function(Object? data);

final class ApiResponse<T> {
  ApiResponse({required this.data, required this.statusCode});

  final T data;
  final int statusCode;
}

abstract interface class ApiClient {
  Future<Result<ApiResponse<T>>> request<T>({
    required String path,
    required HttpMethod method,
    Map<String, Object?> queryParameters = const {},
    Object? body,
    ApiResponseDecoder<T>? decoder,
  });
}

extension ApiClientVerbs on ApiClient {
  Future<Result<ApiResponse<T>>> get<T>(
    String path, {
    Map<String, Object?> queryParameters = const {},
    ApiResponseDecoder<T>? decoder,
  }) => request<T>(
    path: path,
    method: HttpMethod.get,
    queryParameters: queryParameters,
    decoder: decoder,
  );

  Future<Result<ApiResponse<T>>> post<T>(
    String path, {
    Object? body,
    ApiResponseDecoder<T>? decoder,
  }) => request<T>(
    path: path,
    method: HttpMethod.post,
    body: body,
    decoder: decoder,
  );

  Future<Result<ApiResponse<T>>> put<T>(
    String path, {
    Object? body,
    ApiResponseDecoder<T>? decoder,
  }) => request<T>(
    path: path,
    method: HttpMethod.put,
    body: body,
    decoder: decoder,
  );

  Future<Result<ApiResponse<T>>> delete<T>(
    String path, {
    ApiResponseDecoder<T>? decoder,
  }) => request<T>(path: path, method: HttpMethod.delete, decoder: decoder);
}
