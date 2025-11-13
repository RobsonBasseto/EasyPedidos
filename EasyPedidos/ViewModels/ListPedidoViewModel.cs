using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Input;
using CommunityToolkit.Mvvm.Messaging;
using EasyPedidos.Helpers;
using EasyPedidos.Pages;
using Entidades.entidades;
using Models;
using System.Collections.ObjectModel;

namespace EasyPedidos.ViewModels
{
    public partial class ListPedidoViewModel : BaseViewModel
    {
        public ListPedidoViewModel()
        {
            Title = "Pedidos";
            FiltroSelecionado = StatusPedidoEnum.EmPreparo;
            CarregarPedidos();

            WeakReferenceMessenger.Default.Register<PedidoAtualizadoMessage>(this, (r, m) =>
            {
                CarregarPedidos();
            });
        }

        ~ListPedidoViewModel()
        {
            MessagingCenter.Unsubscribe<object, PedidoModel>(this, "PedidoAtualizado");
        }

        [ObservableProperty]
        private ObservableCollection<PedidoModel> _pedidos = new();

        [ObservableProperty]
        private ObservableCollection<PedidoModel> _todosPedidos = new();

        [ObservableProperty]
        private StatusPedidoEnum _filtroSelecionado;

        public List<StatusPedidoEnum> Filtros { get; } = new()
        {
            StatusPedidoEnum.Todos,
            StatusPedidoEnum.EmPreparo,
            StatusPedidoEnum.Pronto,
            StatusPedidoEnum.Faturado
        };

        partial void OnFiltroSelecionadoChanged(StatusPedidoEnum value) => AplicarFiltro();

        [RelayCommand]
        private void CarregarPedidos()
        {
            TodosPedidos.Clear();
            var pedidos = PedidoViewModel.ObterPedidos();
            foreach (var p in pedidos) TodosPedidos.Add(p);
            AplicarFiltro();
        }

        private void AplicarFiltro()
        {
            var filtrados = FiltroSelecionado switch
            {
                StatusPedidoEnum.EmPreparo => TodosPedidos.Where(p => p.Status == StatusPedidoEnum.EmPreparo),
                StatusPedidoEnum.Pronto => TodosPedidos.Where(p => p.Status == StatusPedidoEnum.Pronto),
                StatusPedidoEnum.Faturado => TodosPedidos.Where(p => p.Status == StatusPedidoEnum.Faturado),
                StatusPedidoEnum.Todos => TodosPedidos,
                _ => TodosPedidos
            };

            // FORÇA RECRIAÇÃO DA COLEÇÃO VISÍVEL
            Pedidos = new ObservableCollection<PedidoModel>(filtrados.OrderByDescending(p => p.DataHora));

            Title = $"Pedidos - {FiltroSelecionado.GetDescription()}";
        }

        [RelayCommand]
        private async Task VisualizarPedido(PedidoModel pedido)
        {
            if (pedido == null) return;
            await Shell.Current.GoToAsync(nameof(DetalhesPedidoPage), new Dictionary<string, object>
            {
                { "Pedido", pedido }
            });
        }

        [RelayCommand]
        private async Task FinalizarPedido(PedidoModel pedido)
        {
            if (pedido?.Status != StatusPedidoEnum.Pronto)
            {
                await Shell.Current.DisplayAlert("Bloqueado", "Apenas pedidos PRONTOS podem ser finalizados.", "OK");
                return;
            }

            await Shell.Current.GoToAsync(nameof(FinalizarPedidoPage), new Dictionary<string, object>
            {
                { "Pedido", pedido }
            });
        }

        [RelayCommand]
        private void AtualizarLista() => AplicarFiltro();
    }

    public static class ObservableCollectionExtensions
    {
        public static void AddRange<T>(this ObservableCollection<T> collection, IEnumerable<T> items)
        {
            foreach (var item in items) collection.Add(item);
        }
    }
}