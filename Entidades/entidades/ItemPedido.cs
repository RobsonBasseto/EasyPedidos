namespace Entidades.entidades
{
    public class ItemPedido
    {
        public int Id { get; set; }
        public string Nome { get; set; }
        public decimal Preco { get; set; }
        public int Quantidade { get; set; } = 1;
        public string Observacao { get; set; }
    }


}
