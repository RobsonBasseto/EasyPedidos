using System.ComponentModel;

namespace Entidades.entidades
{
    public enum StatusPedidoEnum
    {
        [Description("Todos")]
        Todos,
        [Description("Em Preparo")]
        EmPreparo,
        [Description("Pronto")]
        Pronto,
        [Description("Faturado")]
        Faturado,
        [Description("Cancelado")]
        Cancelado
    }
}
