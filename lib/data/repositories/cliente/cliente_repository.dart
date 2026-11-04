import 'package:avaliacao_2/domain/cliente/cliente_model.dart';
import 'package:avaliacao_2/utils/result.dart';

/// Clientes cadastrados (GET /clientes).
abstract interface class ClienteRepository {
  Future<Result<List<ClienteModel>>> getClientes();
}
