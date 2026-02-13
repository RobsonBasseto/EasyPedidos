enum LocalConsumoEnum {
  noLocal,
  retirada,
  entrega;

  String get description {
    switch (this) {
      case LocalConsumoEnum.noLocal:
        return 'No Local';
      case LocalConsumoEnum.retirada:
        return 'Retirada';
      case LocalConsumoEnum.entrega:
        return 'Entrega';
    }
  }
}
