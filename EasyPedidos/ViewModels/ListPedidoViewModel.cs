using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Input;
using EasyPedidos.Helpers;
using EasyPedidos.Pages;
using Entidades.entidades;
using System.Collections.ObjectModel;

namespace EasyPedidos.ViewModels
{
    public partial class ListPedidoViewModel : BaseViewModel
    {
        public ListPedidoViewModel()
        {
            Title = "Pedidos";
            FiltroSelecionado = StatusPedidoEnum.EmAndamento;
            CarregarPedidos();

            MessagingCenter.Subscribe<DetalhesPedidoViewModel>(this, "PedidoAtualizado", (sender) =>
            {
                AplicarFiltro();
            });
            MessagingCenter.Subscribe<EditarPedidoViewModel>(this, "PedidoAtualizado", (sender) =>
            {
                AplicarFiltro();
            });
        }

        [ObservableProperty]
        private ObservableCollection<Pedido> pedidos = new();

        [ObservableProperty]
        private ObservableCollection<Pedido> todosPedidos = new();

        [ObservableProperty]
        private StatusPedidoEnum filtroSelecionado;

        public List<StatusPedidoEnum> Filtros { get; } = new List<StatusPedidoEnum>
        {
            StatusPedidoEnum.Todos,
            StatusPedidoEnum.EmAndamento,
            StatusPedidoEnum.Pronto,
            StatusPedidoEnum.Faturado
        };

        partial void OnFiltroSelecionadoChanged(StatusPedidoEnum value)
        {
            AplicarFiltro();
        }

        [RelayCommand]
        private void CarregarPedidos()
        {
            if (!todosPedidos.Any())
            {
                var list = PedidoViewModel.ObterPedidos();
                foreach (var item in list)
                {
                    todosPedidos.Add(item);
                }
                AplicarFiltro();
            }
        }

        private void AplicarFiltro()
        {
            if (todosPedidos == null || !todosPedidos.Any())
                return;

            var pedidosFiltrados = FiltroSelecionado switch
            {
                StatusPedidoEnum.EmAndamento => todosPedidos.Where(p => p.Status == StatusPedidoEnum.EmAndamento),
                StatusPedidoEnum.Pronto => todosPedidos.Where(p => p.Status == StatusPedidoEnum.Pronto),
                StatusPedidoEnum.Faturado => todosPedidos.Where(p => p.Status == StatusPedidoEnum.Faturado),
                StatusPedidoEnum.Todos => todosPedidos,
                _ => todosPedidos.Where(p => p.Status == StatusPedidoEnum.EmAndamento)
            };

            pedidos.Clear();
            foreach (var pedido in pedidosFiltrados)
            {
                pedidos.Add(pedido);
            }

            Title = $"Pedidos - {FiltroSelecionado.GetDescription()}";
        }

        [RelayCommand]
        private async Task VisualizarPedido(Pedido pedido)
        {
            if (pedido == null) return;

            var parameters = new Dictionary<string, object>
            {
                { "Pedido", pedido }
            };

            await Shell.Current.GoToAsync(nameof(DetalhesPedidoPage), parameters);
        }

        [RelayCommand]
        private async Task EditarPedido(Pedido pedido)
        {
            if (pedido == null) return;

            // REGRA: Só permite editar pedidos Em Andamento ou Prontos
            if (pedido.Status != StatusPedidoEnum.EmAndamento && pedido.Status != StatusPedidoEnum.Pronto)
            {
                await Shell.Current.DisplayAlert(
                    "Edição Bloqueada",
                    $"Não é possível editar pedidos com status '{pedido.Status.GetDescription()}'. " +
                    "Apenas pedidos 'Em Andamento' ou 'Prontos' podem ser editados.",
                    "OK");
                return;
            }

            var parameters = new Dictionary<string, object>
            {
                { "Pedido", pedido }
            };

            await Shell.Current.GoToAsync(nameof(EditarPedidoPage), parameters);
        }

        [RelayCommand]
        private void AtualizarLista()
        {
            AplicarFiltro();
        }

        // Método auxiliar para verificar se pode editar (usado no XAML)
        public bool PodeEditarPedido(Pedido pedido)
        {
            return pedido?.Status == StatusPedidoEnum.EmAndamento ||
                   pedido?.Status == StatusPedidoEnum.Pronto;
        }
    }
}