
import 'package:avaliacao_2/utils/result.dart';

/// Contrato de transporte HTTP independente de biblioteca (arquitetura §11.1).
/// A implementação com Dio (`ApiClientImpl`) será criada junto com o backend.
enum HttpMethod { get, post, put, patch, delete }

enum ApiResponseType { json, text, bytes }

typedef ApiResponseDecoder<T> = T Function(Object? data);

final class ApiResponse<T> {
  ApiResponse({
    required this.data,
    required this.statusCode,
    required Map<String, String> headers,
  }) : headers = Map.unmodifiable({
         for (final entry in headers.entries)
           entry.key.toLowerCase(): entry.value,
       });

  final T data;
  final int statusCode;
  final Map<String, String> headers;

  String? header(String name) => headers[name.toLowerCase()];
}

abstract interface class ApiClient {
  Future<Result<ApiResponse<T>>> request<T>({
    required String path,
    required HttpMethod method,
    Map<String, Object> pathParameters = const {},
    Map<String, Object?> queryParameters = const {},
    Map<String, String> headers = const {},
    Object? body,
    bool authenticated = true,
    ApiResponseType responseType = ApiResponseType.json,
    ApiResponseDecoder<T>? decoder,
  });

  void close({bool force = false});
}

extension ApiClientVerbs on ApiClient {
  Future<Result<ApiResponse<T>>> get<T>(
    String path, {
    Map<String, Object> pathParameters = const {},
    Map<String, Object?> queryParameters = const {},
    ApiResponseDecoder<T>? decoder,
  }) => request<T>(
    path: path,
    method: HttpMethod.get,
    pathParameters: pathParameters,
    queryParameters: queryParameters,
    decoder: decoder,
  );

  Future<Result<ApiResponse<T>>> post<T>(
    String path, {
    Object? body,
    Map<String, Object> pathParameters = const {},
    ApiResponseDecoder<T>? decoder,
  }) => request<T>(
    path: path,
    method: HttpMethod.post,
    pathParameters: pathParameters,
    body: body,
    decoder: decoder,
  );

  Future<Result<ApiResponse<T>>> patch<T>(
    String path, {
    Object? body,
    Map<String, Object> pathParameters = const {},
    ApiResponseDecoder<T>? decoder,
  }) => request<T>(
    path: path,
    method: HttpMethod.patch,
    pathParameters: pathParameters,
    body: body,
    decoder: decoder,
  );

  Future<Result<ApiResponse<T>>> delete<T>(
    String path, {
    Map<String, Object> pathParameters = const {},
    ApiResponseDecoder<T>? decoder,
  }) => request<T>(
    path: path,
    method: HttpMethod.delete,
    pathParameters: pathParameters,
    decoder: decoder,
  );
}
