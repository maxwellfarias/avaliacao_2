import 'package:avaliacao_2/api/api_config.dart';
import 'package:avaliacao_2/data/services/api_client/api_client.dart';
import 'package:avaliacao_2/exceptions/app_exception.dart';
import 'package:avaliacao_2/utils/result.dart';
import 'package:dio/dio.dart';

class ApiClientImpl implements ApiClient {
  ApiClientImpl({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: ApiConfig.baseUrl,
              connectTimeout: const Duration(seconds: 15),
              receiveTimeout: const Duration(seconds: 15),
            ),
          );

  final Dio _dio;

  @override
  Future<Result<ApiResponse<T>>> request<T>({
    required String path,
    required HttpMethod method,
    Map<String, Object?> queryParameters = const {},
    Object? body,
    ApiResponseDecoder<T>? decoder,
  }) async {
    try {
      final response = await _dio.request<Object?>(
        path,
        data: body,
        queryParameters: {
          for (final e in queryParameters.entries)
            if (e.value != null) e.key: e.value,
        },
        options: Options(method: method.name.toUpperCase()),
      );

      final raw = response.data;
      final data = decoder != null ? decoder(raw) : raw as T;
      return Result.ok(
        ApiResponse<T>(data: data, statusCode: response.statusCode ?? 200),
      );
    } on DioException catch (e) {
      return Result.error(_mapError(e));
    } catch (_) {
      return Result.error(RespostaInvalidaException());
    }
  }

  AppException _mapError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutDeRequisicaoException();
      case DioExceptionType.connectionError:
        return SemConexaoException();
      case DioExceptionType.badResponse:
        return switch (e.response?.statusCode) {
          400 => RequisicaoInvalidaException(),
          404 => RecursoNaoEncontradoException(),
          500 => ErroInternoServidorException(),
          final code? => ErroHttpException(statusCode: code),
          _ => ErroDeComunicacaoException(),
        };
      default:
        return ErroDeComunicacaoException();
    }
  }
}
