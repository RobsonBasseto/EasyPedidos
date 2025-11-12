// Entidades/Models/ItemCardapioModel.cs
using CommunityToolkit.Mvvm.ComponentModel;

namespace Models
{
    public partial class ItemCardapioModel : ObservableObject
    {
        [ObservableProperty]
        private int _id;

        [ObservableProperty]
        private string _nome = string.Empty;

        [ObservableProperty]
        private decimal _preco;

        // Propriedade calculada (atualiza automaticamente se Nome ou Preco mudarem)
        public string Descricao => $"{Nome} - R$ {Preco:F2}";
    }
}