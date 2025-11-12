using CommunityToolkit.Mvvm.ComponentModel;

namespace Models
{
    public partial class ItemPedidoModel : ObservableObject
    {
        [ObservableProperty]
        private int _id;

        [ObservableProperty]
        private string _nome = string.Empty;

        [ObservableProperty]
        private decimal _preco;

        [ObservableProperty]
        private int _quantidade = 1;

        [ObservableProperty]
        private string _observacao = string.Empty;

        // Propriedades calculadas
        public decimal Subtotal => Preco * Quantidade;

        public string Resumo => $"{Quantidade}x {Nome} {(string.IsNullOrEmpty(Observacao) ? "" : $"({Observacao})")}";
    }
}