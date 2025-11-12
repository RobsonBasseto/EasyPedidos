using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Input;
using CommunityToolkit.Mvvm.Messaging;
using EasyPedidos.Helpers;
using EasyPedidos.Pages;
using Entidades.entidades;
using Models;

namespace EasyPedidos.ViewModels
{
    [QueryProperty(nameof(Pedido), "Pedido")]
    public partial class DetalhesPedidoViewModel : BaseViewModel
    {
        public DetalhesPedidoViewModel()
        {
            Title = "Detalhes do Pedido";
        }

        [ObservableProperty]
        private PedidoModel _pedido;

        [RelayCommand]
        private async Task Voltar() 
        {
            WeakReferenceMessenger.Default.Send(new PedidoAtualizadoMessage(Pedido));
            await Shell.Current.GoToAsync(".."); 
        }

        [RelayCommand]
        private async Task EditarPedido()
        {
            if (Pedido == null) return;
            await Shell.Current.GoToAsync(nameof(EditarPedidoPage), new Dictionary<string, object>
            {
                { "Pedido", Pedido }
            });
        }

        [RelayCommand]
        private async Task ConcluirPedido()
        {
            if (Pedido == null) return;

            bool confirmar = await Shell.Current.DisplayAlert(
                "Concluir Pedido",
                $"Deseja marcar o pedido da {Pedido.Identificador} como PRONTO?",
                "Sim", "Não");

            if (confirmar)
            {
                Pedido.Status = StatusPedidoEnum.Pronto;

                WeakReferenceMessenger.Default.Send(new PedidoAtualizadoMessage(Pedido));
                await Shell.Current.GoToAsync("..");
            }
        }
    }
}