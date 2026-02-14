import 'package:easy_pedidos_flutter/models/pedido_model.dart';
import 'package:easy_pedidos_flutter/theme/app_theme.dart';
import 'package:easy_pedidos_flutter/utils/date_formatter.dart';
import 'package:easy_pedidos_flutter/widgets/status_badge.dart';
import 'package:flutter/material.dart';

class PedidoCard extends StatelessWidget {
  final PedidoModel pedido;
  final VoidCallback onTap;
  final VoidCallback? onFinalizar;

  const PedidoCard({
    Key? key,
    required this.pedido,
    required this.onTap,
    this.onFinalizar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header do pedido
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text('📦', style: TextStyle(fontSize: 14)),
                          const SizedBox(width: 6),
                          Text(
                            pedido.identificador,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryText,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(
                          pedido.localConsumoDescription,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppTheme.secondaryText,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    const Text('🕒', style: TextStyle(fontSize: 12)),
                    const SizedBox(width: 6),
                    Text(
                      DateFormatter.formatarHora(pedido.dataHora),
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.secondaryText,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Itens do pedido
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppTheme.lightBackground,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(12),
              child: Text(
                pedido.itensResumido,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF555555),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Status e ações
            Row(
              children: [
                StatusBadge(status: pedido.status),
                const Spacer(),

                // Botão Finalizar
                if (pedido.podeFinalizar && onFinalizar != null)
                  ElevatedButton(
                    onPressed: onFinalizar,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4CAF50),
                      foregroundColor: Colors.white,
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      minimumSize: const Size(36, 36),
                    ),
                    child: const Text('Finalizar'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
