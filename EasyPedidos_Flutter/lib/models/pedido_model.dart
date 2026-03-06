import 'package:easy_pedidos_flutter/models/enums/forma_pagamento_enum.dart';
import 'package:easy_pedidos_flutter/models/enums/local_consumo_enum.dart';
import 'package:easy_pedidos_flutter/models/enums/status_pedido_enum.dart';
import 'package:easy_pedidos_flutter/models/item_pedido_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class PedidoModel extends Equatable {
  final int id;
  final DateTime dataHora;
  final StatusPedidoEnum status;
  final List<ItemPedidoModel> itens;
  final FormaPagamentoEnum? formaPagamento;
  final DateTime? dataFaturamento;
  final LocalConsumoEnum localConsumo;
  final bool isMesa;
  final String identificador;
  final double total;

  const PedidoModel({
    required this.id,
    required this.dataHora,
    this.status = StatusPedidoEnum.emPreparo,
    this.itens = const [],
    this.formaPagamento,
    this.dataFaturamento,
    this.localConsumo = LocalConsumoEnum.noLocal,
    this.isMesa = true,
    this.identificador = '',
    this.total = 0.0,
  });

  bool get podeEditar =>
      status == StatusPedidoEnum.emPreparo || status == StatusPedidoEnum.pronto;

  bool get podeFinalizar => status == StatusPedidoEnum.pronto;

  String get itensResumido =>
      itens.map((i) => '${i.quantidade}x ${i.nome}').join(', ');

  String get statusDescricao => status.description;

  String get localConsumoDescription => localConsumo.description;

  bool get mostrarTipoAtendimento => localConsumo != LocalConsumoEnum.entrega;

  String get identificadorLabel => isMesa ? 'Mesa:' : 'Carro:';

  Color get statusColor => status.color;

  factory PedidoModel.fromJson(Map<String, dynamic> json) {
    return PedidoModel(
      id: json['id'],
      dataHora: DateTime.parse(json['dataHora']),
      status: StatusPedidoEnum.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => StatusPedidoEnum.emPreparo,
      ),
      itens: (json['itens'] as List)
          .map((item) => ItemPedidoModel.fromJson(item))
          .toList(),
      formaPagamento: json['formaPagamento'] != null
          ? FormaPagamentoEnum.values.firstWhere(
              (e) => e.name == json['formaPagamento'],
              orElse: () => FormaPagamentoEnum.dinheiro,
            )
          : null,
      dataFaturamento: json['dataFaturamento'] != null
          ? DateTime.parse(json['dataFaturamento'])
          : null,
      localConsumo: LocalConsumoEnum.values.firstWhere(
        (e) => e.name == json['localConsumo'],
        orElse: () => LocalConsumoEnum.noLocal,
      ),
      isMesa: json['isMesa'] ?? true,
      identificador: json['identificador'] ?? '',
      total: (json['total'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dataHora': dataHora.toIso8601String(),
      'status': status.name,
      'itens': itens.map((item) => item.toJson()).toList(),
      'formaPagamento': formaPagamento?.name,
      'dataFaturamento': dataFaturamento?.toIso8601String(),
      'localConsumo': localConsumo.name,
      'isMesa': isMesa,
      'identificador': identificador,
      'total': total,
    };
  }

  @override
  List<Object?> get props => [
        id,
        dataHora,
        status,
        itens,
        formaPagamento,
        dataFaturamento,
        localConsumo,
        isMesa,
        identificador,
        total,
      ];

  PedidoModel copyWith({
    int? id,
    DateTime? dataHora,
    StatusPedidoEnum? status,
    List<ItemPedidoModel>? itens,
    FormaPagamentoEnum? formaPagamento,
    DateTime? dataFaturamento,
    LocalConsumoEnum? localConsumo,
    bool? isMesa,
    String? identificador,
    double? total,
  }) {
    return PedidoModel(
      id: id ?? this.id,
      dataHora: dataHora ?? this.dataHora,
      status: status ?? this.status,
      itens: itens ?? this.itens,
      formaPagamento: formaPagamento ?? this.formaPagamento,
      dataFaturamento: dataFaturamento ?? this.dataFaturamento,
      localConsumo: localConsumo ?? this.localConsumo,
      isMesa: isMesa ?? this.isMesa,
      identificador: identificador ?? this.identificador,
      total: total ?? this.total,
    );
  }
}
