namespace Entidades.entidades
{
    public class ItemCardapio
    {
        public int Id { get; set; }
        public string Nome { get; set; }
        public decimal Preco { get; set; }
        public string Descricao => $"{Nome} - R$ {Preco:F2}";
    }
}
