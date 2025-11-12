using System.ComponentModel;

namespace Entidades.entidades
{
    public enum FormaPagamentoEnum
    {
        [Description("Dinheiro")]
        Dinheiro,

        [Description("Cartão de Crédito")]
        CartaoCredito,

        [Description("Cartão de Débito")]
        CartaoDebito,

        [Description("Pix")]
        Pix
    }
}
