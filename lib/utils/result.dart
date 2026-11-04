// =============================================================================
// 🎯 RESULT PATTERN - IMPLEMENTAÇÃO COMPLETA E DOCUMENTADA
// =============================================================================
//
// 📚 O QUE É O RESULT PATTERN?
//
// O Result Pattern é uma abordagem funcional para tratamento de erros que
// encapsula operações que podem falhar em um tipo seguro, evitando exceptions
// não tratadas e tornando o código mais previsível e confiável.
//
// 🤔 POR QUE USAR?
//
// PROBLEMAS QUE RESOLVE:
// ❌ try/catch espalhados por todo o código
// ❌ Exceptions não tratadas que quebram a aplicação
// ❌ Dificuldade para compor operações que podem falhar
// ❌ Falta de clareza sobre quais métodos podem gerar erro
// ❌ Código verboso para tratar múltiplas operações encadeadas
//
// ✅ BENEFÍCIOS:
// ✅ Type Safety: o tipo Result<T> força você a tratar tanto sucesso quanto erro
// ✅ Composabilidade: permite encadear operações com map/flatMap de forma elegante
// ✅ Legibilidade: código mais limpo e expressivo
// ✅ Predictabilidade: fica explícito no tipo de retorno que a operação pode falhar
// ✅ Testabilidade: mais fácil de testar cenários de erro
//
// 🆚 COMPARAÇÃO: ANTES vs DEPOIS
//
// ANTES (try/catch tradicional):
// ```dart
// Future<String> buscarNomeUsuario(int id) async {
//   try {
//     final user = await getUserById(id);
//     if (user == null) throw Exception('Usuário não encontrado');
//     final profile = await getProfile(user.profileId);
//     return profile.name.toUpperCase();
//   } catch (e) {
//     // Como tratar diferentes tipos de erro?
//     // Como compor com outras operações?
//     rethrow;
//   }
// }
// ```
//
// DEPOIS (Result Pattern):
// ```dart
// Future<Result<String>> buscarNomeUsuario(int id) async {
//   return await getUserById(id)
//     .flatMapAsync((user) => getProfile(user.profileId))
//     .map((profile) => profile.name.toUpperCase());
// }
//
// // Uso:
// final resultado = await buscarNomeUsuario(123);
// resultado.when(
//   onOk: (nome) => print('Nome: $nome'),
//   onError: (erro) => print('Erro: $erro'),
// );
// ```
//
// 🧠 CONCEITOS FUNDAMENTAIS:
//
// Result<T> pode ser:
// • Ok<T>: operação bem-sucedida, contém o valor T
// • Error<T>: operação falhou, contém uma AppException
//
// Exemplos de tipos:
// • Result<String> → pode ser Ok('João') ou Error(exception)
// • Result<List<User>> → pode ser Ok([user1, user2]) ou Error(exception)
// • Result<void> → pode ser Ok(void) ou Error(exception) para operações sem retorno
//
// =============================================================================


import 'package:avaliacao_2/exceptions/app_exception.dart';

/// 🎯 **Result Pattern** - Classe base para operações que podem falhar
///
/// Encapsula o resultado de operações que podem ser bem-sucedidas (`Ok<T>`)
/// ou falhar (`Error<T>`), forçando o tratamento explícito de ambos os casos.
///
/// **📋 Casos de uso comuns:**
/// - 🌐 Chamadas de API que podem retornar erro HTTP
/// - 💾 Operações de banco de dados que podem falhar
/// - ✅ Validações que podem ser inválidas
/// - 📁 Operações de arquivo que podem não existir
/// - 🔄 Transformações de dados que podem ser inconsistentes
///
/// **🚀 Exemplo básico:**
/// ```dart
/// // Função que pode falhar
/// Result<int> dividir(int a, int b) {
///   if (b == 0) {
///     return Result.error(ValidationException('Divisão por zero'));
///   }
///   return Result.ok(a ~/ b);
/// }
///
/// // Uso seguro
/// final resultado = dividir(10, 2);
/// resultado.when(
///   onOk: (valor) => print('Resultado: $valor'), // Imprime: Resultado: 5
///   onError: (erro) => print('Erro: $erro'),
/// );
/// ```
sealed class Result<T> {
  const Result();

  /// 🎉 **Criar um resultado de SUCESSO**
  ///
  /// Use quando a operação foi bem-sucedida e você tem um valor válido.
  ///
  /// **Exemplo:**
  /// ```dart
  /// // Login bem-sucedido
  /// return Result.ok(user);
  ///
  /// // Validação passou
  /// return Result.ok("Email válido");
  ///
  /// // Lista encontrada
  /// return Result.ok([item1, item2, item3]);
  /// ```
  const factory Result.ok(T value) = Ok._;

  /// ❌ **Criar um resultado de ERRO**
  ///
  /// Use quando a operação falhou e você quer comunicar o erro de forma segura.
  ///
  /// **Exemplo:**
  /// ```dart
  /// // Credenciais inválidas
  /// return Result.error(AuthenticationException('Senha incorreta'));
  ///
  /// // Validação falhou
  /// return Result.error(ValidationException('Email inválido'));
  ///
  /// // Recurso não encontrado
  /// return Result.error(NotFoundException('Usuário não existe'));
  /// ```
  const factory Result.error(AppException error) = Error._;

  /// ✅ **Verifica se o resultado é um sucesso**
  ///
  /// Retorna `true` se contém um valor válido, `false` se contém erro.
  ///
  /// **Exemplo:**
  /// ```dart
  /// final resultado = await fazerLogin('user', 'pass');
  /// if (resultado.isOk) {
  ///   print('Login realizado com sucesso!');
  /// }
  /// ```
  bool get isOk => this is Ok<T>;

  /// ❌ **Verifica se o resultado é um erro**
  ///
  /// Retorna `true` se contém um erro, `false` se contém valor válido.
  ///
  /// **Exemplo:**
  /// ```dart
  /// final resultado = await validarEmail('email@inválido');
  /// if (resultado.isError) {
  ///   print('Email possui formato inválido');
  /// }
  /// ```
  bool get isError => this is Error<T>;

  // ---------------------------------------------------------------------------
  // 🔧 MÉTODOS DE TRANSFORMAÇÃO - O PODER DO RESULT PATTERN
  // ---------------------------------------------------------------------------

  /// 🔄 **Transformar o valor de sucesso (map)**
  ///
  /// Aplica uma função de transformação apenas se o resultado for `Ok<T>`.
  /// Se for `Error`, o erro é mantido inalterado.
  ///
  /// **Quando usar:** Para converter/transformar dados sem risco de falha adicional.
  ///
  /// **💡 Dica:** Use `map` quando a transformação SEMPRE funciona (ex: toString, toUpperCase, length).
  ///
  /// **📋 Exemplos práticos:**
  /// ```dart
  /// // Converter nome para maiúsculo
  /// final resultado = Result.ok('joão')
  ///   .map((nome) => nome.toUpperCase()); // Result.ok('JOÃO')
  ///
  /// // Calcular tamanho de uma lista
  /// final usuarios = Result.ok(['Ana', 'Carlos', 'Maria']);
  /// final tamanho = usuarios.map((lista) => lista.length); // Result.ok(3)
  ///
  /// // Se for erro, a transformação é ignorada
  /// final erro = Result<String>.error(ValidationException('Inválido'));
  /// final tentativa = erro.map((s) => s.toUpperCase()); // Continua sendo Error
  /// ```
  Result<R> map<R>(R Function(T value) transform) => switch (this) {
    Ok(:final value) => Result.ok(transform(value)),
    Error(:final error) => Result.error(error),
  };

  /// ⛓️ **Encadear operações que podem falhar (flatMap)**
  ///
  /// Aplica uma transformação que também retorna um `Result<R>`.
  /// **EVITA** o problema de `Result<Result<T>>` aninhados.
  ///
  /// **Quando usar:** Para operações que podem falhar (validações, buscas, etc.).
  ///
  /// **⚠️ Atenção:** Use `flatMap` quando a função retorna `Result<R>`, não apenas `R`.
  ///
  /// **📋 Exemplos práticos:**
  /// ```dart
  /// // Validar email e depois buscar usuário
  /// Result<String> validarEmail(String email) {
  ///   if (email.contains('@')) return Result.ok(email);
  ///   return Result.error(ValidationException('Email inválido'));
  /// }
  ///
  /// Result<User> buscarUsuario(String email) {
  ///   // Simula busca que pode falhar
  ///   if (email == 'admin@teste.com') {
  ///     return Result.ok(User(name: 'Admin'));
  ///   }
  ///   return Result.error(NotFoundException('Usuário não encontrado'));
  /// }
  ///
  /// // Encadeamento seguro
  /// final resultado = validarEmail('admin@teste.com')
  ///   .flatMap((emailValido) => buscarUsuario(emailValido));
  /// // Se email for inválido → Error de validação
  /// // Se email válido mas usuário não existe → Error de not found
  /// // Se tudo OK → Ok(User)
  /// ```
  Result<R> flatMap<R>(Result<R> Function(T value) transform) => switch (this) {
    Ok(:final value) => transform(value),
    Error(:final error) => Result.error(error),
  };

  /// 🔧 **Transformar apenas o erro (mapError)**
  ///
  /// Permite modificar o tipo ou mensagem do erro mantendo o valor de sucesso inalterado.
  ///
  /// **Quando usar:** Para personalizar mensagens de erro ou converter tipos de exceção.
  ///
  /// **📋 Exemplos práticos:**
  /// ```dart
  /// // Personalizar mensagem de erro
  /// final resultado = buscarUsuario(123)
  ///   .mapError((erro) => UnknownErrorException('Falha na busca: ${erro.message}'));
  ///
  /// // Converter tipo de erro
  /// final validacao = validarIdade(-5)
  ///   .mapError((erro) => ValidationException('Idade deve ser positiva'));
  /// ```
  Result<T> mapError(AppException Function(AppException error) transform) =>
      switch (this) {
        Ok(:final value) => Result.ok(value),
        Error(:final error) => Result.error(transform(error)),
      };

  /// 🎭 **Processar ambos os casos (fold)**
  ///
  /// Executa uma função diferente para sucesso e erro, retornando um único tipo.
  /// Útil para converter `Result<T>` em qualquer outro tipo (`String`, `Widget`, etc.).
  ///
  /// **Quando usar:** Para "extrair" um valor final do Result, tratando ambos os casos.
  ///
  /// **📋 Exemplos práticos:**
  /// ```dart
  /// // Converter para mensagem de texto
  /// String obterMensagem(Result<User> resultado) {
  ///   return resultado.fold(
  ///     onOk: (user) => 'Bem-vindo, ${user.name}!',
  ///     onError: (erro) => 'Erro: ${erro.message}',
  ///   );
  /// }
  ///
  /// // Converter para Widget no Flutter
  /// Widget buildStatus(Result<List<Item>> items) {
  ///   return items.fold(
  ///     onOk: (lista) => SelectableText('${lista.length} itens encontrados'),
  ///     onError: (erro) => SelectableText('Erro: ${erro.message}', style: TextStyle(color: Colors.red)),
  ///   );
  /// }
  /// ```
  R fold<R>({
    required R Function(T value) onOk,
    required R Function(Exception error) onError,
  }) => switch (this) {
    Ok(:final value) => onOk(value),
    Error(:final error) => onError(error),
  };

  /// 🎯 **Obter valor ou null (getSuccessOrNull)**
  ///
  /// Retorna o valor se for `Ok<T>`, ou `null` se for `Error`.
  ///
  /// **⚠️ Atenção:** Use com moderação! Preferencialmente use `when` ou `fold`.
  ///
  /// **📋 Exemplo:**
  /// ```dart
  /// final user = await buscarUsuario(123).getSuccessOrNull();
  /// if (user != null) {
  ///   print('Usuário: ${user.name}');
  /// }
  /// ```
  T? getSuccessOrNull() => switch (this) {
    Ok(:final value) => value,
    Error() => null,
  };

  /// ❌ **Obter erro ou null (getErrorOrNull)**
  ///
  /// Retorna o erro se for `Error<T>`, ou `null` se for `Ok`.
  ///
  /// **📋 Exemplo:**
  /// ```dart
  /// final erro = resultado.getErrorOrNull();
  /// if (erro != null) {
  ///   logger.error('Falha na operação: ${erro.message}');
  /// }
  /// ```
  AppException? getErrorOrNull() => switch (this) {
    Ok() => null,
    Error(:final error) => error,
  };
}

/// 🎉 **Resultado de SUCESSO** - `Ok<T>`
///
/// Representa uma operação que foi concluída com êxito e contém um valor do tipo `T`.
///
/// **📋 Características:**
/// - Immutable: o valor não pode ser alterado após criação
/// - Type Safe: garante que o valor é do tipo correto
/// - Facilita o encadeamento de operações subsequentes
///
/// **🚀 Exemplos de criação:**
/// ```dart
/// // Operação bem-sucedida retornando string
/// final nomeUsuario = Result.ok('Maria Silva');
///
/// // Lista de dados encontrada
/// final usuarios = Result.ok([user1, user2, user3]);
///
/// // Operação sem retorno (void) bem-sucedida
/// final salvamento = Result<void>.ok(null);
/// ```
final class Ok<T> extends Result<T> {
  const Ok._(this.value);

  /// 📦 **Valor contido no resultado de sucesso**
  ///
  /// Este é o dado real retornado pela operação bem-sucedida.
  ///
  /// **💡 Dica:** Acesse via `when`, `fold` ou métodos de transformação
  /// em vez de acessar diretamente.
  final T value;

  @override
  String toString() => 'Result<$T>.ok($value)';
}

/// ❌ **Resultado de ERRO** - `Error<T>`
///
/// Representa uma operação que falhou e contém informações sobre o erro ocorrido.
///
/// **📋 Características:**
/// - Contém sempre uma AppException com detalhes do erro
/// - Preserva o tipo T original (mesmo sendo erro)
/// - Permite propagação segura de erros através do pipeline
///
/// **🚨 Tipos de erro comuns:**
/// ```dart
/// // Erro de autenticação
/// final loginFalhou = Result<User>.error(
///   AuthenticationException('Credenciais inválidas')
/// );
///
/// // Erro de validação
/// final emailInvalido = Result<String>.error(
///   ValidationException('Email deve conter @')
/// );
///
/// // Erro de recurso não encontrado
/// final usuarioNaoExiste = Result<User>.error(
///   NotFoundException('Usuário ID 123 não encontrado')
/// );
/// ```
final class Error<T> extends Result<T> {
  const Error._(this.error);

  /// 🚨 **Exceção que causou a falha**
  ///
  /// Contém detalhes específicos sobre o que deu errado durante a operação.
  ///
  /// **💡 Dica:** Use `when` ou `fold` para acessar e tratar este erro
  /// de forma segura.
  final AppException error;

  @override
  String toString() => 'Result<$T>.error($error)';
}

// -----------------------------------------------------------------------------
// 🎭 EXTENSÕES PARA FACILITAR O USO - AÇÚCAR SINTÁTICO
// -----------------------------------------------------------------------------

/// **Extensão `when` - Padrão Match para Results**
///
/// Fornece uma sintaxe elegante para tratar tanto sucesso quanto erro
/// de forma explícita e obrigatória.
///
/// **🎯 Por que usar `when`?**
/// - Força você a considerar ambos os casos (sucesso E erro)
/// - Sintaxe mais limpa que switch manual
/// - Ideal para side effects (logging, navigation, UI updates)
///
/// **📋 Exemplos práticos no mundo real:**
extension ResultWhenExt<T> on Result<T> {
  /// 🎭 **Executar ações baseadas no resultado**
  ///
  /// Execute funções diferentes dependendo se é `Ok` ou `Error`.
  /// Ideal para side effects como mostrar mensagens, navegar, etc.
  ///
  /// **📋 Casos de uso comuns:**
  /// ```dart
  /// // 1. NAVEGAÇÃO baseada no resultado do login
  /// final loginResult = await authService.login(email, senha);
  /// loginResult.when(
  ///   onOk: (user) => navigator.pushReplacement('/home'),
  ///   onError: (erro) => showSnackBar('Login falhou: ${erro.message}'),
  /// );
  ///
  /// // 2. ATUALIZAÇÃO DE ESTADO na UI
  /// final dadosResult = await apiService.buscarDados();
  /// dadosResult.when(
  ///   onOk: (dados) {
  ///     setState(() {
  ///       this.dados = dados;
  ///       isLoading = false;
  ///     });
  ///   },
  ///   onError: (erro) {
  ///     setState(() {
  ///       errorMessage = erro.message;
  ///       isLoading = false;
  ///     });
  ///   },
  /// );
  ///
  /// // 3. LOGGING detalhado
  /// resultado.when(
  ///   onOk: (valor) => logger.info('Operação bem-sucedida: $valor'),
  ///   onError: (erro) => logger.error('Falha na operação: ${erro.message}'),
  /// );
  ///
  /// // 4. VALIDAÇÃO e feedback
  /// final validacao = validarFormulario(dados);
  /// validacao.when(
  ///   onOk: (_) => mostrarMensagem('Formulário válido!'),
  ///   onError: (erro) => destacarCampoInvalido(erro.campo),
  /// );
  /// ```
  void when({
    required void Function(T value) onOk,
    required void Function(AppException error) onError,
  }) {
    switch (this) {
      case Ok(:final value):
        onOk(value);
      case Error(:final error):
        onError(error);
    }
  }
}

/// **Extensão Async - Transformações Assíncronas**
///
/// Permite aplicar transformações assíncronas (que retornam Future) sobre Results,
/// mantendo a segurança de tipos e o tratamento de erros.
///
/// **🎯 Quando usar cada método:**
/// - `mapAsync`: transformação assíncrona que SEMPRE funciona
/// - `flatMapAsync`: transformação assíncrona que PODE falhar (retorna Result)
///
/// **📋 Padrões de uso:**
extension ResultAsyncExt<T> on Result<T> {
  /// 🔄 **Transformação assíncrona segura (mapAsync)**
  ///
  /// Aplica uma transformação assíncrona sobre o valor de sucesso.
  /// Use quando a operação async SEMPRE funciona (ex: formatação, encoding).
  ///
  /// **📋 Exemplos práticos:**
  /// ```dart
  /// // EXEMPLO 1: Fazer upload de arquivo após validação
  /// final validacao = validarArquivo(file);
  /// final resultado = await validacao.mapAsync((arquivo) async {
  ///   // Upload sempre funciona (não pode falhar neste exemplo)
  ///   return await uploadService.enviar(arquivo);
  /// });
  ///
  /// // EXEMPLO 2: Buscar metadados após validar ID
  /// final idValidado = validarId(123);
  /// final metadados = await idValidado.mapAsync((id) async {
  ///   // Busca de metadados que sempre retorna algo
  ///   return await metadataService.obterPorId(id);
  /// });
  ///
  /// // EXEMPLO 3: Processamento assíncrono de dados
  /// final dados = Result.ok(imagemBytes);
  /// final processada = await dados.mapAsync((bytes) async {
  ///   // Processamento que sempre funciona
  ///   return await imageProcessor.redimensionar(bytes);
  /// });
  /// ```
  Future<Result<R>> mapAsync<R>(Future<R> Function(T value) transform) async =>
      switch (this) {
        Ok(:final value) => Result.ok(await transform(value)),
        Error(:final error) => Result.error(error),
      };

  /// ⛓️ **Encadeamento assíncrono que pode falhar (flatMapAsync)**
  ///
  /// Aplica uma transformação assíncrona que também retorna `Result<R>`.
  /// Use quando a operação async PODE falhar.
  ///
  /// **📋 Exemplos práticos:**
  /// ```dart
  /// // EXEMPLO 1: Login → Buscar perfil → Carregar preferências
  /// final resultado = await validarCredenciais(email, senha)
  ///   .flatMapAsync((user) => buscarPerfil(user.id))        // Pode falhar
  ///   .flatMapAsync((perfil) => carregarPreferencias(perfil.id)); // Pode falhar
  ///
  /// // Se qualquer etapa falhar, o erro é propagado automaticamente
  ///
  /// // EXEMPLO 2: Validar → Salvar → Notificar
  /// final salvamento = await validarDados(formulario)
  ///   .flatMapAsync((dados) => repositorio.salvar(dados))   // Pode falhar
  ///   .flatMapAsync((saved) => notificarUsuario(saved.id)); // Pode falhar
  ///
  /// // EXEMPLO 3: Upload com validação e processamento
  /// final upload = await validarArquivo(file)
  ///   .flatMapAsync((arquivo) => uploadService.enviar(arquivo)) // Pode falhar
  ///   .flatMapAsync((url) => gerarThumbnail(url));              // Pode falhar
  ///
  /// // Tratamento final
  /// upload.when(
  ///   onOk: (thumb) => print('Upload completo: $thumb'),
  ///   onError: (erro) => print('Falha: ${erro.message}'),
  /// );
  /// ```
  Future<Result<R>> flatMapAsync<R>(
    Future<Result<R>> Function(T value) transform,
  ) async => switch (this) {
    Ok(:final value) => await transform(value),
    Error(:final error) => Result.error(error),
  };
}

/// **Extensão `Future<Result<T>>` - Pipeline Assíncrono Completo**
///
/// Esta é a extensão mais poderosa! Permite encadear operações assíncronas
/// de forma fluida, criando pipelines complexos de transformação.
///
/// **🎯 Problema que resolve:**
/// Evita código verboso com `.then()` e múltiplos `await` aninhados.
///
/// **🚀 EXEMPLO COMPLETO - Sistema de Contrato:**
/// ```dart
/// // Pipeline completo: validar → buscar → processar → salvar
/// final resultado = await validarCpf(cpf)                    // Result<String>
///   .flatMapAsync((cpfValido) => buscarUsuario(cpfValido))   // Future<Result<User>>
///   .flatMapAsync((user) => gerarContrato(user))             // Future<Result<Contrato>>
///   .mapAsync((contrato) => adicionarTimestamp(contrato))    // Future<Result<Contrato>>
///   .flatMapAsync((contrato) => salvarContrato(contrato));   // Future<Result<String>>
///
/// resultado.when(
///   onOk: (id) => print('Contrato criado com ID: $id'),
///   onError: (erro) => print('Falha: ${erro.message}'),
/// );
/// ```
extension FutureResultExt<T> on Future<Result<T>> {
  /// 🔄 **Transformação assíncrona sobre `Future<Result<T>>`**
  ///
  /// Aplica uma transformação assíncrona que SEMPRE funciona.
  ///
  /// **📋 Casos de uso:**
  /// ```dart
  /// // Buscar usuário e formatar dados para exibição
  /// final usuario = await apiService.buscarUsuario(123)      // Future<Result<User>>
  ///   .mapAsync((user) => formatarNomeCompleto(user))        // Future<Result<String>>
  ///   .mapAsync((nome) => adicionarPrefixo("Sr. ", nome));   // Future<Result<String>>
  ///
  /// // Upload de arquivo com geração de metadados
  /// final upload = await uploadService.enviarArquivo(file)   // Future<Result<UploadInfo>>
  ///   .mapAsync((info) => gerarMetadados(info))              // Future<Result<Metadata>>
  ///   .mapAsync((meta) => calcularChecksum(meta));           // Future<Result<String>>
  /// ```
  Future<Result<R>> mapAsync<R>(Future<R> Function(T value) transform) async {
    final result = await this;
    return switch (result) {
      Ok(:final value) => Result.ok(await transform(value)),
      Error(:final error) => Result.error(error),
    };
  }

  /// 🔄 **Transformação síncrona sobre `Future<Result<T>>`**
  ///
  /// Aplica uma transformação simples que não envolve async.
  ///
  /// **📋 Casos de uso:**
  /// ```dart
  /// // Buscar lista e contar elementos
  /// final count = await apiService.buscarItens()        // Future<Result<List<Item>>>
  ///   .map((lista) => lista.length);                    // Future<Result<int>>
  ///
  /// // Buscar usuário e extrair email
  /// final email = await userService.buscarPorId(123)    // Future<Result<User>>
  ///   .map((user) => user.email);                       // Future<Result<String>>
  ///
  /// // Converter dados para JSON
  /// final json = await dataService.buscarConfig()       // Future<Result<Config>>
  ///   .map((config) => config.toJson());                // Future<Result<Map>>
  /// ```
  Future<Result<R>> map<R>(R Function(T value) transform) async {
    final result = await this;
    return switch (result) {
      Ok(:final value) => Result.ok(transform(value)),
      Error(:final error) => Result.error(error),
    };
  }

  /// ⛓️ **Encadeamento assíncrono que pode falhar**
  ///
  /// A operação mais poderosa! Encadeia operações que retornam `Future<Result<R>>`.
  ///
  /// **📋 EXEMPLO REAL - Sistema de E-commerce:**
  /// ```dart
  /// // Pipeline completo de checkout
  /// final checkout = await validarCarrinho(carrinho)           // Result<Carrinho>
  ///   .flatMapAsync((carr) => aplicarDesconto(carr))           // Future<Result<Carrinho>>
  ///   .flatMapAsync((carr) => calcularFrete(carr))             // Future<Result<Pedido>>
  ///   .flatMapAsync((pedido) => processarPagamento(pedido))    // Future<Result<Pagamento>>
  ///   .flatMapAsync((pag) => confirmarPedido(pag))             // Future<Result<String>>
  ///   .flatMapAsync((id) => enviarEmailConfirmacao(id));       // Future<Result<void>>
  ///
  /// // Se QUALQUER etapa falhar, o erro é propagado
  /// checkout.when(
  ///   onOk: (_) => navegarParaConfirmacao(),
  ///   onError: (erro) => mostrarErroCheckout(erro),
  /// );
  /// ```
  Future<Result<R>> flatMapAsync<R>(
    Future<Result<R>> Function(T value) transform,
  ) async {
    final result = await this;
    return switch (result) {
      Ok(:final value) => await transform(value),
      Error(:final error) => Result.error(error),
    };
  }

  /// ⛓️ **Encadeamento síncrono que pode falhar**
  ///
  /// Encadeia operações síncronas que retornam `Result<R>`.
  ///
  /// **📋 Casos de uso:**
  /// ```dart
  /// // Validação em sequência
  /// final validacao = await buscarFormulario(id)           // Future<Result<Form>>
  ///   .flatMap((form) => validarCamposObrigatorios(form))  // Result<Form>
  ///   .flatMap((form) => validarRegrasNegocio(form));      // Result<Form>
  ///
  /// // Transformação com validação
  /// final dados = await carregarArquivo(path)              // Future<Result<String>>
  ///   .flatMap((content) => parseJson(content))            // Result<Map>
  ///   .flatMap((json) => validarEstrutura(json));          // Result<Data>
  /// ```
  Future<Result<R>> flatMap<R>(Result<R> Function(T value) transform) async {
    final result = await this;
    return switch (result) {
      Ok(:final value) => transform(value),
      Error(:final error) => Result.error(error),
    };
  }

  /// 🎭 **Processar resultado assíncrono com when**
  ///
  /// Executa ações diferentes baseadas no resultado final do pipeline.
  ///
  /// **📋 Exemplo prático:**
  /// ```dart
  /// // Pipeline com tratamento direto
  /// await apiService.buscarDados()
  ///   .flatMapAsync((dados) => processarDados(dados))
  ///   .mapAsync((processed) => salvarCache(processed))
  ///   .when(
  ///     onOk: (cached) {
  ///       notificarSucesso('Dados processados e salvos');
  ///       atualizarUI(cached);
  ///     },
  ///     onError: (erro) {
  ///       logError('Pipeline falhou', erro);
  ///       mostrarMensagemErro(erro.message);
  ///     },
  ///   );
  /// ```
  void when({
    required void Function(T value) onOk,
    required void Function(AppException error) onError,
  }) async {
    final result = await this;
    switch (result) {
      case Ok(:final value):
        onOk(value);
      case Error(:final error):
        onError(error);
    }
  }
}

// =============================================================================
// 📚 GUIA PRÁTICO - COMO USAR RESULT PATTERN NO DIA A DIA
// =============================================================================
//
// 🎯 ESCOLHENDO O MÉTODO CERTO:
//
// ┌─────────────────┬─────────────────┬─────────────────────────────────────┐
// │ SITUAÇÃO        │ MÉTODO          │ EXEMPLO                             │
// ├─────────────────┼─────────────────┼─────────────────────────────────────┤
// │ Transformar     │ .map()          │ .map((user) => user.name)           │
// │ dados simples   │                 │                                     │
// ├─────────────────┼─────────────────┼─────────────────────────────────────┤
// │ Operação que    │ .flatMap()      │ .flatMap((id) => buscarUser(id))    │
// │ pode falhar     │                 │                                     │
// ├─────────────────┼─────────────────┼─────────────────────────────────────┤
// │ Transformação   │ .mapAsync()     │ .mapAsync((data) => process(data))  │
// │ assíncrona      │                 │                                     │
// ├─────────────────┼─────────────────┼─────────────────────────────────────┤
// │ Operação async  │ .flatMapAsync() │ .flatMapAsync((id) => api.get(id))  │
// │ que pode falhar │                 │                                     │
// ├─────────────────┼─────────────────┼─────────────────────────────────────┤
// │ Executar ação   │ .when()         │ .when(onOk: print, onError: log)    │
// │ baseada no tipo │                 │                                     │
// ├─────────────────┼─────────────────┼─────────────────────────────────────┤
// │ Converter para  │ .fold()         │ .fold(onOk: (v) => v, onError: "") │
// │ outro tipo      │                 │                                     │
// └─────────────────┴─────────────────┴─────────────────────────────────────┘
//
// 🚨 ANTI-PADRÕES - O QUE NÃO FAZER:
//
// ❌ NÃO use .getSuccessOrNull() sem verificar
// ```dart
// final user = resultado.getSuccessOrNull()!; // PERIGOSO!
// ```
//
// ✅ FAÇA assim:
// ```dart
// resultado.when(
//   onOk: (user) => useUser(user),
//   onError: (error) => handleError(error),
// );
// ```
//
// ❌ NÃO aninha Results
// ```dart
// Result<Result<User>> // ERRADO!
// ```
//
// ✅ USE flatMap para evitar aninhamento:
// ```dart
// result.flatMap((data) => parseUser(data)) // Result<User>
// ```
//
// 🎯 PADRÕES COMUNS POR CONTEXTO:
//
// 📞 CHAMADAS DE API:
// ```dart
// Future<Result<User>> buscarUsuario(int id) async {
//   return await apiClient.get('/users/$id')
//     .flatMap((json) => parseUser(json))
//     .mapError((e) => NetworkException('Falha ao buscar usuário'));
// }
// ```
//
// ✅ VALIDAÇÃO DE FORMULÁRIOS:
// ```dart
// Result<FormData> validarFormulario(Map<String, String> dados) {
//   return validarEmail(dados['email'])
//     .flatMap((_) => validarSenha(dados['senha']))
//     .flatMap((_) => validarIdade(dados['idade']))
//     .map((_) => FormData.fromMap(dados));
// }
// ```
//
// 💾 OPERAÇÕES DE ARQUIVO:
// ```dart
// Future<Result<String>> lerArquivo(String path) async {
//   try {
//     final content = await File(path).readAsString();
//     return Result.ok(content);
//   } catch (e) {
//     return Result.error(FileException('Erro ao ler arquivo: $e'));
//   }
// }
// ```
//
// 🔄 PIPELINE COMPLEXO (Exemplo real):
// ```dart
// // Sistema de upload de imagem com validação e processamento
// Future<Result<String>> uploadImagem(File arquivo) async {
//   return await validarTamanhoArquivo(arquivo)           // Result<File>
//     .flatMap((file) => validarFormatoImagem(file))      // Result<File>
//     .flatMapAsync((file) => comprimirImagem(file))      // Future<Result<File>>
//     .flatMapAsync((compressed) => uploadS3(compressed)) // Future<Result<String>>
//     .flatMapAsync((url) => salvarBancoDados(url));      // Future<Result<String>>
// }
// ```
//
// 💡 DICAS AVANÇADAS:
//
// 1. Para múltiplas validações independentes, considere combinar Results:
// ```dart
// final email = validarEmail(form.email);
// final senha = validarSenha(form.senha);
// // Combine de acordo com suas necessidades
// ```
//
// 2. Use mapError para contexto específico:
// ```dart
// resultado.mapError((e) =>
//   CustomException('Falha no contexto X: ${e.message}')
// );
// ```
//
// 3. Para debugging, use toString():
// ```dart
// print(resultado); // Result<User>.ok(User(...)) ou Result<User>.error(...)
// ```
//
// =============================================================================
