enum FormaPagamentoEnum {
  dinheiro,
  cartaoCredito,
  cartaoDebito,
  pix,
  outros;

  String get description {
    switch (this) {
      case FormaPagamentoEnum.dinheiro:
        return 'Dinheiro';
      case FormaPagamentoEnum.cartaoCredito:
        return 'Cartão de Crédito';
      case FormaPagamentoEnum.cartaoDebito:
        return 'Cartão de Débito';
      case FormaPagamentoEnum.pix:
        return 'PIX';
      case FormaPagamentoEnum.outros:
        return 'Outros';
    }
  }
}
