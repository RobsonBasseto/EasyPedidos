import 'package:easy_pedidos_flutter/models/pedido_model.dart';
import 'package:easy_pedidos_flutter/services/pedido_service.dart';
import 'package:easy_pedidos_flutter/theme/app_theme.dart';
import 'package:easy_pedidos_flutter/viewmodels/list_pedido_viewmodel.dart';
import 'package:easy_pedidos_flutter/views/detalhes_pedido_page.dart';
import 'package:easy_pedidos_flutter/views/finalizar_pedido_page.dart';
import 'package:easy_pedidos_flutter/views/list_pedido_page.dart';
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
        ),
        ChangeNotifierProvider<ListPedidoViewModel>(
          create: (context) => ListPedidoViewModel(
            context.read<PedidoService>(),
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
        path: '/detalhes',
        builder: (context, state) {
          final pedido = state.extra as PedidoModel;
          return DetalhesPedidoPage(pedido: pedido);
        },
      ),
      GoRoute(
        path: '/finalizar',
        builder: (context, state) {
          final pedido = state.extra as PedidoModel;
          return FinalizarPedidoPage(pedido: pedido);
        },
      ),
    ],
  );
}
