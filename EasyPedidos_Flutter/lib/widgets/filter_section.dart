import 'package:easy_pedidos_flutter/models/enums/status_pedido_enum.dart';
import 'package:easy_pedidos_flutter/theme/app_theme.dart';
import 'package:flutter/material.dart';

class FilterSection extends StatelessWidget {
  final StatusPedidoEnum selectedFilter;
  final List<StatusPedidoEnum> filters;
  final ValueChanged<StatusPedidoEnum?> onFilterChanged;
  final int pedidoCount;

  const FilterSection({
    Key? key,
    required this.selectedFilter,
    required this.filters,
    required this.onFilterChanged,
    required this.pedidoCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppTheme.border),
        ),
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Filtrar Pedidos',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryOrange,
              ),
            ),
            const SizedBox(height: 14),

            // Dropdown de Filtro
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: AppTheme.lightBackground,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFDDDDDD)),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<StatusPedidoEnum>(
                  isExpanded: true,
                  value: selectedFilter,
                  items: filters.map((StatusPedidoEnum value) {
                    return DropdownMenuItem<StatusPedidoEnum>(
                      value: value,
                      child: Text(
                        value.description,
                        style: const TextStyle(
                          color: AppTheme.primaryText,
                          fontSize: 15,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: onFilterChanged,
                ),
              ),
            ),

            const SizedBox(height: 14),

            // Contador
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.lightOrange,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.lightOrangeBorder),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('📋', style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 10),
                  Text(
                    '$pedidoCount pedido(s) encontrado(s)',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryOrange,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
