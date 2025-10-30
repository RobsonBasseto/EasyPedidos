using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Input;
using EasyPedidos.Pages;
using Entidades.entidades;

namespace EasyPedidos.ViewModels
{
    [QueryProperty(nameof(PedidoSelecionado), "Pedido")]
    public partial class DetalhesPedidoViewModel : BaseViewModel
    {
        public DetalhesPedidoViewModel()
        {
            Title = "Detalhes do Pedido";
        }

        [ObservableProperty]
        private Pedido pedidoSelecionado;

        [RelayCommand]
        private async Task Voltar()
        {
            await Shell.Current.GoToAsync("..");
        }
         
        [RelayCommand]
        private async Task EditarPedido()
        {
            if (PedidoSelecionado == null) return;

            var parameters = new Dictionary<string, object>
            {
                { "Pedido", PedidoSelecionado }
            };

            await Shell.Current.GoToAsync(nameof(EditarPedidoPage), parameters);
        }

        [RelayCommand]
        private async Task ConcluirPedido()
        {
            bool confirmar = await Shell.Current.DisplayAlert(
                "Confirmar",
                "Deseja Concluir o Pedido?",
                "Sim", "Não");

            if (confirmar)
            {
                PedidoSelecionado.Status = StatusPedidoEnum.Pronto;
                await Shell.Current.GoToAsync("..");
                MessagingCenter.Send(this, "PedidoAtualizado");

            }

        }
    }
}