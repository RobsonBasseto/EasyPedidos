// Entidades/Models/PedidoModel.cs
using CommunityToolkit.Mvvm.ComponentModel;
using EasyPedidos.Helpers;
using Entidades.entidades;
using System.Collections.ObjectModel;
using System.ComponentModel.DataAnnotations.Schema;

namespace Models
{
    public partial class PedidoModel : ObservableObject
    {
        [ObservableProperty]
        private int _id;

        [ObservableProperty]
        private DateTime _dataHora = DateTime.Now;

        [ObservableProperty]
        private StatusPedidoEnum _status = StatusPedidoEnum.EmAndamento;

        [ObservableProperty]
        private ObservableCollection<ItemPedidoModel> _itens = new();

        [ObservableProperty]
        private FormaPagamentoEnum? _formaPagamento;

        [ObservableProperty]
        private DateTime _dataFaturamento;

        [ObservableProperty]
        private LocalConsumoEnum _localConsumo = LocalConsumoEnum.NoLocal; // No Local, Retirada, Entrega

        [ObservableProperty]
        private bool _isMesa = true; // true = Mesa, false = Carro

        [ObservableProperty]
        private string _identificador = string.Empty; // Mesa ou Placa do Carro

        // Propriedades calculadas (atualizam automaticamente!)
        
        public decimal Total => Itens.Sum(i => i.Preco * i.Quantidade);

        
        public bool PodeEditar => Status == StatusPedidoEnum.EmAndamento || Status == StatusPedidoEnum.Pronto;

        
        public bool PodeFinalizar => Status == StatusPedidoEnum.Pronto;

        
        public string ItensResumido => string.Join(", ", Itens.Select(i => $"{i.Quantidade}x {i.Nome}"));
        
        public string StatusDescricao => Status.GetDescription();
        
        public string LocalConsumosDescricao => LocalConsumo.GetDescription();
        
        public bool MostrarTipoAtendimento => LocalConsumo != LocalConsumoEnum.Entrega;
        
        public string IdentificadorLabel => IsMesa ? "Mesa:" : "Carro:";
        partial void OnIsMesaChanged(bool value)
        {
            // Quando mudar o tipo de atendimento
            if (value)
            {
                // Virou MESA → limpa placa
                Identificador = string.Empty;
            }
            else
            {
                // Virou CARRO → limpa mesa
                Identificador = string.Empty;
            }
        }
    }
}