import 'package:avaliacao_2/data/repositories/pedido/pedido_repository.dart';
import 'package:avaliacao_2/data/services/api_client/api_client.dart';
import 'package:avaliacao_2/domain/pedido/pedido_model.dart';
import 'package:avaliacao_2/utils/result.dart';

final class PedidoRepositoryRemote implements PedidoRepository {
  PedidoRepositoryRemote({required ApiClient apiClient})
    : _apiClient = apiClient;

  final ApiClient _apiClient;

  static PedidoModel _decodePedido(Object? data) =>
      PedidoModel.fromMap(data as Map<String, dynamic>);

  @override
  Future<Result<List<PedidoModel>>> getPedidos({String? status}) async {
    final result = await _apiClient.get<List<PedidoModel>>(
      '/pedidos',
      queryParameters: {if (status != null) 'status': status},
      decoder: (data) => (data as List)
          .map((e) => PedidoModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    return result.map((response) => response.data);
  }

  @override
  Future<Result<PedidoModel>> createPedido(PedidoModel pedido) async {
    final result = await _apiClient.post<PedidoModel>(
      '/pedidos',
      body: pedido.toMap(),
      decoder: _decodePedido,
    );
    return result.map((response) => response.data);
  }

  @override
  Future<Result<PedidoModel>> updatePedido(PedidoModel pedido) async {
    final result = await _apiClient.put<PedidoModel>(
      '/pedidos/${pedido.id}',
      body: pedido.toMap(),
      decoder: _decodePedido,
    );
    return result.map((response) => response.data);
  }

  @override
  Future<Result<void>> deletePedido(int id) async {
    final result = await _apiClient.delete<void>('/pedidos/$id');
    return result.map((_) {});
  }
}
