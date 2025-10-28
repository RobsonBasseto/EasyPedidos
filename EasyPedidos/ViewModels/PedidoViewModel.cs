using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Input;
using Entidades.entidades;
using System.Collections.ObjectModel;

namespace EasyPedidos.ViewModels
{
    public partial class PedidoViewModel : BaseViewModel
    {
        public PedidoViewModel()
        {
            Title = "Novo Pedido";
            PopularCardapio();
            PopularMesas();
        }

        // Dados em memória
        private static List<Pedido> _pedidos = new();
        private static int _proximoId = 1;

        [ObservableProperty]
        private string mesaSelecionada;

        [ObservableProperty]
        private ItemCardapio itemSelecionado;

        [ObservableProperty]
        private int quantidade = 1;

        [ObservableProperty]
        private decimal totalPedido;


        public ObservableCollection<string> Mesas { get; } = new();
        public ObservableCollection<ItemCardapio> Cardapio { get; } = new();
        public ObservableCollection<ItemPedido> ItensPedido { get; } = new();

        private void PopularMesas()
        {
            for (int i = 1; i <= 10; i++)
            {
                Mesas.Add($"Mesa {i}");
            }
        }

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
            if (ItemSelecionado == null || Quantidade <= 0)
                return;

            var itemPedido = new ItemPedido
            {
                Id = ItemSelecionado.Id,
                Nome = ItemSelecionado.Nome,
                Preco = ItemSelecionado.Preco,
                Quantidade = Quantidade
            };

            ItensPedido.Add(itemPedido);
            CalcularTotal();
            LimparCamposItem();
        }

        [RelayCommand]
        private void RemoverItem(ItemPedido item)
        {
            ItensPedido.Remove(item);
            CalcularTotal();
        }

        private void CalcularTotal()
        {
            TotalPedido = ItensPedido.Sum(i => i.Preco * i.Quantidade);
        }

        private void LimparCamposItem()
        {
            ItemSelecionado = null;
            Quantidade = 1;
        }

        [RelayCommand]
        private async Task FinalizarPedido()
        {
            if (string.IsNullOrEmpty(MesaSelecionada))
            {
                await Shell.Current.DisplayAlert("Erro", "Selecione uma mesa", "OK");
                return;
            }

            if (!ItensPedido.Any())
            {
                await Shell.Current.DisplayAlert("Erro", "Adicione itens ao pedido", "OK");
                return;
            }

            try
            {
                IsBusy = true;

                var pedido = new Pedido
                {
                    Id = _proximoId++,
                    Mesa = MesaSelecionada,
                    Itens = new List<ItemPedido>(ItensPedido),
                    Status = StatusPedidoEnum.EmAndamento,
                    DataHora = DateTime.Now
                };

                _pedidos.Add(pedido);

                await Shell.Current.DisplayAlert("Sucesso",
                    $"Pedido #{pedido.Id} para {MesaSelecionada} criado!\nTotal: R$ {TotalPedido:F2}", "OK");

                // Limpar dados para próximo pedido
                ItensPedido.Clear();
                MesaSelecionada = null;
                TotalPedido = 0;

                await Shell.Current.GoToAsync("..");
            }
            catch (Exception ex)
            {
                await Shell.Current.DisplayAlert("Erro", ex.Message, "OK");
            }
            finally
            {
                IsBusy = false;
            }
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
                await Shell.Current.GoToAsync("..");
            }
        }

        // Método estático para acessar os pedidos de outros ViewModels
        public static List<Pedido> ObterPedidos() => _pedidos;

    }
}