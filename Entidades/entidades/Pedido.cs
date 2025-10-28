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
        public string Observacao { get; set; }
        public decimal Total => Itens.Sum(i => i.Preco * i.Quantidade);
    }

}
