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
        }

        [ObservableProperty]
        private Pedido pedidoEditado;

        [ObservableProperty]
        private ItemCardapio itemSelecionado;

        [ObservableProperty]
        private int quantidadeNova = 1;

        public ObservableCollection<ItemCardapio> Cardapio { get; } = new();

        private void PopularCardapio()
        {
            Cardapio.Add(new ItemCardapio { Id = 1, Nome = "X-Burger", Preco = 15.00m });
            Cardapio.Add(new ItemCardapio { Id = 2, Nome = "X-Bacon", Preco = 18.00m });
            Cardapio.Add(new ItemCardapio { Id = 3, Nome = "X-Salada", Preco = 16.00m });
            Cardapio.Add(new ItemCardapio { Id = 4, Nome = "Batata Frita", Preco = 12.00m });
            Cardapio.Add(new ItemCardapio { Id = 5, Nome = "Refrigerante", Preco = 6.00m });
            Cardapio.Add(new ItemCardapio { Id = 6, Nome = "Suco", Preco = 8.00m });
        }

        [RelayCommand]
        private void AdicionarItem()
        {
            if (itemSelecionado == null || quantidadeNova <= 0) return;

            var novoItem = new ItemPedido
            {
                Id = itemSelecionado.Id,
                Nome = itemSelecionado.Nome,
                Preco = itemSelecionado.Preco,
                Quantidade = quantidadeNova
            };

            pedidoEditado.Itens.Add(novoItem);
            LimparCamposItem();
        }

        [RelayCommand]
        private void RemoverItem(ItemPedido item)
        {
            if (item != null)
            {
                pedidoEditado.Itens.Remove(item);
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
            // Aqui você salvaria as alterações no banco de dados
            // Por enquanto, apenas voltamos para a página anterior

            await Shell.Current.DisplayAlert("Sucesso", "Alterações salvas com sucesso!", "OK");
            await Shell.Current.GoToAsync("..");
        }

        [RelayCommand]
        private async Task Cancelar()
        {
            bool confirmar = await Shell.Current.DisplayAlert(
                "Confirmar",
                "Deseja cancelar as alterações?",
                "Sim", "Não");

            if (confirmar)
            {
                await Shell.Current.GoToAsync("..");
            }
        }
    }
}