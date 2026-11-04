sealed class AppException implements Exception {
  AppException(this.code, this.message);
  final String code;
  final String message;

  @override
  String toString() => message;
}

//MARK: Auth
class UsuarioOuSenhaInvalidoException extends AppException {
  UsuarioOuSenhaInvalidoException()
    : super(
        'usuario-ou-senha-invalido',
        'Usuário ou senha inválidos. Verifique seus dados e tente novamente.',
      );
}

/// Sessão expirada
class SessaoExpiradaException extends AppException {
  SessaoExpiradaException()
    : super(
        'sessao-expirada',
        'Sua sessão expirou. Por favor, faça login novamente para continuar.',
      );
}

//MARK: Rede

/// Acesso negado ao recurso solicitado.
class AcessoNegadoException extends AppException {
  AcessoNegadoException()
    : super(
        'acesso-negado',
        'Você não tem permissão para acessar este recurso.',
      );
}

/// O dispositivo não está conectado à internet.
class SemConexaoException extends AppException {
  SemConexaoException()
    : super(
        'sem-conexao',
        'Sem conexão com a internet. Por favor, verifique sua rede e tente novamente.',
      );
}

class LocalizacaoIndisponivelException extends AppException {
  LocalizacaoIndisponivelException([String? message])
    : super(
        'localizacao-indisponivel',
        message ??
            'Não foi possível obter a localização. Você pode selecionar o ponto no mapa ou preencher manualmente.',
      );
}

//MARK: Erros servidor

/// A requisição para o servidor demorou demais para responder.
class CepNaoEncontradoException extends AppException {
  CepNaoEncontradoException()
    : super('cep-nao-encontrado', 'O CEP informado não foi encontrado.');
}

class WhatsAppApiException extends AppException {
  WhatsAppApiException()
    : super(
        'whatsapp-api-exception',
        'Ocorreu um erro durante o envio da mensagem via WhatsApp. Por favor, entre em contato com o suporte.',
      );
}

/// A requisição para o servidor demorou demais para responder.
class TimeoutDeRequisicaoException extends AppException {
  TimeoutDeRequisicaoException()
    : super(
        'timeout-de-requisicao',
        'O servidor demorou para responder. Verifique sua conexão e tente novamente.',
      );
}

/// Erro genérico para requisições inválidas (HTTP 400).
class RequisicaoInvalidaException extends AppException {
  RequisicaoInvalidaException([String? message])
    : super(
        'requisicao-invalida',
        message ??
            'A requisição enviada é inválida. Verifique os dados e tente novamente.',
      );
}

/// O CPF informado já está associado a outra pessoa ativa.
class CpfJaCadastradoException extends AppException {
  CpfJaCadastradoException()
    : super(
        'cpf-ja-cadastrado',
        'Este CPF já está cadastrado para outra pessoa. Não é possível cadastrar duas pessoas com o mesmo CPF.',
      );
}

class SaldoInsuficienteException extends AppException {
  SaldoInsuficienteException()
    : super(
        'saldo-insuficiente',
        'Saldo insuficiente para realizar esta ação. Por favor, verifique seu saldo e tente novamente.',
      );
}

/// Erro de não autorizado (HTTP 401).
class NaoAutorizadoException extends AppException {
  NaoAutorizadoException()
    : super(
        'nao-autorizado',
        'Você não está autorizado a realizar esta ação. Por favor, verifique suas credenciais.',
      );
}

/// Erro de acesso proibido (HTTP 403).
class AcessoProibidoException extends AppException {
  AcessoProibidoException([String? message])
    : super(
        'acesso-proibido',
        message ??
            'Você não tem permissão para acessar este recurso. Verifique suas credenciais ou entre em contato com o suporte.',
      );
}

/// Erro genérico do servidor (HTTP 500).
class ErroInternoServidorException extends AppException {
  ErroInternoServidorException()
    : super(
        'erro-interno-servidor',
        'Ocorreu um problema no servidor. Nossa equipe já foi notificada. Tente novamente mais tarde.',
      );
}

/// O serviço ou servidor está temporariamente indisponível (HTTP 503).
class ServidorIndisponivelException extends AppException {
  ServidorIndisponivelException()
    : super(
        'servidor-indisponivel',
        'O serviço está temporariamente indisponível. Por favor, tente novamente em alguns minutos.',
      );
}

/// O servidor respondeu com dados incompatíveis com o contrato esperado.
class RespostaInvalidaException extends AppException {
  RespostaInvalidaException()
    : super(
        'resposta-invalida',
        'O servidor enviou uma resposta inválida. Por favor, tente novamente.',
      );
}

/// Limite temporário de chamadas atingido.
class MuitasRequisicoesException extends AppException {
  MuitasRequisicoesException()
    : super(
        'muitas-requisicoes',
        'Muitas solicitações foram realizadas. Aguarde um momento e tente novamente.',
      );
}

/// Erro HTTP não contemplado por uma exceção mais específica.
class ErroHttpException extends AppException {
  ErroHttpException({required this.statusCode, String? serverMessage})
    : super(
        'erro-http-$statusCode',
        serverMessage ??
            'Não foi possível concluir a solicitação (HTTP $statusCode).',
      );

  final int statusCode;
}

/// Erro genérico para quando o recurso solicitado não foi encontrado (HTTP 404).
class RecursoNaoEncontradoException extends AppException {
  RecursoNaoEncontradoException()
    : super(
        'recurso-nao-encontrado',
        'O recurso solicitado não foi encontrado. Verifique o endereço ou tente novamente mais tarde.',
      );
}

/// Erro que indica que a extensão do navegador necessária não está instalada.
class ExtensaoNaoInstaladaException extends AppException {
  ExtensaoNaoInstaladaException()
    : super(
        'extensao-nao-instalada',
        'A extensão no navegador da Bry não está instalada. Por favor, instale a extensão e tente novamente.',
      );
}

//MARK: Exceções genéricas

class ErroDeComunicacaoException extends AppException {
  ErroDeComunicacaoException()
    : super(
        'erro-de-comunicacao',
        'Houve um problema na comunicação com nossos servidores. Por favor, tente novamente mais tarde.',
      );
}

class UnknownErrorException extends AppException {
  UnknownErrorException()
    : super(
        'unknown-error',
        'Ocorreu um erro inesperado. Por favor, tente novamente.',
      );
}

//MARK: Storage
class ErroAoSalvarTokenException extends AppException {
  ErroAoSalvarTokenException()
    : super(
        'erro-ao-salvar-token',
        'Erro ao salvar token de autenticação. Tente novamente.',
      );
}

class ErroAoRecuperarTokenException extends AppException {
  ErroAoRecuperarTokenException()
    : super(
        'erro-ao-recuperar-token',
        'Erro ao recuperar token de autenticação.',
      );
}

class ErroAoLimparDadosException extends AppException {
  ErroAoLimparDadosException()
    : super('erro-ao-limpar-dados', 'Erro ao limpar dados armazenados.');
}

// =============================================================================
// Exceções de regra de negócio do CRM (docs/regras-de-negocio-crm-mvp-simplificado.md)
// =============================================================================

/// RN-AUTH-003 — usuário desativado não faz login.
class UsuarioDesativadoException extends AppException {
  UsuarioDesativadoException()
    : super(
        'usuario-desativado',
        'Seu acesso foi desativado. Fale com o administrador.',
      );
}

/// RN-AUTH-004 / CA-15 — o workspace precisa de ao menos 1 Admin ativo.
class UltimoAdminException extends AppException {
  UltimoAdminException()
    : super(
        'ultimo-admin',
        'Não é possível remover o último Admin. O workspace precisa de ao menos 1 Admin ativo.',
      );
}

/// RN-DEAL-005 — ganho exige valor maior que zero.
class ValorDoNegocioInvalidoException extends AppException {
  ValorDoNegocioInvalidoException([String? message])
    : super(
        'valor-do-negocio-invalido',
        message ?? 'Informe um valor maior que zero.',
      );
}

/// RN-DEAL-006 / CA-08 — perda exige motivo.
class MotivoDePerdaObrigatorioException extends AppException {
  MotivoDePerdaObrigatorioException()
    : super('motivo-de-perda-obrigatorio', 'Selecione o motivo da perda.');
}

/// RN-DEAL-002 / RN-DEAL-007 — o contato já tem outro negócio aberto.
class NegocioAbertoExistenteException extends AppException {
  NegocioAbertoExistenteException({
    required this.openDealId,
    required this.stageName,
    required this.contactName,
    this.ownerName,
  }) : super(
         'negocio-aberto-existente',
         '$contactName já tem um negócio aberto ($stageName'
             '${ownerName == null ? ', sem dono' : ', dono $ownerName'}).',
       );

  final String openDealId;
  final String stageName;
  final String contactName;
  final String? ownerName;
}

/// RN-DEDUP-002 — o e-mail informado pertence a outro contato.
class EmailPertenceAOutroContatoException extends AppException {
  EmailPertenceAOutroContatoException({
    required this.contactId,
    required this.contactName,
  }) : super(
         'email-pertence-a-outro-contato',
         'Este e-mail pertence a $contactName.',
       );

  final String contactId;
  final String contactName;
}

/// RN-DEAL-001 — não é possível excluir etapa com negócios abertos.
class EtapaComNegociosAbertosException extends AppException {
  EtapaComNegociosAbertosException({
    required this.stageId,
    required this.stageName,
    required this.openCount,
  }) : super(
         'etapa-com-negocios-abertos',
         '"$stageName" tem $openCount negócios abertos. Mova-os antes.',
       );

  final String stageId;
  final String stageName;
  final int openCount;
}

/// RN-DEAL-001 — o funil precisa de ao menos 2 etapas.
class MinimoDeEtapasException extends AppException {
  MinimoDeEtapasException()
    : super('minimo-de-etapas', 'O funil precisa de ao menos 2 etapas.');
}

/// RN-DEAL-006 — ao menos um motivo de perda precisa ficar ativo.
class UltimoMotivoAtivoException extends AppException {
  UltimoMotivoAtivoException()
    : super(
        'ultimo-motivo-ativo',
        'Mantenha ao menos um motivo de perda ativo.',
      );
}

/// RN-INGEST-006 — lead sem nome ou sem telefone/e-mail válido.
class LeadInvalidoException extends AppException {
  LeadInvalidoException(String reason) : super('lead-invalido', reason);
}

/// RN-IO-001 — arquivo de importação fora do modelo.
class ArquivoCsvInvalidoException extends AppException {
  ArquivoCsvInvalidoException(String reason)
    : super('arquivo-csv-invalido', reason);
}

/// Funcionalidade que depende do backend real e ainda não existe no modo local.
class FuncionalidadeIndisponivelException extends AppException {
  FuncionalidadeIndisponivelException([String? message])
    : super(
        'funcionalidade-indisponivel',
        message ?? 'Funcionalidade indisponível no momento.',
      );
}

/// O sistema não conseguiu abrir um link externo (`tel:`, `wa.me`, OAuth).
class LinkExternoIndisponivelException extends AppException {
  LinkExternoIndisponivelException()
    : super(
        'link-externo-indisponivel',
        'Não foi possível abrir o aplicativo. Verifique se ele está instalado.',
      );
}
