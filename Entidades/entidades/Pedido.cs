using System.ComponentModel.DataAnnotations.Schema;

namespace Entidades.entidades
{
    public class Pedido
    {
        public int Id { get; set; }
        public string Identificador { get; set; }
        public DateTime DataHora { get; set; } = DateTime.Now;
        public StatusPedidoEnum Status { get; set; } = StatusPedidoEnum.EmPreparo;
        public List<ItemPedido> Itens { get; set; } = new();
        public FormaPagamentoEnum? FormaPagamento { get; set; }
        public DateTime DataFaturamento { get; set; }
    }

}
