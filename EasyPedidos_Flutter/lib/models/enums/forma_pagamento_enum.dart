enum FormaPagamentoEnum {
  dinheiro,
  cartaoCredito,
  cartaoDebito,
  pix;

  String get description {
    switch (this) {
      case FormaPagamentoEnum.dinheiro:
        return 'Dinheiro';
      case FormaPagamentoEnum.cartaoCredito:
        return 'Cartão de Crédito';
      case FormaPagamentoEnum.cartaoDebito:
        return 'Cartão de Débito';
      case FormaPagamentoEnum.pix:
        return 'Pix';
    }
  }
}
