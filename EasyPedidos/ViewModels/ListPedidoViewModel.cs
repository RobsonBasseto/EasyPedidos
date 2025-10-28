using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Input;
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
            CarregarPedidos();
        }

        [ObservableProperty]
        private ObservableCollection<Pedido> pedidos = new();

        [RelayCommand]
        private void CarregarPedidos()
        {
            // Dados de exemplo
            if (!pedidos.Any()) // Use o campo privado (minúsculo)
            {
                var list = PedidoViewModel.ObterPedidos();
                foreach(var item in list)
                {
                    pedidos.Add(item);
                }
            }
        }

        [RelayCommand]
        private async Task VisualizarPedido(Pedido pedido)
        {
            if (pedido == null) return;

            var parameters = new Dictionary<string, object>
            {
                { "PedidoSelecionado", pedido }
            };

            await Shell.Current.GoToAsync(nameof(DetalhesPedidoPage), parameters);
        }
        [RelayCommand]
        private async Task EditarPedido(Pedido pedido)
        {
            if (pedido == null) return;

            var parameters = new Dictionary<string, object>
            {
                { "Pedido", pedido }
            };

            await Shell.Current.GoToAsync(nameof(EditarPedidoPage), parameters);
        }

        [RelayCommand]
        private async Task AtualizarStatus(Pedido pedido)
        {
            if (pedido == null) return;

            var action = await Shell.Current.DisplayActionSheet(
                $"Atualizar status - {pedido.Mesa}",
                "Cancelar",
                null,
                "Na Chapa",
                "Pronto",
                "Entregue",
                "Faturado");

            if (action != "Cancelar" && action != null)
            {
                pedido.Status = action switch
                {
                    "Pronto" => StatusPedidoEnum.Pronto,
                    "Faturado" => StatusPedidoEnum.Faturado,
                    _ => pedido.Status
                };
            }
        }
    }
}