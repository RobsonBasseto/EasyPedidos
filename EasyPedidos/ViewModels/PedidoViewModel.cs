using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Input;
using Entidades.entidades;
using Models;
using System.Collections.ObjectModel;

namespace EasyPedidos.ViewModels
{
    public partial class PedidoViewModel : BaseViewModel
    {
        private static List<PedidoModel> _pedidos = new();
        private static int _proximoId = 1;

        public PedidoViewModel()
        {
            Title = "Novo Pedido";
            PopularMesas();
            PopularCardapio();
            Pedido = new PedidoModel();
        }

        [ObservableProperty]
        private PedidoModel _pedido;

        [ObservableProperty]
        private string _mesaSelecionada;

        [ObservableProperty]
        private ItemCardapioModel _itemSelecionado;

        [ObservableProperty]
        private int _quantidade = 1;

        public ObservableCollection<string> Mesas { get; } = new();
        public ObservableCollection<ItemCardapioModel> Cardapio { get; } = new();
        public List<LocalConsumoEnum> LocaisConsumo { get; } = new()
        {
            LocalConsumoEnum.NoLocal,
            LocalConsumoEnum.Retirada,
            LocalConsumoEnum.Entrega
        };
        private void PopularMesas()
        {
            for (int i = 1; i <= 10; i++) Mesas.Add($"Mesa {i}");
        }

        private void PopularCardapio()
        {
            Cardapio.Add(new ItemCardapioModel { Id = 1, Nome = "X-Burger", Preco = 15.00m });
            Cardapio.Add(new ItemCardapioModel { Id = 2, Nome = "X-Bacon", Preco = 18.00m });
            Cardapio.Add(new ItemCardapioModel { Id = 3, Nome = "X-Salada", Preco = 16.00m });
            Cardapio.Add(new ItemCardapioModel { Id = 4, Nome = "Batata Frita", Preco = 12.00m });
            Cardapio.Add(new ItemCardapioModel { Id = 5, Nome = "Refrigerante", Preco = 6.00m });
            Cardapio.Add(new ItemCardapioModel { Id = 6, Nome = "Suco", Preco = 8.00m });
        }

        partial void OnMesaSelecionadaChanged(string value)
        {
            if (Pedido != null) Pedido.Identificador = value;
        }

        [RelayCommand]
        private void AdicionarItem()
        {
            if (ItemSelecionado == null || Quantidade <= 0 || Pedido == null) return;

            var item = new ItemPedidoModel
            {
                Id = ItemSelecionado.Id,
                Nome = ItemSelecionado.Nome,
                Preco = ItemSelecionado.Preco,
                Quantidade = Quantidade
            };

            Pedido.Itens.Add(item);
            LimparCamposItem();
        }

        [RelayCommand]
        private void RemoverItem(ItemPedidoModel item)
        {
            if (item != null && Pedido != null)
                Pedido.Itens.Remove(item);
        }

        private void LimparCamposItem()
        {
            ItemSelecionado = null;
            Quantidade = 1;
        }

        [RelayCommand]
        private async Task SalvarPedido()
        {
            if (string.IsNullOrEmpty(Pedido?.Identificador))
            {
                await Shell.Current.DisplayAlert("Erro", "Selecione uma mesa.", "OK");
                return;
            }
            if (!Pedido.Itens.Any())
            {
                await Shell.Current.DisplayAlert("Erro", "Adicione pelo menos um item.", "OK");
                return;
            }

            Pedido.Id = _proximoId++;
            Pedido.DataHora = DateTime.Now;
            Pedido.Status = StatusPedidoEnum.EmAndamento;

            _pedidos.Add(Pedido);
            MessagingCenter.Send(this, "PedidoAtualizado", Pedido);

            await Shell.Current.DisplayAlert("Sucesso", $"Pedido #{Pedido.Id} criado!", "OK");

            // Limpa para novo
            Pedido = new PedidoModel();
            await Shell.Current.GoToAsync("..");
        }

        [RelayCommand]
        private async Task Cancelar()
        {
            bool ok = await Shell.Current.DisplayAlert("Cancelar", "Descartar pedido?", "Sim", "Não");
            if (ok) await Shell.Current.GoToAsync("..");
        }

        public static List<PedidoModel> ObterPedidos() => _pedidos;
        public static void AtualizarPedido(PedidoModel pedidoAtualizado)
        {
            var existente = _pedidos.FirstOrDefault(p => p.Id == pedidoAtualizado.Id);
            if (existente != null)
            {
                existente.Status = pedidoAtualizado.Status;
                existente.Itens = pedidoAtualizado.Itens;
                existente.FormaPagamento = pedidoAtualizado.FormaPagamento;
                existente.DataFaturamento = pedidoAtualizado.DataFaturamento;
            }
        }
    }
}