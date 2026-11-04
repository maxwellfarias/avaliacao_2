import 'package:flutter/material.dart';

/// Tela inicial para acompanhamento dos pedidos do delivery.
class PedidoScreen extends StatefulWidget {
  const PedidoScreen({super.key});

  @override
  State<PedidoScreen> createState() => _PedidoScreenState();
}

class _PedidoScreenState extends State<PedidoScreen> {
  static const _filtros = <String>[
    'Todos',
    'Pendente',
    'Em preparo',
    'Pronto',
    'Entregue',
  ];

  final List<_PedidoItem> _pedidos = [
    const _PedidoItem(
      id: 2,
      valor: 65.00,
      itens: '2x Hambúrguer Artesanal, 1x Fritas',
      status: 'Pendente',
      pago: false,
      icon: Icons.lunch_dining_outlined,
    ),
    const _PedidoItem(
      id: 1,
      valor: 78.50,
      itens: '1x Pizza Calabresa, Guaraná 2L',
      status: 'Em preparo',
      pago: true,
      icon: Icons.local_pizza_outlined,
    ),
  ];

  String _filtroSelecionado = 'Todos';

  List<_PedidoItem> get _pedidosFiltrados {
    if (_filtroSelecionado == 'Todos') return _pedidos;
    return _pedidos
        .where((pedido) => pedido.status == _filtroSelecionado)
        .toList();
  }

  void _mostrarMensagem(String mensagem) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(mensagem)));
  }

  void _excluirPedido(_PedidoItem pedido) {
    setState(() => _pedidos.remove(pedido));
    _mostrarMensagem('Pedido #${pedido.id} excluído.');
  }

  @override
  Widget build(BuildContext context) {
    final pedidos = _pedidosFiltrados;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Delivery Hub'),
        actions: [
          IconButton(
            tooltip: 'Atualizar pedidos',
            icon: const Icon(Icons.refresh),
            onPressed: () => _mostrarMensagem('Pedidos atualizados.'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Adicionar pedido',
        onPressed: () => _mostrarMensagem('Adicionar novo pedido.'),
        child: const Icon(Icons.add),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'FILTROS:',
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _filtros.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final filtro = _filtros[index];
                return FilterChip(
                  label: Text(filtro),
                  selected: _filtroSelecionado == filtro,
                  onSelected: (_) {
                    setState(() => _filtroSelecionado = filtro);
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: pedidos.isEmpty
                ? const Center(child: Text('Nenhum pedido encontrado.'))
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
                    itemCount: pedidos.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final pedido = pedidos[index];
                      return Card(
                        child: ListTile(
                          isThreeLine: true,
                          leading: CircleAvatar(child: Icon(pedido.icon)),
                          title: Text(
                            'Pedido #${pedido.id} - ${_formatarMoeda(pedido.valor)}',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              '${pedido.itens}\n'
                              'Status: ${pedido.status.toLowerCase()} | '
                              'Pago: ${pedido.pago ? 'Sim' : 'Não'}',
                            ),
                          ),
                          trailing: _AcoesPedido(
                            onEditar: () => _mostrarMensagem(
                              'Editar pedido #${pedido.id}.',
                            ),
                            onExcluir: () => _excluirPedido(pedido),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  String _formatarMoeda(double valor) =>
      'R\$ ${valor.toStringAsFixed(2).replaceAll('.', ',')}';
}

class _AcoesPedido extends StatelessWidget {
  const _AcoesPedido({required this.onEditar, required this.onExcluir});

  final VoidCallback onEditar;
  final VoidCallback onExcluir;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          tooltip: 'Editar pedido',
          icon: const Icon(Icons.edit_outlined),
          onPressed: onEditar,
        ),
        IconButton(
          tooltip: 'Excluir pedido',
          icon: const Icon(Icons.delete_outline),
          color: Theme.of(context).colorScheme.error,
          onPressed: onExcluir,
        ),
      ],
    );
  }
}

class _PedidoItem {
  const _PedidoItem({
    required this.id,
    required this.valor,
    required this.itens,
    required this.status,
    required this.pago,
    required this.icon,
  });

  final int id;
  final double valor;
  final String itens;
  final String status;
  final bool pago;
  final IconData icon;
}
