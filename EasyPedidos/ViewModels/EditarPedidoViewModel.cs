using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Input;
using Entidades.entidades;
using System.Collections.ObjectModel;

namespace EasyPedidos.ViewModels
{
    [QueryProperty(nameof(PedidoEditado), "Pedido")]
    public partial class EditarPedidoViewModel : BaseViewModel
    {
        public EditarPedidoViewModel()
        {
            Title = "Editar Pedido";
            PopularCardapio();
            //PopularItensPedido();
        }
        partial void OnPedidoEditadoChanged(Pedido value)
        {
            if (value != null)
            {
                Title = $"Editando Pedido - {value.Mesa}";
                PopularItensPedido(); // Só chama aqui, quando o pedido não é nulo
            }
        }
        [ObservableProperty]
        private Pedido pedidoEditado;

        [ObservableProperty]
        private ItemCardapio itemSelecionado;

        [ObservableProperty]
        private int quantidadeNova = 1;

        [ObservableProperty]
        private decimal totalPedido;

        public ObservableCollection<ItemCardapio> Cardapio { get; } = new();
        public ObservableCollection<ItemPedido> ItensPedido { get; } = new();

        private void PopularCardapio()
        {
            Cardapio.Add(new ItemCardapio { Id = 1, Nome = "X-Burger", Preco = 15.00m });
            Cardapio.Add(new ItemCardapio { Id = 2, Nome = "X-Bacon", Preco = 18.00m });
            Cardapio.Add(new ItemCardapio { Id = 3, Nome = "X-Salada", Preco = 16.00m });
            Cardapio.Add(new ItemCardapio { Id = 4, Nome = "Batata Frita", Preco = 12.00m });
            Cardapio.Add(new ItemCardapio { Id = 5, Nome = "Refrigerante", Preco = 6.00m });
            Cardapio.Add(new ItemCardapio { Id = 6, Nome = "Suco", Preco = 8.00m });
        }
        private void PopularItensPedido()
        {
            foreach (var item in PedidoEditado.Itens)
            {
                ItensPedido.Add(item);
            }
            CalcularTotal();
        }

        [RelayCommand]
        private void AdicionarItem()
        {
            if (ItemSelecionado == null || QuantidadeNova <= 0)
                return;

            var itemPedido = new ItemPedido
            {
                Id = ItemSelecionado.Id,
                Nome = ItemSelecionado.Nome,
                Preco = ItemSelecionado.Preco,
                Quantidade = QuantidadeNova
            };

            ItensPedido.Add(itemPedido);
            CalcularTotal();
            LimparCamposItem();
        }

        [RelayCommand]
        private void RemoverItem(ItemPedido item)
        {
            if (item != null)
            {
                ItensPedido.Remove(item);
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
            PedidoEditado.Itens = ItensPedido.ToList();

            await Shell.Current.DisplayAlert("Sucesso", "Alterações salvas com sucesso!", "OK");
            await Shell.Current.GoToAsync("..");
        }

        [RelayCommand]
        private async Task Cancelar()
        {
            bool confirmar = await Shell.Current.DisplayAlert(
                "Confirmar",
                "Deseja cancelar o pedido?",
                "Sim", "Não");

            if (confirmar)
            {
                PedidoEditado.Status = StatusPedidoEnum.Cancelado;
                await Shell.Current.GoToAsync("..");
                MessagingCenter.Send(this, "PedidoAtualizado");
            }
        }

        private void CalcularTotal()
        {
            TotalPedido = ItensPedido.Sum(i => i.Preco * i.Quantidade);
        }
    }
}