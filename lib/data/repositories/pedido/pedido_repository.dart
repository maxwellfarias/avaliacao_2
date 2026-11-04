import 'package:avaliacao_2/domain/pedido/pedido_model.dart';
import 'package:avaliacao_2/utils/result.dart';

/// Pedidos dos clientes.
abstract interface class PedidoRepository {
  /// GET /pedidos, com filtro opcional `?status=` (ex.: pendente).
  Future<Result<List<PedidoModel>>> getPedidos({String? status});

  /// POST /pedidos (201). O `id` do argumento é ignorado: o servidor gera.
  Future<Result<PedidoModel>> createPedido(PedidoModel pedido);

  /// PUT /pedidos/:id — substitui integralmente o pedido.
  Future<Result<PedidoModel>> updatePedido(PedidoModel pedido);

  /// DELETE /pedidos/:id.
  Future<Result<void>> deletePedido(int id);
}
