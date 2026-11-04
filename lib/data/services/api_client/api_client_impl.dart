
import 'package:avaliacao_2/api/api_config.dart';
import 'package:avaliacao_2/data/services/api_client/api_client.dart';
import 'package:avaliacao_2/exceptions/app_exception.dart';
import 'package:avaliacao_2/utils/result.dart';
import 'package:dio/dio.dart';

class ApiClientImpl implements ApiClient {
  ApiClientImpl({Dio? dio, this.tokenProvider})
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

  /// Retorna o token de autenticação (ou null). Usado quando `authenticated`.
  final Future<String?> Function()? tokenProvider;

  @override
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
  }) async {
    try {
      var url = path;
      pathParameters.forEach((k, v) {
        url = url.replaceAll('{$k}', Uri.encodeComponent('$v'));
      });

      final allHeaders = {...headers};
      if (authenticated) {
        final token = await tokenProvider?.call();
        if (token != null) allHeaders['Authorization'] = 'Bearer $token';
      }

      final response = await _dio.request<Object?>(
        url,
        data: body,
        queryParameters: {
          for (final e in queryParameters.entries)
            if (e.value != null) e.key: e.value,
        },
        options: Options(
          method: method.name.toUpperCase(),
          headers: allHeaders,
          responseType: switch (responseType) {
            ApiResponseType.json => ResponseType.json,
            ApiResponseType.text => ResponseType.plain,
            ApiResponseType.bytes => ResponseType.bytes,
          },
        ),
      );

      final raw = response.data;
      final data = decoder != null ? decoder(raw) : raw as T;
      return Result.ok(
        ApiResponse<T>(
          data: data,
          statusCode: response.statusCode ?? 200,
          headers: {
            for (final e in response.headers.map.entries)
              e.key: e.value.join(','),
          },
        ),
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
        final data = e.response?.data;
        final serverMessage = data is Map ? data['message']?.toString() : null;
        return switch (e.response?.statusCode) {
          400 => RequisicaoInvalidaException(serverMessage),
          401 => NaoAutorizadoException(),
          403 => AcessoProibidoException(),
          404 => RecursoNaoEncontradoException(),
          429 => MuitasRequisicoesException(),
          500 => ErroInternoServidorException(),
          503 => ServidorIndisponivelException(),
          final code? => ErroHttpException(
            statusCode: code,
            serverMessage: serverMessage,
          ),
          _ => ErroDeComunicacaoException(),
        };
      default:
        return ErroDeComunicacaoException();
    }
  }

  @override
  void close({bool force = false}) => _dio.close(force: force);
}