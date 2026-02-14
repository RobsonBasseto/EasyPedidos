import 'package:easy_pedidos_flutter/services/pedido_service.dart';
import 'package:easy_pedidos_flutter/services/produto_service.dart';
import 'package:easy_pedidos_flutter/theme/app_theme.dart';
import 'package:easy_pedidos_flutter/viewmodels/detalhes_pedido_viewmodel.dart';
import 'package:easy_pedidos_flutter/viewmodels/editar_pedido_viewmodel.dart';
import 'package:easy_pedidos_flutter/viewmodels/finalizar_pedido_viewmodel.dart';
import 'package:easy_pedidos_flutter/viewmodels/list_pedido_viewmodel.dart';
import 'package:easy_pedidos_flutter/viewmodels/pedido_viewmodel.dart';
import 'package:easy_pedidos_flutter/views/detalhes_pedido_page.dart';
import 'package:easy_pedidos_flutter/views/editar_pedido_page.dart';
import 'package:easy_pedidos_flutter/views/finalizar_pedido_page.dart';
import 'package:easy_pedidos_flutter/views/list_pedido_page.dart';
import 'package:easy_pedidos_flutter/views/pedido_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class EasyPedidosApp extends StatelessWidget {
  const EasyPedidosApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<PedidoService>(
          create: (_) => PedidoService(),
          dispose: (_, service) => service.dispose(),
        ),
        Provider<ProdutoService>(
          create: (_) => ProdutoService(),
        ),
        ChangeNotifierProvider<ListPedidoViewModel>(
          create: (context) => ListPedidoViewModel(
            context.read<PedidoService>(),
          ),
        ),
        ChangeNotifierProvider<DetalhesPedidoViewModel>(
          create: (context) => DetalhesPedidoViewModel(
            context.read<PedidoService>(),
          ),
        ),
        ChangeNotifierProvider<FinalizarPedidoViewModel>(
          create: (context) => FinalizarPedidoViewModel(
            context.read<PedidoService>(),
          ),
        ),
        ChangeNotifierProvider<PedidoViewModel>(
          create: (context) => PedidoViewModel(
            context.read<PedidoService>(),
            context.read<ProdutoService>(),
          ),
        ),
        ChangeNotifierProvider<EditarPedidoViewModel>(
          create: (context) => EditarPedidoViewModel(
            context.read<PedidoService>(),
            context.read<ProdutoService>(),
          ),
        ),
      ],
      child: MaterialApp.router(
        title: 'Easy Pedidos',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        routerConfig: _router,
      ),
    );
  }

  static final GoRouter _router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const ListPedidoPage(),
      ),
      GoRoute(
        path: '/detalhes/:pedidoId',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['pedidoId']!);
          return DetalhesPedidoPage(pedidoId: id);
        },
      ),
      GoRoute(
        path: '/finalizar/:pedidoId',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['pedidoId']!);
          return FinalizarPedidoPage(pedidoId: id);
        },
      ),
      GoRoute(
        path: '/novo-pedido',
        builder: (context, state) => const PedidoPage(),
      ),
      GoRoute(
        path: '/editar/:pedidoId',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['pedidoId']!);
          return EditarPedidoPage(pedidoId: id);
        },
      ),
    ],
  );
}
