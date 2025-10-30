using System.ComponentModel.DataAnnotations.Schema;

namespace Entidades.entidades
{
    public class Pedido
    {
        public int Id { get; set; }
        public string Mesa { get; set; }
        public DateTime DataHora { get; set; } = DateTime.Now;
        public StatusPedidoEnum Status { get; set; } = StatusPedidoEnum.EmAndamento;
        public List<ItemPedido> Itens { get; set; } = new();
        public FormaPagamentoEnum? FormaPagamento { get; set; }
        public decimal Total => Itens.Sum(i => i.Preco * i.Quantidade);

        [NotMapped]
        public bool PodeEditar { get => Status == StatusPedidoEnum.EmAndamento || Status == StatusPedidoEnum.Pronto ? true : false; }
    }

}
