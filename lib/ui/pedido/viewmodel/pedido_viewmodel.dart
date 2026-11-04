import 'package:avaliacao_2/data/repositories/pedido/pedido_repository.dart';
import 'package:avaliacao_2/domain/pedido/pedido_model.dart';
import 'package:avaliacao_2/utils/command.dart';
import 'package:avaliacao_2/utils/result.dart';
import 'package:flutter/foundation.dart';

final class PedidoViewmodel extends ChangeNotifier{
  final PedidoRepository pedidoRepository;
  
  PedidoViewmodel({required this.pedidoRepository}){
    carregarPedidosCommand = Command0(_getPedidos);
    deletarPedido = Command1(_deletarPedido);
  }

  late final Command0<List<PedidoModel>> carregarPedidosCommand;
  late final Command1<void,int> deletarPedido;

  Future<Result<List<PedidoModel>>> _getPedidos() async {
    return await pedidoRepository.getPedidos();
  }
  Future<Result<void>> _deletarPedido(int id) async {
    return await pedidoRepository.deletePedido(id);
  }
}