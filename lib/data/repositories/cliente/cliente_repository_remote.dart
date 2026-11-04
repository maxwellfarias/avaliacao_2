import 'package:avaliacao_2/data/repositories/cliente/cliente_repository.dart';
import 'package:avaliacao_2/data/services/api_client/api_client.dart';
import 'package:avaliacao_2/domain/cliente/cliente_model.dart';
import 'package:avaliacao_2/utils/result.dart';

final class ClienteRepositoryRemote implements ClienteRepository {
  ClienteRepositoryRemote({required ApiClient apiClient})
    : _apiClient = apiClient;

  final ApiClient _apiClient;

  @override
  Future<Result<List<ClienteModel>>> getClientes() async {
    final result = await _apiClient.get<List<ClienteModel>>(
      '/clientes',
      decoder: (data) => (data as List)
          .map((e) => ClienteModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    return result.map((response) => response.data);
  }
}
