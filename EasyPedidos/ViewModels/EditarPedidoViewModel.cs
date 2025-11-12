using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Input;
using Entidades.entidades;
using Models;
using System.Collections.ObjectModel;

namespace EasyPedidos.ViewModels
{
    [QueryProperty(nameof(Pedido), "Pedido")]
    public partial class EditarPedidoViewModel : BaseViewModel
    {
        public EditarPedidoViewModel()
        {
            Title = "Editar Pedido";
            PopularCardapio();
        }

        partial void OnPedidoChanged(PedidoModel value)
        {
            if (value != null)
            {
                Title = $"Editando Pedido - {value.Identificador}";
            }
        }

        [ObservableProperty]
        private PedidoModel _pedido;

        [ObservableProperty]
        private ItemCardapioModel _itemSelecionado;

        [ObservableProperty]
        private int _quantidadeNova = 1;

        public ObservableCollection<ItemCardapioModel> Cardapio { get; } = new();
        public List<LocalConsumoEnum> LocaisConsumo { get; } = new()
        {
            LocalConsumoEnum.NoLocal,
            LocalConsumoEnum.Retirada,
            LocalConsumoEnum.Entrega
        };
        private void PopularCardapio()
        {
            Cardapio.Add(new ItemCardapioModel { Id = 1, Nome = "X-Burger", Preco = 15.00m });
            Cardapio.Add(new ItemCardapioModel { Id = 2, Nome = "X-Bacon", Preco = 18.00m });
            Cardapio.Add(new ItemCardapioModel { Id = 3, Nome = "X-Salada", Preco = 16.00m });
            Cardapio.Add(new ItemCardapioModel { Id = 4, Nome = "Batata Frita", Preco = 12.00m });
            Cardapio.Add(new ItemCardapioModel { Id = 5, Nome = "Refrigerante", Preco = 6.00m });
            Cardapio.Add(new ItemCardapioModel { Id = 6, Nome = "Suco", Preco = 8.00m });
        }

        [RelayCommand]
        private void AdicionarItem()
        {
            if (ItemSelecionado == null || QuantidadeNova <= 0 || Pedido == null) return;

            var itemPedido = new ItemPedidoModel
            {
                Id = ItemSelecionado.Id,
                Nome = ItemSelecionado.Nome,
                Preco = ItemSelecionado.Preco,
                Quantidade = QuantidadeNova
            };

            Pedido.Itens.Add(itemPedido);
            LimparCamposItem();
        }

        [RelayCommand]
        private void RemoverItem(ItemPedidoModel item)
        {
            if (item != null && Pedido != null)
            {
                Pedido.Itens.Remove(item);
            }
        }

        private void LimparCamposItem()
        {
            ItemSelecionado = null;
            QuantidadeNova = 1;
        }

        [RelayCommand]
        private async Task SalvarAlteracoes()
        {
            if (Pedido == null) return;
            Pedido.Status = StatusPedidoEnum.EmAndamento;
            PedidoViewModel.AtualizarPedido(Pedido);
            await Shell.Current.DisplayAlert("Sucesso", "Alterações salvas!", "OK");
            await Shell.Current.GoToAsync("..", new Dictionary<string, object>
            {
                { "Pedido", Pedido }
            });
        }

        [RelayCommand]
        private async Task Cancelar()
        {
            bool confirmar = await Shell.Current.DisplayAlert(
                "Cancelar Pedido",
                "Deseja cancelar o pedido?",
                "Sim", "Não");

            if (confirmar && Pedido != null)
            {
                Pedido.Status = StatusPedidoEnum.Cancelado;
                PedidoViewModel.AtualizarPedido(Pedido);
                await Shell.Current.GoToAsync("..", new Dictionary<string, object>
                {
                    { "Pedido", Pedido }
                });
            }
        }
    }
}